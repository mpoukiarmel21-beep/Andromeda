#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <spawn.h>

#import "../common.h"
#import "AndromedaSettings.h"

@interface AndromedaAppConfigController : PSListController
@property (nonatomic, strong) NSString* appBundleId;
@end

static NSMutableDictionary* AndromedaLoadPrefs(void);
static void AndromedaSavePrefs(NSMutableDictionary* prefs);

static NSArray* AndromedaCoreTools(void) {
    return @[
        @[@"Multi-Vector Detection Bypass", @"Hook_DetectionBypass"],
        @[@"Filesystem Hooks", @"Hook_Filesystem"],
        @[@"Dyld / Runtime Hooks", @"Hook_Dyld"],
        @[@"Anti-Debug Hooks", @"Hook_AntiDebug"],
        @[@"DeviceCheck Bypass", @"Hook_DeviceCheck"],
        @[@"App Attest Bypass", @"Hook_AppAttest"],
        @[@"Sandbox Checks", @"Hook_Sandbox"],
        @[@"Symbol Lookup Hooks", @"Hook_SymLookup"],
        @[@"Environment Variable Hooks", @"Hook_EnvVars"],
        @[@"Mach Bootstrap Hooks", @"Hook_MachBootstrap"],
        @[@"Objective-C Runtime Hooks", @"Hook_ObjCRuntime"],
        @[@"Syscall Hooks", @"Hook_Syscall"],
        @[@"Behavioral Detection Bypass", @"Hook_Behavioral"],
        @[@"UIImage Bypass", @"Hook_UIImage"]
    ];
}

static NSArray* AndromedaAdvancedTools(void) {
    return @[
        @[@"Hardware Fingerprint Spoofing", @"Hook_HardwareFingerprint"],
        @[@"IOKit Hooks", @"Hook_IOKit"],
        @[@"MobileGestalt Hooks", @"Hook_MobileGestalt"],
        @[@"Network Interface Hooks", @"Hook_NetworkInterface"],
        @[@"Sensor Hooks", @"Hook_Sensors"],
        @[@"Proc Files Hooks", @"Hook_ProcFiles"],
        @[@"IOHID Hooks", @"Hook_IOHID"],
        @[@"Process Hiding", @"Hook_ProcessHiding"],
        @[@"Frida Bypass", @"Hook_FridaBypass"],
        @[@"Dynamic Class Scanner Bypass", @"Hook_DynamicHooker"],
        @[@"URL Scheme Hooks", @"Hook_URLScheme"]
    ];
}

static NSArray* AndromedaSpoofFields(void) {
    return @[
        @[@"Device Model", @"Spoof_Model", @"e.g. iPhone15,2 (leave empty to randomize)"],
        @[@"Product Type", @"Spoof_ProductType", @"e.g. iPhone15,2"],
        @[@"Machine Name", @"Spoof_MachineName", @"e.g. iPhone16,1"],
        @[@"Serial Number", @"Spoof_SerialNumber", @"12 alphanumeric chars"],
        @[@"UDID", @"Spoof_UDID", @"40 hex characters"],
        @[@"ECID", @"Spoof_ECID", @"e.g. 1234ABCDEF"],
        @[@"MLB Serial Number", @"Spoof_MLBSerial", @"e.g. F2LQ1234ABCD"],
        @[@"iOS Version", @"Spoof_OSVersion", @"e.g. 18.4.1"],
        @[@"Build Version", @"Spoof_BuildVersion", @"e.g. 22E240"],
        @[@"Device Name", @"Spoof_DeviceName", @"e.g. iPhone"],
        @[@"Wi-Fi MAC Address", @"Spoof_WiFiMAC", @"e.g. AA:BB:CC:DD:EE:FF"],
        @[@"Bluetooth MAC Address", @"Spoof_BluetoothMAC", @"e.g. AA:BB:CC:DD:EE:FF"]
    ];
}

static NSSet* AndromedaDatingBundleIds(void) {
    return [NSSet setWithObjects:
        @"com.cardify.tinder", @"com.bumble.app", @"com.bumble.bff", @"co.hinge.app",
        @"co.hily.app", @"com.badoo.badoo", @"com.ftw-and-co.fruitz", @"com.feels.Feels",
        @"com.happn.happn", @"com.match.Match", @"com.okcupid.okcupid", @"com.pof.pof",
        @"com.grindrapp.ios", @"com.jackd.ios", @"com.scruff.scruff", @"com.weareher.HER",
        @"com.meetic.meetic", @"com.adopteunmec.ios", @"com.jaumo.ios", @"com.tantan.ios",
        @"com.lovoo.ios", @"com.boo.app", @"com.theleague.ios", @"com.innercircle.ios",
        @"com.once.once", @"com.clover.ios", nil];
}

