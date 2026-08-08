#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

#import "../common.h"
#import "hooks/hooks.h"
#import <Andromeda.h>

static BOOL andromeda_hookEnabled(NSString* key) {
    NSNumber* val = andromeda_prefs()[key];
    if(val && [val boolValue]) return YES;
    NSString* bid = [[NSBundle mainBundle] bundleIdentifier];
    if(bid && andromeda_appTweakEnabled(bid, key)) return YES;
    return NO;
}

static BOOL andromeda_toolExplicitlyDisabled(NSString* key) {
    NSString* bid = [[NSBundle mainBundle] bundleIdentifier];
    if(!bid) return NO;
    @try {
        NSDictionary* perApp = andromeda_prefs()[@"PerApp"];
        NSDictionary* cfg = perApp[bid];
        if(![cfg isKindOfClass:[NSDictionary class]]) return NO;
        id v = cfg[key];
        return [v isKindOfClass:[NSNumber class]] && ![v boolValue];
    } @catch(NSException *e) { return NO; }
}

// Launch diagnostics: the app writes what it saw at load time to a file the
// Settings bundle can read back, so a non-technical user can verify the tweak
// loaded and which branch the ctor took, without needing console logs.
static void andromeda_writeDiagnostics(NSDictionary* info) {
    @try {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:@ANDROMEDA_CACHE withIntermediateDirectories:YES attributes:nil error:nil];
        NSString* path = [@ANDROMEDA_CACHE stringByAppendingPathComponent:@"launch-diag.plist"];
        [info writeToFile:path atomically:YES];
        NSLog(@"[Andromeda] diag: %@", info);
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] diag write error: %@", e);
    }
}

static void andromeda_updateDiagnostics(void (^update)(NSMutableDictionary* diag)) {
    @try {
        NSString* path = [@ANDROMEDA_CACHE stringByAppendingPathComponent:@"launch-diag.plist"];
        NSMutableDictionary* diag = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        if(!diag) diag = [NSMutableDictionary dictionary];
        if(update) update(diag);
        andromeda_writeDiagnostics(diag);
    } @catch(NSException *e) {}
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
    if(!(andromeda_hookEnabled(prefKey) || andromeda_recommendedToolOn(prefKey))) return;
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
    if(!(andromeda_hookEnabled(prefKey) || andromeda_spoofEnabled() || andromeda_recommendedToolOn(prefKey))) return;
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
    if(!(andromeda_hookEnabled(prefKey) || andromeda_littleMacEnabled() || andromeda_recommendedToolOn(prefKey))) return;
    if([g_installedHooks containsObject:prefKey]) return;
    @try {
        block();
        [g_installedHooks addObject:prefKey];
        NSLog(@"[Andromeda] Hook installed: %@", name);
    }
    @catch(NSException *e) { NSLog(@"[Andromeda] %@ err: %@", name, e); }
}

static void andromeda_applyToolHooks(void) {
    // Only 4 essential hooks — avoid watchdog timeouts and UIKit deadlocks.
    andromeda_installTweakHook(@"Hook_DetectionBypass", ^{ andromeda_hook_DetectionBypass(); }, @"DetectionBypass");
    andromeda_installTweakHook(@"Hook_AntiDebug", ^{ andromeda_hook_AntiDebug(); }, @"AntiDebug");
    andromeda_installSpoofHook(@"Hook_DeviceCheck", ^{ andromeda_hook_DeviceCheck(); }, @"DeviceCheck");
    andromeda_installHook(@"Hook_AppAttest", ^{ andromeda_hook_AppAttestBypass_install(); }, @"AppAttestBypass");
}

static void andromeda_applyAppHooks(void) {
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
    BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];

    BOOL datingSwitch = andromeda_hookEnabled(@"Hook_DatingApps");
    BOOL socialSwitch = andromeda_hookEnabled(@"Hook_SocialApps");
    BOOL littleMac = andromeda_appTweakEnabled(bundleIdentifier, @"Tweak_LittleMac");
    BOOL codingJesus = andromeda_appTweakEnabled(bundleIdentifier, @"Tweak_CodingJesus");
    BOOL bypassActive = andromeda_appBypassActive();

    NSLog(@"[Andromeda] applyAppHooks bid=%@ isDating=%d isSocial=%d hookDating=%d hookSocial=%d littleMac=%d codingJesus=%d bypassActive=%d",
        bundleIdentifier, isDating, isSocial, datingSwitch, socialSwitch, littleMac, codingJesus, bypassActive);

    if(isDating && bypassActive) {
        @try { andromeda_hook_DatingApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] DatingApps err: %@", e); }
    }
    if(isSocial && bypassActive) {
        @try { andromeda_hook_SocialApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] SocialApps err: %@", e); }
    }

    if([andromeda_prefs()[@"Adaptive_Mode"] boolValue]) {
        andromeda_installHook(@"Adaptive_Mode", ^{ andromeda_hook_Adaptive(); }, @"Adaptive");
    }
}

