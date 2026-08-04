#import <Preferences/Preferences.h>
#import <spawn.h>
#import <CoreFoundation/CoreFoundation.h>

#import "../common.h"

@interface AndromedaRootListController : PSListController
@end

@implementation AndromedaRootListController

- (NSArray*)specifiers {
    if(!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
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

- (void)scanStatus {
    Class scannerClass = NSClassFromString(@"AdaptiveScanner");
    NSArray *selectors = @[];
    NSArray *classes = @[];

    if (scannerClass) {
        id scanner = [scannerClass performSelector:@selector(sharedInstance)];
        if (scanner) {
            selectors = [scanner performSelector:@selector(lastDetectedSelectors)] ?: @[];
            classes = [scanner performSelector:@selector(lastDetectedClasses)] ?: @[];
        }
    }

    NSString *message;
    if (selectors.count == 0 && classes.count == 0) {
        message = @"No detections found yet.\n\nEnable Adaptive Mode, then launch a protected app to trigger a scan.";
    } else {
        NSMutableString *selList = [NSMutableString string];
        for (NSString *s in selectors) {
            [selList appendFormat:@"  %@\n", s];
        }
        message = [NSString stringWithFormat:
            @"Last scan results:\n\n"
            @"%lu selectors hooked\n"
            @"%lu suspicious classes found\n\n"
            @"Hooked selectors:\n%@",
            (unsigned long)selectors.count,
            (unsigned long)classes.count,
            selList];
    }

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Adaptive Scan Status"
        message:message
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)regenProfile {
    NSArray* models = @[@"iPhone12,1", @"iPhone12,3", @"iPhone13,1", @"iPhone13,2", @"iPhone14,2", @"iPhone14,3", @"iPhone15,2", @"iPhone15,3", @"iPhone15,4", @"iPhone16,1", @"iPhone16,2", @"iPhone17,1", @"iPhone17,2"];
    NSArray* versions = @[@"17.7.2", @"18.0.1", @"18.1", @"18.2", @"18.3.1", @"18.4.1", @"18.5", @"18.6"];
    NSArray* builds = @[@"21H209", @"22A3370", @"22B83", @"22C150", @"22D63", @"22E240", @"22E245", @"22F76"];
    NSString* hex = @"0123456789ABCDEF";
    NSString* alnum = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    NSMutableString* serial = [NSMutableString stringWithCapacity:12];
    for(int i = 0; i < 12; i++) [serial appendFormat:@"%C", [alnum characterAtIndex:arc4random_uniform((uint32_t)alnum.length)]];

    NSMutableString* udid = [NSMutableString stringWithCapacity:40];
    for(int i = 0; i < 40; i++) [udid appendFormat:@"%C", [hex characterAtIndex:arc4random_uniform(16)]];

    NSMutableString* ecid = [NSMutableString stringWithCapacity:16];
    for(int i = 0; i < 16; i++) [ecid appendFormat:@"%C", [hex characterAtIndex:arc4random_uniform(16)]];

    NSMutableString* mlb = [NSMutableString stringWithCapacity:15];
    [mlb appendString:@"F2LQ"];
    for(int i = 0; i < 11; i++) [mlb appendFormat:@"%C", [alnum characterAtIndex:arc4random_uniform((uint32_t)alnum.length)]];

    NSString* mac1 = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
        arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),
        arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)];
    NSString* mac2 = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
        arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256),
        arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)];

    NSString* model = models[arc4random_uniform((uint32_t)models.count)];
    NSString* version = versions[arc4random_uniform((uint32_t)versions.count)];
    NSString* build = builds[arc4random_uniform((uint32_t)builds.count)];

    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.andromeda.bypass"];
    [defaults setObject:model forKey:@"Spoof_Model"];
    [defaults setObject:model forKey:@"Spoof_ProductType"];
    [defaults setObject:model forKey:@"Spoof_MachineName"];
    [defaults setObject:serial forKey:@"Spoof_SerialNumber"];
    [defaults setObject:udid forKey:@"Spoof_UDID"];
    [defaults setObject:ecid forKey:@"Spoof_ECID"];
    [defaults setObject:mlb forKey:@"Spoof_MLBSerial"];
    [defaults setObject:version forKey:@"Spoof_OSVersion"];
    [defaults setObject:build forKey:@"Spoof_BuildVersion"];
    [defaults setObject:@"iPhone de Andromeda" forKey:@"Spoof_DeviceName"];
    [defaults setObject:mac1 forKey:@"Spoof_WiFiMAC"];
    [defaults setObject:mac2 forKey:@"Spoof_BluetoothMAC"];
    [defaults synchronize];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Profile Generated"
        message:[NSString stringWithFormat:@"Model: %@\niOS: %@ (%@)\nSerial: %@\nUDID: %@\n\nRespring to apply.", model, version, build, serial, udid]
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetSpoof {
    NSArray* keys = @[@"Spoof_Model", @"Spoof_ProductType", @"Spoof_MachineName", @"Spoof_SerialNumber", @"Spoof_UDID", @"Spoof_ECID", @"Spoof_MLBSerial", @"Spoof_OSVersion", @"Spoof_BuildVersion", @"Spoof_DeviceName", @"Spoof_WiFiMAC", @"Spoof_BluetoothMAC"];

    NSUserDefaults* defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.andromeda.bypass"];
    for(NSString* key in keys) {
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Spoof Fields Reset"
        message:@"All custom spoof values cleared. Random profile will be used."
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)openGitHub {
    NSURL *url = [NSURL URLWithString:@"https://github.com/mpoukiarmel21-beep/Andromeda"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