static NSSet* AndromedaSocialBundleIds(void) {
    return [NSSet setWithObjects:
        @"com.burbn.instagram", @"com.instagram.barcelona", @"com.facebook.Facebook",
        @"com.facebook.Messenger", @"com.snapchat.Snapchat", @"com.zhiliaoapp.musically",
        @"com.atebits.Tweetie2", @"com.hammerandchisel.discord", @"com.reddit.Reddit",
        @"net.whatsapp.WhatsApp", @"ph.telegra.Telegraph", @"org.whispersystems.signal",
        @"com.bereal.ios", @"com.linkedin.LinkedIn", nil];
}

@implementation AndromedaAppConfigController

static NSMutableDictionary* AndromedaLoadPrefs(void) {
    NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    if(!prefs) prefs = [NSMutableDictionary dictionary];
    return prefs;
}

static void AndromedaSavePrefs(NSMutableDictionary* prefs) {
    [prefs writeToFile:@ANDROMEDA_PREFS atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.andromeda.bypass/settingsChanged"), NULL, NULL, YES);
}

static NSDictionary* AndromedaGlobalPrefs(void) {
    NSDictionary* prefs = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    return [prefs isKindOfClass:[NSDictionary class]] ? prefs : @{};
}

static NSDictionary* AndromedaAppConfig(NSString* bundleId) {
    NSDictionary* perApp = AndromedaGlobalPrefs()[@"PerApp"];
    if(![perApp isKindOfClass:[NSDictionary class]]) return nil;
    NSDictionary* cfg = perApp[bundleId];
    return [cfg isKindOfClass:[NSDictionary class]] ? cfg : nil;
}

- (NSString*)bundleId {
    if(!_appBundleId) {
        _appBundleId = [self.specifier propertyForKey:@"appBundleId"];
    }
    return _appBundleId;
}

- (NSString*)appName {
    NSString* name = [self.specifier propertyForKey:@"appName"];
    return name.length ? name : (self.bundleId ?: @"App");
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    if(!key) return nil;

    NSDictionary* cfg = AndromedaAppConfig(self.bundleId);
    id value = cfg ? cfg[key] : nil;
    if(!value) value = [specifier propertyForKey:@"default"];
    return value;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    if(!key) return;
    [self writeValue:(value ?: @"") forKey:key];
    if([key isEqualToString:@"enabled"]) {
        AndromedaSettingsSyncFilter();
    }
}

- (void)writeValue:(id)value forKey:(NSString*)key {
    if(!key) return;
    NSMutableDictionary* prefs = AndromedaLoadPrefs();
    NSMutableDictionary* perApp = [prefs[@"PerApp"] mutableCopy];
    if(!perApp) perApp = [NSMutableDictionary dictionary];
    NSMutableDictionary* cfg = [perApp[self.bundleId] mutableCopy];
    if(!cfg) cfg = [NSMutableDictionary dictionary];
    cfg[key] = value;
    perApp[self.bundleId] = cfg;
    prefs[@"PerApp"] = perApp;
    AndromedaSavePrefs(prefs);
}

- (void)writeConfig:(NSDictionary*)config {
    NSMutableDictionary* prefs = AndromedaLoadPrefs();
    NSMutableDictionary* perApp = [prefs[@"PerApp"] mutableCopy];
    if(!perApp) perApp = [NSMutableDictionary dictionary];
    perApp[self.bundleId] = config;
    prefs[@"PerApp"] = perApp;
    AndromedaSavePrefs(prefs);
}

- (NSArray*)specifiers {
    if(!_specifiers) {
        NSString* bid = self.bundleId;
        NSMutableArray* arr = [NSMutableArray array];

        [arr addObject:[self groupSpecifier:@"PROTECTION" label:self.appName footer:@"Turn protection on for this app only, then choose the bypass tools you want. Every option here applies to this app and no other."]];
        [arr addObject:[self switchSpecifier:@"Enable Protection" key:@"enabled"]];

        [arr addObject:[self groupSpecifier:@"CORE" label:@"Core Bypasses" footer:nil]];
        for(NSArray* pair in AndromedaCoreTools()) {
            [arr addObject:[self switchSpecifier:pair[0] key:pair[1]]];
        }

        [arr addObject:[self groupSpecifier:@"ADVANCED" label:@"Advanced Bypasses" footer:@"Advanced tools are aggressive. Only enable what you really need."]];
        for(NSArray* pair in AndromedaAdvancedTools()) {
            [arr addObject:[self switchSpecifier:pair[0] key:pair[1]]];
        }

        BOOL isDating = [AndromedaDatingBundleIds() containsObject:bid];
        BOOL isSocial = [AndromedaSocialBundleIds() containsObject:bid];
        if(isDating || isSocial) {
            [arr addObject:[self groupSpecifier:@"APPHOOK" label:@"App Detection Hooks" footer:nil]];
            if(isDating) {
                [arr addObject:[self switchSpecifier:@"Dating App Hooks" key:@"Hook_DatingApps"]];
            }
            if(isSocial) {
                [arr addObject:[self switchSpecifier:@"Social Media App Hooks" key:@"Hook_SocialApps"]];
            }
        }

        [arr addObject:[self groupSpecifier:@"EXTERNAL TWEAKS" label:@"LittleMac & CodingJesus" footer:@"LittleMac adapted for this app = its jailbreak-detection classes are hooked. CodingJesus adapted for this app = device fingerprint spoofing (model, serial, UDID, iOS version...). Each toggle applies immediately via manual re-injection, no relaunch needed. On Tinder, the original external tweaks load as well. Both switches off = disabled."]];
        [arr addObject:[self switchSpecifier:@"LittleMac (app bypass)" key:@"Tweak_LittleMac"]];
        [arr addObject:[self switchSpecifier:@"CodingJesus (device spoofer)" key:@"Tweak_CodingJesus"]];

        if([bid isEqualToString:@"com.cardify.tinder"]) {
            [arr addObject:[self menuButtonForKey:@"Tinder_Bypass_Mode" title:@"Legacy Tinder Bypass Method" action:@selector(pickTinderBypass)]];
        }

        [arr addObject:[self groupSpecifier:@"BEHAVIOR" label:@"Detection Behavior" footer:nil]];
        [arr addObject:[self menuButtonForKey:@"Detection_Mode" title:@"Detection Response Mode" action:@selector(pickDetectionMode)]];
        [arr addObject:[self menuButtonForKey:@"Log_Level" title:@"Log Level" action:@selector(pickLogLevel)]];

        [arr addObject:[self groupSpecifier:@"SPOOF" label:@"Device Fingerprint Spoofing" footer:@"Leave a field empty to randomize it on every launch."]];
        for(NSArray* field in AndromedaSpoofFields()) {
            [arr addObject:[self textFieldForKey:field[1] title:field[0] placeholder:field[2]]];
        }
        [arr addObject:[self buttonSpecifier:@"Generate Random Profile" action:@selector(regenProfile)]];
        [arr addObject:[self buttonSpecifier:@"Reset Profile" action:@selector(resetSpoof)]];
        [arr addObject:[self buttonSpecifier:@"Respring" action:@selector(respring)]];

        _specifiers = arr;
    }
    return _specifiers;
}

- (PSSpecifier*)groupSpecifier:(NSString*)identifier label:(NSString*)label footer:(NSString*)footer {
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:label target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    [spec setProperty:identifier forKey:@"id"];
    if(footer) [spec setProperty:footer forKey:@"footerText"];
    return spec;
}

- (PSSpecifier*)switchSpecifier:(NSString*)title key:(NSString*)key {
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:title target:self
        set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:)
        detail:nil cell:PSSwitchCell edit:nil];
    [spec setProperty:key forKey:@"key"];
    [spec setProperty:@NO forKey:@"default"];
    return spec;
}

