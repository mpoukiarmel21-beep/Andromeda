#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <spawn.h>
#import <CoreFoundation/CoreFoundation.h>

#import "../common.h"

@interface AndromedaRootListController : PSListController
@end

static NSMutableDictionary* AndromedaLoadPrefs(void);
static void AndromedaSavePrefs(NSMutableDictionary* prefs);

@implementation AndromedaRootListController

- (NSArray*)specifiers {
    if(!_specifiers) {
        NSArray* loaded = [self loadSpecifiersFromPlistName:@"Root" target:self];
        NSMutableArray* merged = [NSMutableArray array];
        for(PSSpecifier* spec in loaded) {
            [merged addObject:spec];
            if([[spec name] isEqualToString:@"Logs & Debug"]) {
                [merged addObject:[self logLevelSpecifier]];
            }
        }
        _specifiers = merged;
    }
    return _specifiers;
}

- (PSSpecifier*)specifierForKey:(NSString*)key {
    for(PSSpecifier* spec in _specifiers) {
        if([[spec propertyForKey:@"key"] isEqualToString:key]) return spec;
    }
    return nil;
}

- (PSSpecifier*)menuButtonForKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue action:(SEL)action {
    NSString* current = AndromedaLoadPrefs()[key];
    if(!current) current = defaultValue;
    NSString* label = current ? [NSString stringWithFormat:@"%@ (%@)", title, [current capitalizedString]] : title;
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:label target:self
        set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
    [spec setProperty:key forKey:@"key"];
    [spec setButtonAction:action];
    return spec;
}

- (PSSpecifier*)logLevelSpecifier {
    return [self menuButtonForKey:@"Log_Level" title:@"Log Level" defaultValue:@"info" action:@selector(pickLogLevel)];
}

- (void)pickLogLevel {
    [self showValuePickerForKey:@"Log_Level" title:@"Log Level"
        options:@{ @"None": @"none", @"Errors": @"errors", @"Info": @"info", @"Verbose": @"verbose" }
        defaultValue:@"info"];
}

- (void)showValuePickerForKey:(NSString*)key title:(NSString*)title
                      options:(NSDictionary<NSString*,NSString*>*)options
                 defaultValue:(NSString*)defaultValue {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSString* current = AndromedaLoadPrefs()[key];
    if(!current) current = defaultValue;

    for(NSString* display in options) {
        NSString* value = options[display];
        NSString* optTitle = (current && [current isEqualToString:value])
            ? [display stringByAppendingString:@" ✓"] : display;
        [alert addAction:[UIAlertAction actionWithTitle:optTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            NSMutableDictionary* prefs = AndromedaLoadPrefs();
            prefs[key] = value;
            AndromedaSavePrefs(prefs);
            PSSpecifier* spec = [self specifierForKey:key];
            if(spec) {
                [spec setName:[NSString stringWithFormat:@"%@ (%@)", title, display]];
                [self reloadSpecifiers];
            }
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
        alert.popoverPresentationController.permittedArrowDirections = 0;
    }

    [self presentViewController:alert animated:YES completion:nil];
}

static NSMutableDictionary* AndromedaLoadPrefs(void) {
    NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    if (!prefs) prefs = [NSMutableDictionary dictionary];
    return prefs;
}

static void AndromedaSavePrefs(NSMutableDictionary* prefs) {
    [prefs writeToFile:@ANDROMEDA_PREFS atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.andromeda.bypass/settingsChanged"), NULL, NULL, YES);
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    if (!key) return nil;
    id value = AndromedaLoadPrefs()[key];
    if (!value) value = [specifier propertyForKey:@"default"];
    return value;
}

- (void)respring {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Andromeda"
        message:@"Respring now to apply changes?"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        [self performRespring];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)performRespring {
    pid_t pid;
    NSString* sbreloadPath = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/jb/usr/bin/sbreload"] ? @"/var/jb/usr/bin/sbreload" : @"/usr/bin/sbreload";
    const char* args[] = { "sbreload", NULL };
    posix_spawn(&pid, [sbreloadPath UTF8String], NULL, NULL, (char* const*)args, NULL);
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    if (key) {
        NSMutableDictionary* prefs = AndromedaLoadPrefs();
        prefs[key] = value;
        AndromedaSavePrefs(prefs);
    }

    if(!key || [key isEqualToString:@"Global_AutoRespring"]) return;

    BOOL autoRespring = [[AndromedaLoadPrefs() objectForKey:@"Global_AutoRespring"] boolValue];

    if(autoRespring) {
        static BOOL s_respringScheduled = NO;
        if(!s_respringScheduled) {
            s_respringScheduled = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                s_respringScheduled = NO;
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Andromeda"
                    message:@"Settings applied. Respring now?"
                    preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
                    [self performRespring];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }

    if([[AndromedaLoadPrefs() objectForKey:@"Global_NotifyOnChange"] boolValue]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Andromeda"
            message:@"Settings applied. Change will take effect after respring."
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)openGitHub {
    NSURL *url = [NSURL URLWithString:@"https://github.com/mpoukiarmel21-beep/Andromeda"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
