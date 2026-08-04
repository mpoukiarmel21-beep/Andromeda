#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

#import "../common.h"
#import "hooks/hooks.h"
#import <Andromeda.h>

%ctor {
    @try {
        [[NSNotificationCenter defaultCenter] addObserverForName:(__bridge NSNotificationName)CFSTR("com.andromeda.bypass/settingsChanged") object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* note) {
            @try { [_andromeda loadPreferences]; } @catch(NSException *e) {}
        }];

        NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if(!bundleIdentifier) return;

        if([bundleIdentifier hasPrefix:@"com.andromeda"]) {
            return;
        }

        NSNumber* globalEnabled = [_andromeda preferences][@"Global_Enabled"];
        if(globalEnabled && ![globalEnabled boolValue]) {
            return;
        }

        BOOL applyToAll = [[_andromeda preferences][@"Global_ApplyToAll"] boolValue];
        BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
        BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];
        BOOL isProtected = isDating || isSocial;
        BOOL debugMode = [[_andromeda preferences][@"Debug_Mode"] boolValue];

        NSString* executablePath = [[NSBundle mainBundle] executablePath];
        BOOL isSystemProcess = NO;
        if(executablePath) {
            isSystemProcess = ([executablePath hasPrefix:@"/Applications"]
            || [executablePath hasPrefix:@"/System"]
            || [executablePath hasPrefix:@"/private/preboot"]
            || [executablePath hasPrefix:@"/usr/libexec"]
            || [executablePath hasPrefix:@"/usr/bin"]
            || [executablePath hasPrefix:@"/usr/sbin"]
            || [executablePath hasPrefix:@"/var/jb"]);
        }

        if(isSystemProcess) return;

        if([bundleIdentifier hasPrefix:@"com.apple"]
        || [bundleIdentifier hasPrefix:@"org.coolstar"]
        || [bundleIdentifier hasPrefix:@"me.jjolano"]
        || [bundleIdentifier hasPrefix:@"com.saurik"]) {
            return;
        }

        if(!isProtected && !debugMode && !applyToAll) return;
        if(isProtected == NO && debugMode) {
            NSLog(@"[Andromeda DEBUG] Applying bypass to app: %@", bundleIdentifier);
        }

        NSNumber* val;

        val = [_andromeda preferences][@"Hook_Filesystem"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Filesystem(); } @catch(NSException *e) { NSLog(@"[Andromeda] Filesystem err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_Dyld"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Dyld(); } @catch(NSException *e) { NSLog(@"[Andromeda] Dyld err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_AntiDebug"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_AntiDebug(); } @catch(NSException *e) { NSLog(@"[Andromeda] AntiDebug err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_DeviceCheck"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_DeviceCheck(); } @catch(NSException *e) { NSLog(@"[Andromeda] DeviceCheck err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_AppAttest"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_AppAttest(); } @catch(NSException *e) { NSLog(@"[Andromeda] AppAttest err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_Sandbox"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Sandbox(); } @catch(NSException *e) { NSLog(@"[Andromeda] Sandbox err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_SymLookup"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_SymLookup(); } @catch(NSException *e) { NSLog(@"[Andromeda] SymLookup err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_URLScheme"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_URLScheme(); } @catch(NSException *e) { NSLog(@"[Andromeda] URLScheme err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_EnvVars"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_EnvVars(); } @catch(NSException *e) { NSLog(@"[Andromeda] EnvVars err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_MachBootstrap"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_MachBootstrap(); } @catch(NSException *e) { NSLog(@"[Andromeda] MachBootstrap err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_ObjCRuntime"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_ObjCRuntime(); } @catch(NSException *e) { NSLog(@"[Andromeda] ObjCRuntime err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_Syscall"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Syscall(); } @catch(NSException *e) { NSLog(@"[Andromeda] Syscall err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_TweakClasses"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_TweakClasses(); } @catch(NSException *e) { NSLog(@"[Andromeda] TweakClasses err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_UIImage"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_UIImage(); } @catch(NSException *e) { NSLog(@"[Andromeda] UIImage err: %@", e); }
        }

        val = [_andromeda preferences][@"Hook_HardwareFingerprint"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_HardwareFingerprint(); } @catch(NSException *e) { NSLog(@"[Andromeda] HardwareFingerprint err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_IOKit"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_IOKit(); } @catch(NSException *e) { NSLog(@"[Andromeda] IOKit err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_Behavioral"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Behavioral(); } @catch(NSException *e) { NSLog(@"[Andromeda] Behavioral err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_Sensors"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_Sensors(); } @catch(NSException *e) { NSLog(@"[Andromeda] Sensors err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_MobileGestalt"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_MobileGestalt(); } @catch(NSException *e) { NSLog(@"[Andromeda] MobileGestalt err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_NetworkInterface"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_NetworkInterface(); } @catch(NSException *e) { NSLog(@"[Andromeda] NetworkInterface err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_ProcFiles"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_ProcFiles(); } @catch(NSException *e) { NSLog(@"[Andromeda] ProcFiles err: %@", e); }
        }
        val = [_andromeda preferences][@"Hook_IOHID"];
        if(!val || [val boolValue]) {
            @try { andromeda_hook_IOHID(); } @catch(NSException *e) { NSLog(@"[Andromeda] IOHID err: %@", e); }
        }

        if(isDating) {
            @try { andromeda_hook_DatingApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] DatingApps err: %@", e); }
        }
        if(isSocial) {
            @try { andromeda_hook_SocialApps(); } @catch(NSException *e) { NSLog(@"[Andromeda] SocialApps err: %@", e); }
        }

        @try { andromeda_hook_DetectionBypass(); } @catch(NSException *e) { NSLog(@"[Andromeda] DetectionBypass err: %@", e); }

        val = [_andromeda preferences][@"Adaptive_Mode"];
        if(val && [val boolValue]) {
            @try { andromeda_hook_Adaptive(); } @catch(NSException *e) { NSLog(@"[Andromeda] Adaptive err: %@", e); }
        }

        NSLog(@"[Andromeda] Hooks initialized for %@ (debug=%d)", bundleIdentifier, debugMode);
    } @catch(NSException *e) {
        NSLog(@"[Andromeda] ctor error: %@", e);
    }
}
