#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

#import "../common.h"
#import "hooks/hooks.h"
#import <Andromeda.h>

static BOOL andromeda_hookEnabled(NSString* key) {
    NSNumber* val = andromeda_prefs()[key];
    if(!val) return NO;
    return [val boolValue];
}

static NSMutableSet* g_installedHooks = nil;

static BOOL andromeda_spoofEnabled(void) {
    NSString* bid = [[NSBundle mainBundle] bundleIdentifier];
    return andromeda_appTweakEnabled(bid, @"Tweak_CodingJesus");
}

static BOOL andromeda_littleMacEnabled(void) {
    NSString* bid = [[NSBundle mainBundle] bundleIdentifier];
    return andromeda_appTweakEnabled(bid, @"Tweak_LittleMac");
}

static void andromeda_installHook(NSString* prefKey, void (^block)(void), NSString* name) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{ g_installedHooks = [NSMutableSet set]; });
    if(!andromeda_hookEnabled(prefKey)) return;
    if([g_installedHooks containsObject:prefKey]) return;
    @try {
        block();
        [g_installedHooks addObject:prefKey];
        NSLog(@"[Andromeda] Hook installed: %@", name);
    }
    @catch(NSException *e) { NSLog(@"[Andromeda] %@ err: %@", name, e); }
}

// CodingJesus-adapted hooks: the device-identity spoofers. Active when the
// built-in switch OR the per-app Tweak_CodingJesus toggle is on.
static void andromeda_installSpoofHook(NSString* prefKey, void (^block)(void), NSString* name) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{ g_installedHooks = [NSMutableSet set]; });
    if(!(andromeda_hookEnabled(prefKey) || andromeda_spoofEnabled())) return;
    if([g_installedHooks containsObject:prefKey]) return;
    @try {
        block();
        [g_installedHooks addObject:prefKey];
        NSLog(@"[Andromeda] Hook installed: %@", name);
    }
    @catch(NSException *e) { NSLog(@"[Andromeda] %@ err: %@", name, e); }
}

// LittleMac-adapted hooks: the generic jailbreak-hiding vectors. Active when the
// built-in switch OR the per-app Tweak_LittleMac toggle is on.
static void andromeda_installTweakHook(NSString* prefKey, void (^block)(void), NSString* name) {
    static dispatch_once_t once;
    dispatch_once(&once, ^{ g_installedHooks = [NSMutableSet set]; });
    if(!(andromeda_hookEnabled(prefKey) || andromeda_littleMacEnabled())) return;
    if([g_installedHooks containsObject:prefKey]) return;
    @try {
        block();
        [g_installedHooks addObject:prefKey];
        NSLog(@"[Andromeda] Hook installed: %@", name);
    }
    @catch(NSException *e) { NSLog(@"[Andromeda] %@ err: %@", name, e); }
}

static void andromeda_applyToolHooks(void) {
    andromeda_installTweakHook(@"Hook_DetectionBypass", ^{ andromeda_hook_DetectionBypass(); }, @"DetectionBypass");
    andromeda_installTweakHook(@"Hook_Filesystem", ^{ andromeda_hook_Filesystem(); }, @"Filesystem");
    andromeda_installTweakHook(@"Hook_Dyld", ^{ andromeda_hook_Dyld(); }, @"Dyld");
    andromeda_installTweakHook(@"Hook_AntiDebug", ^{ andromeda_hook_AntiDebug(); }, @"AntiDebug");
    andromeda_installSpoofHook(@"Hook_DeviceCheck", ^{ andromeda_hook_DeviceCheck(); }, @"DeviceCheck");
    andromeda_installHook(@"Hook_Sandbox", ^{ andromeda_hook_Sandbox(); }, @"Sandbox");
    andromeda_installHook(@"Hook_SymLookup", ^{ andromeda_hook_SymLookup(); }, @"SymLookup");
    andromeda_installHook(@"Hook_EnvVars", ^{ andromeda_hook_EnvVars(); }, @"EnvVars");
    andromeda_installHook(@"Hook_MachBootstrap", ^{ andromeda_hook_MachBootstrap(); }, @"MachBootstrap");
    andromeda_installHook(@"Hook_ObjCRuntime", ^{ andromeda_hook_ObjCRuntime(); }, @"ObjCRuntime");
    andromeda_installHook(@"Hook_Syscall", ^{ andromeda_hook_Syscall(); }, @"Syscall");
    andromeda_installHook(@"Hook_Behavioral", ^{ andromeda_hook_Behavioral(); }, @"Behavioral");
    andromeda_installHook(@"Hook_UIImage", ^{ andromeda_hook_UIImage(); }, @"UIImage");
    andromeda_installSpoofHook(@"Hook_HardwareFingerprint", ^{ andromeda_hook_HardwareFingerprint(); }, @"HardwareFingerprint");
    andromeda_installSpoofHook(@"Hook_IOKit", ^{ andromeda_hook_IOKit(); }, @"IOKit");
    andromeda_installSpoofHook(@"Hook_MobileGestalt", ^{ andromeda_hook_MobileGestalt(); }, @"MobileGestalt");
    andromeda_installSpoofHook(@"Hook_NetworkInterface", ^{ andromeda_hook_NetworkInterface(); }, @"NetworkInterface");
    andromeda_installHook(@"Hook_Sensors", ^{ andromeda_hook_Sensors(); }, @"Sensors");
    andromeda_installHook(@"Hook_ProcFiles", ^{ andromeda_hook_ProcFiles(); }, @"ProcFiles");
    andromeda_installHook(@"Hook_IOHID", ^{ andromeda_hook_IOHID(); }, @"IOHID");
    andromeda_installHook(@"Hook_ProcessHiding", ^{ andromeda_hook_ProcessHiding(); }, @"ProcessHiding");
    andromeda_installHook(@"Hook_FridaBypass", ^{ andromeda_hook_FridaBypass(); }, @"FridaBypass");
    andromeda_installHook(@"Hook_DynamicHooker", ^{ andromeda_hook_DynamicHooker(); }, @"DynamicHooker");
    andromeda_installHook(@"Hook_AppAttest", ^{ andromeda_hook_AppAttestBypass_install(); }, @"AppAttestBypass");
    andromeda_installHook(@"Hook_URLScheme", ^{ andromeda_hook_URLSchemeBypass_install(); }, @"URLSchemeBypass");
}