// Manual re-injection: re-reads the config and (re)installs every enabled hook
// in this running process. Called on each Settings change so a toggled option
// takes effect immediately without relaunching the app.
// If a previously-installed tool was explicitly disabled (unchecked in Settings),
// the process restarts so only the currently-enabled hooks are loaded fresh.
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

        // If protection was disabled (master switch OFF) while hooks are installed, restart
        if(g_installedHooks && g_installedHooks.count > 0) {
            BOOL shouldRestart = NO;
            NSDictionary* cfg = andromeda_prefs()[@"PerApp"][bid];
            if([cfg isKindOfClass:[NSDictionary class]]) {
                id enabled = cfg[@"enabled"];
                if(enabled && [enabled isKindOfClass:[NSNumber class]] && ![enabled boolValue]) {
                    shouldRestart = YES;
                    NSLog(@"[Andromeda] Protection disabled for %@, restarting...", bid);
                }
            }
            if(!shouldRestart) {
                for(NSString* key in [g_installedHooks copy]) {
                    if(andromeda_toolExplicitlyDisabled(key)) {
                        shouldRestart = YES;
                        NSLog(@"[Andromeda] Tool %@ explicitly disabled, restarting app...", key);
                        break;
                    }
                }
            }
            if(shouldRestart) exit(0);
        }

        andromeda_updateDiagnostics(^(NSMutableDictionary* diag) {
            diag[@"lastReinject"] = [[NSDate date] description];
            diag[@"installedHooks"] = g_installedHooks ? [g_installedHooks allObjects] : @[];
        });
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
        NSString* executablePath = [[NSBundle mainBundle] executablePath];

        NSMutableDictionary* diag = [NSMutableDictionary dictionary];
        diag[@"ctorRan"] = @YES;
        diag[@"app"] = bundleIdentifier ?: @"(nil)";
        diag[@"executablePath"] = executablePath ?: @"(nil)";
        diag[@"timestamp"] = [[NSDate date] description];
        diag[@"prefsFileExists"] = @([[NSFileManager defaultManager] fileExistsAtPath:@ANDROMEDA_PREFS]);
        diag[@"prefsRead"] = @([[AndromedaCore sharedInstance] rawPreferences] != nil);

        if(!bundleIdentifier || !executablePath) {
            diag[@"skip"] = @"bundleIdentifier or executablePath is nil";
            andromeda_writeDiagnostics(diag);
            return;
        }

        if([bundleIdentifier hasPrefix:@"com.apple"]
        || [bundleIdentifier hasPrefix:@"com.andromeda"]
        || [bundleIdentifier hasPrefix:@"org.coolstar"]
        || [bundleIdentifier hasPrefix:@"me.jjolano"]
        || [bundleIdentifier hasPrefix:@"com.saurik"]) {
            diag[@"skip"] = @"system bundle id";
            andromeda_writeDiagnostics(diag);
            return;
        }

        if([executablePath hasPrefix:@"/Applications"]
        || [executablePath hasPrefix:@"/System"]
        || [executablePath hasPrefix:@"/private/preboot"]
        || [executablePath hasPrefix:@"/usr/libexec"]
        || [executablePath hasPrefix:@"/usr/bin"]
        || [executablePath hasPrefix:@"/usr/sbin"]
        || [executablePath hasPrefix:@"/var/jb"]) {
            diag[@"skip"] = @"system executable path";
            andromeda_writeDiagnostics(diag);
            return;
        }

        NSDictionary* rawPrefs = [[AndromedaCore sharedInstance] rawPreferences];
        NSDictionary* perApp = rawPrefs[@"PerApp"];
        diag[@"perAppConfiguredCount"] = @([perApp isKindOfClass:[NSDictionary class]] ? perApp.count : 0);
        diag[@"perAppConfiguredKeys"] = [perApp isKindOfClass:[NSDictionary class]] ? [perApp allKeys] : @[];

        NSNumber* globalEnabled = andromeda_prefs()[@"Global_Enabled"];
        if(globalEnabled && ![globalEnabled boolValue]) {
            diag[@"skip"] = @"Global_Enabled is NO";
            andromeda_writeDiagnostics(diag);
            NSLog(@"[Andromeda] Skipping %@: Andromeda disabled in Settings (Global_Enabled=NO).", bundleIdentifier);
            return;
        }

        NSDictionary* perAppCfg = [[AndromedaCore sharedInstance] perAppConfigurationForBundleId:bundleIdentifier];
        diag[@"perAppCfgFound"] = @(perAppCfg != nil);
        diag[@"perAppEnabled"] = perAppCfg ? (perAppCfg[@"enabled"] ?: @"(missing)") : @"(no config)";
        diag[@"perAppCfg"] = perAppCfg ?: @{};

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

        diag[@"isProtected"] = @(isProtected);
        diag[@"debugMode"] = @(debugMode);
        diag[@"applyToAll"] = @(applyToAll);

        if(!isProtected && !debugMode && !applyToAll) {
            diag[@"skip"] = @"no per-app config, debug, or apply-to-all";
            andromeda_writeDiagnostics(diag);
            NSLog(@"[Andromeda] Skipping %@: no per-app config and not in supported app list. Configure it in Settings, or enable Debug Mode / Apply to All.", bundleIdentifier);
            return;
        }

        if(debugMode) {
            NSLog(@"[Andromeda DEBUG] Applying bypass to app: %@", bundleIdentifier);
        }

        andromeda_reinjectNow();

        // Schedule delayed re-injection to avoid UIKit dispatch_once deadlock
        // during +[UIScreen initialize] for apps like Meetic.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            andromeda_reinjectNow();
        });

        diag[@"installedHooks"] = g_installedHooks ? [g_installedHooks allObjects] : @[];
        diag[@"skip"] = @"(none)";
        andromeda_writeDiagnostics(diag);

        NSLog(@"[Andromeda] Hooks initialized for %@ (protected=%d debug=%d)", bundleIdentifier, isProtected, debugMode);
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] ctor error: %@", e);
    }
}
