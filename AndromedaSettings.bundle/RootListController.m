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
            NSString* groupName = [spec name];
            if([groupName isEqualToString:@"Per-Vector Options"]) {
                [merged addObjectsFromArray:[self perVectorSpecifiers]];
            } else if([groupName isEqualToString:@"Identifier Spoofing"]) {
                [merged addObjectsFromArray:[self identifierSpoofSpecifiers]];
            } else if([groupName isEqualToString:@"Logs & Debug"]) {
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

- (PSSpecifier*)textFieldForKey:(NSString*)key title:(NSString*)title placeholder:(NSString*)placeholder {
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:title target:self
        set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:)
        detail:nil cell:PSEditTextCell edit:nil];
    [spec setProperty:key forKey:@"key"];
    if(placeholder) [spec setProperty:placeholder forKey:@"placeholder"];
    return spec;
}

- (NSArray*)perVectorSpecifiers {
    return @[
        [self menuButtonForKey:@"Detection_Mode" title:@"Detection Response Mode" defaultValue:@"spoof" action:@selector(pickDetectionMode)],
        [self textFieldForKey:@"FS_ExtraPaths" title:@"Extra Paths to Hide" placeholder:@"e.g. /var/jb/Applications/X.app,/private/var/mobile/xx"],
        [self textFieldForKey:@"URL_ExtraSchemes" title:@"Extra URL Schemes" placeholder:@"e.g. cydia,sileo,zbra,filza,ssh"],
        [self textFieldForKey:@"Dyld_ExtraLibs" title:@"Extra Libraries to Block" placeholder:@"e.g. libfrida,libsubstrate,dylib.dll"],
        [self textFieldForKey:@"Proc_ExtraProcesses" title:@"Extra Processes to Hide" placeholder:@"e.g. frida-server,sshd,cycript"],
        [self textFieldForKey:@"Class_ExtraPatterns" title:@"Extra Class Patterns" placeholder:@"e.g. MyDetector,JailbreakCheck"]
    ];
}

- (NSArray*)identifierSpoofSpecifiers {
    return @[
        [self textFieldForKey:@"Spoof_Model" title:@"Device Model" placeholder:@"e.g. iPhone15,2 (leave empty to randomize)"],
        [self textFieldForKey:@"Spoof_ProductType" title:@"Product Type" placeholder:@"e.g. iPhone15,2"],
        [self textFieldForKey:@"Spoof_MachineName" title:@"Machine Name" placeholder:@"e.g. iPhone16,1"],
        [self textFieldForKey:@"Spoof_SerialNumber" title:@"Serial Number" placeholder:@"12 alphanumeric chars"],
        [self textFieldForKey:@"Spoof_UDID" title:@"UDID (40 hex)" placeholder:@"40 hex characters"],
        [self textFieldForKey:@"Spoof_ECID" title:@"ECID (hex)" placeholder:@"e.g. 1234ABCDEF"],
        [self textFieldForKey:@"Spoof_MLBSerial" title:@"MLB Serial Number" placeholder:@"e.g. F2LQ1234ABCD"],
        [self textFieldForKey:@"Spoof_OSVersion" title:@"iOS Version" placeholder:@"e.g. 18.4.1"],
        [self textFieldForKey:@"Spoof_BuildVersion" title:@"Build Version" placeholder:@"e.g. 22E240"],
        [self textFieldForKey:@"Spoof_DeviceName" title:@"Device Name" placeholder:@"e.g. iPhone"],
        [self textFieldForKey:@"Spoof_WiFiMAC" title:@"Wi-Fi MAC Address" placeholder:@"e.g. AA:BB:CC:DD:EE:FF"],
        [self textFieldForKey:@"Spoof_BluetoothMAC" title:@"Bluetooth MAC Address" placeholder:@"e.g. AA:BB:CC:DD:EE:FF"]
    ];
}

- (PSSpecifier*)logLevelSpecifier {
    return [self menuButtonForKey:@"Log_Level" title:@"Log Level" defaultValue:@"info" action:@selector(pickLogLevel)];
}

- (void)pickDetectionMode {
    [self showValuePickerForKey:@"Detection_Mode" title:@"Detection Response Mode"
        options:@{ @"Hide": @"hide", @"Spoof": @"spoof", @"Block": @"block" }
        defaultValue:@"spoof"];
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

    NSMutableDictionary* prefs = AndromedaLoadPrefs();
    prefs[@"Spoof_Model"] = model;
    prefs[@"Spoof_ProductType"] = model;
    prefs[@"Spoof_MachineName"] = model;
    prefs[@"Spoof_SerialNumber"] = serial;
    prefs[@"Spoof_UDID"] = udid;
    prefs[@"Spoof_ECID"] = ecid;
    prefs[@"Spoof_MLBSerial"] = mlb;
    prefs[@"Spoof_OSVersion"] = version;
    prefs[@"Spoof_BuildVersion"] = build;
    prefs[@"Spoof_DeviceName"] = @"iPhone";
    prefs[@"Spoof_WiFiMAC"] = mac1;
    prefs[@"Spoof_BluetoothMAC"] = mac2;
    AndromedaSavePrefs(prefs);

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Profile Generated"
        message:[NSString stringWithFormat:@"Model: %@\niOS: %@ (%@)\nSerial: %@\nUDID: %@\n\nRespring to apply.", model, version, build, serial, udid]
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetSpoof {
    NSArray* keys = @[@"Spoof_Model", @"Spoof_ProductType", @"Spoof_MachineName", @"Spoof_SerialNumber", @"Spoof_UDID", @"Spoof_ECID", @"Spoof_MLBSerial", @"Spoof_OSVersion", @"Spoof_BuildVersion", @"Spoof_DeviceName", @"Spoof_WiFiMAC", @"Spoof_BluetoothMAC"];

    NSMutableDictionary* prefs = AndromedaLoadPrefs();
    for(NSString* key in keys) {
        [prefs removeObjectForKey:key];
    }
    AndromedaSavePrefs(prefs);

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