static void andromeda_applyAppHooks(void) {
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
    BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];
    NSArray* tweakKeys = @[@"Tweak_LittleMac", @"Tweak_CodingJesus"];

    if(isDating && (andromeda_hookEnabled(@"Hook_DatingApps") || andromeda_appTweakEnabledAny(bundleIdentifier, tweakKeys))) {
        @try { andromeda_hook_DatingApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] DatingApps err: %@", e); }
    }
    if(isSocial && (andromeda_hookEnabled(@"Hook_SocialApps") || andromeda_appTweakEnabledAny(bundleIdentifier, tweakKeys))) {
        @try { andromeda_hook_SocialApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] SocialApps err: %@", e); }
    }

    if([andromeda_prefs()[@"Adaptive_Mode"] boolValue]) {
        andromeda_installHook(@"Adaptive_Mode", ^{ andromeda_hook_Adaptive(); }, @"Adaptive");
    }
}

// Manual re-injection: re-reads the config and (re)installs every enabled hook
// in this running process. Called on each Settings change so a toggled option
// takes effect immediately without relaunching the app.
static void andromeda_reinjectNow(void) {
    @try {
        [_andromeda loadPreferences];

        @try {
            [[DeviceFingerprintSpoofer sharedInstance] reloadFromPreferences:andromeda_prefs()];
        } @catch(NSException *e) {}

        andromeda_applyToolHooks();
        andromeda_applyAppHooks();

        NSString* bid = [[NSBundle mainBundle] bundleIdentifier];
        NSLog(@"[Andromeda] Manual re-injection applied for %@", bid ?: @"unknown");
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] re-inject error: %@", e);
    }
}

// Cross-process: the Settings app posts com.andromeda.bypass/settingsChanged on the
// Darwin notify center every time an option is toggled. Every injected process
// receives it and re-injects immediately, so toggles apply without relaunching.
static void andromeda_settingsChanged(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    dispatch_async(dispatch_get_main_queue(), ^{
        andromeda_reinjectNow();
    });
}

%ctor {
    @try {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &andromeda_settingsChanged, CFSTR("com.andromeda.bypass/settingsChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

        NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if(!bundleIdentifier) return;

        if([bundleIdentifier hasPrefix:@"com.apple"]
        || [bundleIdentifier hasPrefix:@"com.andromeda"]
        || [bundleIdentifier hasPrefix:@"org.coolstar"]
        || [bundleIdentifier hasPrefix:@"me.jjolano"]
        || [bundleIdentifier hasPrefix:@"com.saurik"]) {
            return;
        }

        NSString* executablePath = [[NSBundle mainBundle] executablePath];
        if(!executablePath) return;
        if([executablePath hasPrefix:@"/Applications"]
        || [executablePath hasPrefix:@"/System"]
        || [executablePath hasPrefix:@"/private/preboot"]
        || [executablePath hasPrefix:@"/usr/libexec"]
        || [executablePath hasPrefix:@"/usr/bin"]
        || [executablePath hasPrefix:@"/usr/sbin"]
        || [executablePath hasPrefix:@"/var/jb"]) {
            return;
        }

        NSNumber* globalEnabled = andromeda_prefs()[@"Global_Enabled"];
        if(globalEnabled && ![globalEnabled boolValue]) {
            NSLog(@"[Andromeda] Skipping %@: Andromeda disabled in Settings (Global_Enabled=NO).", bundleIdentifier);
            return;
        }

        NSDictionary* perAppCfg = [[AndromedaCore sharedInstance] perAppConfigurationForBundleId:bundleIdentifier];

        BOOL applyToAll = [andromeda_prefs()[@"Global_ApplyToAll"] boolValue];
        BOOL debugMode = [andromeda_prefs()[@"Debug_Mode"] boolValue];

        BOOL isProtected = NO;

        if(perAppCfg) {
            id enabled = perAppCfg[@"enabled"];
            isProtected = (!enabled || ![enabled isKindOfClass:[NSNumber class]]) ? YES : [enabled boolValue];
        } else {
            NSString* appKey = [@"App_" stringByAppendingString:bundleIdentifier];
            NSNumber* appOverride = andromeda_prefs()[appKey];
            if(appOverride && [appOverride isKindOfClass:[NSNumber class]]) {
                isProtected = [appOverride boolValue];
            } else if(debugMode || applyToAll) {
                isProtected = YES;
            }
        }

        if(!isProtected && !debugMode && !applyToAll) {
            NSLog(@"[Andromeda] Skipping %@: no per-app config and not in supported app list. Configure it in Settings, or enable Debug Mode / Apply to All.", bundleIdentifier);
            return;
        }

        if(debugMode) {
            NSLog(@"[Andromeda DEBUG] Applying bypass to app: %@", bundleIdentifier);
        }

        andromeda_reinjectNow();

        NSLog(@"[Andromeda] Hooks initialized for %@ (protected=%d debug=%d)", bundleIdentifier, isProtected, debugMode);
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] ctor error: %@", e);
    }
}