- (PSSpecifier*)textFieldForKey:(NSString*)key title:(NSString*)title placeholder:(NSString*)placeholder {
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:title target:self
        set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:)
        detail:nil cell:PSEditTextCell edit:nil];
    [spec setProperty:key forKey:@"key"];
    [spec setProperty:@"" forKey:@"default"];
    if(placeholder) [spec setProperty:placeholder forKey:@"placeholder"];
    return spec;
}

- (PSSpecifier*)buttonSpecifier:(NSString*)title action:(SEL)action {
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:title target:self
        set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
    [spec setButtonAction:action];
    return spec;
}

- (PSSpecifier*)menuButtonForKey:(NSString*)key title:(NSString*)title action:(SEL)action {
    NSString* current = AndromedaAppConfig(self.bundleId)[key];
    if(!current) current = AndromedaGlobalPrefs()[key];
    NSString* label = title;
    if(current) label = [NSString stringWithFormat:@"%@ (%@)", title, [current capitalizedString]];
    PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:label target:self
        set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
    [spec setProperty:key forKey:@"key"];
    [spec setButtonAction:action];
    return spec;
}

- (PSSpecifier*)specifierForKey:(NSString*)key {
    for(PSSpecifier* spec in _specifiers) {
        if([[spec propertyForKey:@"key"] isEqualToString:key]) return spec;
    }
    return nil;
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

- (void)pickTinderBypass {
    [self showValuePickerForKey:@"Tinder_Bypass_Mode" title:@"Tinder Bypass Method"
        options:@{ @"Andromeda (default)": @"default",
                   @"Tinder Advanced Spoofer (codingjesus)": @"codingjesus",
                   @"LittleMac Tinder Bypass": @"littlemac" }
        defaultValue:@"default"];
}

- (void)showValuePickerForKey:(NSString*)key title:(NSString*)title
                      options:(NSDictionary*)options defaultValue:(NSString*)defaultValue {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
        message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSString* current = AndromedaAppConfig(self.bundleId)[key];
    if(!current) current = AndromedaGlobalPrefs()[key];
    if(!current) current = defaultValue;

    for(NSString* display in options) {
        NSString* value = options[display];
        NSString* optTitle = (current && [current isEqualToString:value])
            ? [display stringByAppendingString:@" ✓"] : display;
        [alert addAction:[UIAlertAction actionWithTitle:optTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [self writeValue:value forKey:key];
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

    NSMutableDictionary* cfg = [NSMutableDictionary dictionaryWithDictionary:AndromedaAppConfig(self.bundleId)];
    cfg[@"Spoof_Model"] = model;
    cfg[@"Spoof_ProductType"] = model;
    cfg[@"Spoof_MachineName"] = model;
    cfg[@"Spoof_SerialNumber"] = serial;
    cfg[@"Spoof_UDID"] = udid;
    cfg[@"Spoof_ECID"] = ecid;
    cfg[@"Spoof_MLBSerial"] = mlb;
    cfg[@"Spoof_OSVersion"] = version;
    cfg[@"Spoof_BuildVersion"] = build;
    cfg[@"Spoof_DeviceName"] = @"iPhone";
    cfg[@"Spoof_WiFiMAC"] = mac1;
    cfg[@"Spoof_BluetoothMAC"] = mac2;
    [self writeConfig:cfg];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Profile Generated"
        message:[NSString stringWithFormat:@"Model: %@\niOS: %@ (%@)\nSerial: %@\nUDID: %@\n\nThis profile is used only by this app.", model, version, build, serial, udid]
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resetSpoof {
    NSArray* keys = @[@"Spoof_Model", @"Spoof_ProductType", @"Spoof_MachineName", @"Spoof_SerialNumber", @"Spoof_UDID", @"Spoof_ECID", @"Spoof_MLBSerial", @"Spoof_OSVersion", @"Spoof_BuildVersion", @"Spoof_DeviceName", @"Spoof_WiFiMAC", @"Spoof_BluetoothMAC"];

    NSMutableDictionary* cfg = [NSMutableDictionary dictionaryWithDictionary:AndromedaAppConfig(self.bundleId)];
    for(NSString* key in keys) {
        [cfg removeObjectForKey:key];
    }
    [self writeConfig:cfg];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Profile Reset"
        message:@"All custom spoof values cleared for this app. A random profile will be used."
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)respring {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Andromeda"
        message:@"Respring now to apply changes?"
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        pid_t pid;
        NSString* sbreloadPath = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/jb/usr/bin/sbreload"] ? @"/var/jb/usr/bin/sbreload" : @"/usr/bin/sbreload";
        const char* args[] = { "sbreload", NULL };
        posix_spawn(&pid, [sbreloadPath UTF8String], NULL, NULL, (char* const*)args, NULL);
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_appBundleId) {
        _appBundleId = [self.specifier propertyForKey:@"appBundleId"];
    }
    self.title = self.appName;
}

@end
