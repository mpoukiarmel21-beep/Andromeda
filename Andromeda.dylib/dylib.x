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

static void andromeda_runHook(NSString* prefKey, void (^block)(void), NSString* name) {
    if(andromeda_hookEnabled(prefKey)) {
        @try { block(); }
        @catch(NSException *e) { NSLog(@"[Andromeda] %@ err: %@", name, e); }
    }
}

%ctor {
    @try {
        [[NSNotificationCenter defaultCenter] addObserverForName:(__bridge NSNotificationName)CFSTR("com.andromeda.bypass/settingsChanged") object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note) {
            @try { [_andromeda loadPreferences]; } @catch(NSException *e) {}
        }];

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

        BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
        BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];
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

        @try {
            [[DeviceFingerprintSpoofer sharedInstance] reloadFromPreferences:andromeda_prefs()];
        } @catch(NSException *e) {}

        andromeda_runHook(@"Hook_DetectionBypass", ^{ andromeda_hook_DetectionBypass(); }, @"DetectionBypass");
        andromeda_runHook(@"Hook_Filesystem", ^{ andromeda_hook_Filesystem(); }, @"Filesystem");
        andromeda_runHook(@"Hook_Dyld", ^{ andromeda_hook_Dyld(); }, @"Dyld");
        andromeda_runHook(@"Hook_AntiDebug", ^{ andromeda_hook_AntiDebug(); }, @"AntiDebug");
        andromeda_runHook(@"Hook_DeviceCheck", ^{ andromeda_hook_DeviceCheck(); }, @"DeviceCheck");
        andromeda_runHook(@"Hook_Sandbox", ^{ andromeda_hook_Sandbox(); }, @"Sandbox");
        andromeda_runHook(@"Hook_SymLookup", ^{ andromeda_hook_SymLookup(); }, @"SymLookup");
        andromeda_runHook(@"Hook_EnvVars", ^{ andromeda_hook_EnvVars(); }, @"EnvVars");
        andromeda_runHook(@"Hook_MachBootstrap", ^{ andromeda_hook_MachBootstrap(); }, @"MachBootstrap");
        andromeda_runHook(@"Hook_ObjCRuntime", ^{ andromeda_hook_ObjCRuntime(); }, @"ObjCRuntime");
        andromeda_runHook(@"Hook_Syscall", ^{ andromeda_hook_Syscall(); }, @"Syscall");
        andromeda_runHook(@"Hook_Behavioral", ^{ andromeda_hook_Behavioral(); }, @"Behavioral");
        andromeda_runHook(@"Hook_UIImage", ^{ andromeda_hook_UIImage(); }, @"UIImage");
        andromeda_runHook(@"Hook_HardwareFingerprint", ^{ andromeda_hook_HardwareFingerprint(); }, @"HardwareFingerprint");
        andromeda_runHook(@"Hook_IOKit", ^{ andromeda_hook_IOKit(); }, @"IOKit");
        andromeda_runHook(@"Hook_MobileGestalt", ^{ andromeda_hook_MobileGestalt(); }, @"MobileGestalt");
        andromeda_runHook(@"Hook_NetworkInterface", ^{ andromeda_hook_NetworkInterface(); }, @"NetworkInterface");
        andromeda_runHook(@"Hook_Sensors", ^{ andromeda_hook_Sensors(); }, @"Sensors");
        andromeda_runHook(@"Hook_ProcFiles", ^{ andromeda_hook_ProcFiles(); }, @"ProcFiles");
        andromeda_runHook(@"Hook_IOHID", ^{ andromeda_hook_IOHID(); }, @"IOHID");

        andromeda_runHook(@"Hook_ProcessHiding", ^{ andromeda_hook_ProcessHiding(); }, @"ProcessHiding");
        andromeda_runHook(@"Hook_FridaBypass", ^{ andromeda_hook_FridaBypass(); }, @"FridaBypass");
        andromeda_runHook(@"Hook_DynamicHooker", ^{ andromeda_hook_DynamicHooker(); }, @"DynamicHooker");
        andromeda_runHook(@"Hook_AppAttest", ^{ andromeda_hook_AppAttestBypass_install(); }, @"AppAttestBypass");
        andromeda_runHook(@"Hook_URLScheme", ^{ andromeda_hook_URLSchemeBypass_install(); }, @"URLSchemeBypass");

        if(isDating && andromeda_hookEnabled(@"Hook_DatingApps")) {
            @try { andromeda_hook_DatingApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] DatingApps err: %@", e); }
        }
        if(isSocial && andromeda_hookEnabled(@"Hook_SocialApps")) {
            @try { andromeda_hook_SocialApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] SocialApps err: %@", e); }
        }

        if([andromeda_prefs()[@"Adaptive_Mode"] boolValue]) {
            andromeda_runHook(@"Adaptive_Mode", ^{ andromeda_hook_Adaptive(); }, @"Adaptive");
        }

        NSLog(@"[Andromeda] Hooks initialized for %@ (protected=%d debug=%d)", bundleIdentifier, isProtected, debugMode);
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] ctor error: %@", e);
    }
}
