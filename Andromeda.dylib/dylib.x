#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

#import "../common.h"
#import "hooks/hooks.h"
#import <Andromeda.h>

%ctor {
    @try {
        NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if(!bundleIdentifier) return;

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

        if([bundleIdentifier hasPrefix:@"com.apple"]
        || [bundleIdentifier hasPrefix:@"com.opa334"]
        || [bundleIdentifier hasPrefix:@"org.coolstar"]
        || [bundleIdentifier hasPrefix:@"me.jjolano"]
        || [bundleIdentifier hasPrefix:@"com.andromeda"]
        || [bundleIdentifier hasPrefix:@"com.saurik"]) {
            return;
        }

        if(!andromeda_isProtectedProcess()) return;

        DLog(@"Andromeda loaded in: %@", bundleIdentifier);

        BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
        BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];

        DLog(@"Enabling hooks for: %@ (dating=%d social=%d)", bundleIdentifier, isDating, isSocial);

        @try { andromeda_hook_Filesystem(); } @catch(NSException *e) { DLog(@"Filesystem: %@", e); }
        @try { andromeda_hook_Dyld(); } @catch(NSException *e) { DLog(@"Dyld: %@", e); }
        @try { andromeda_hook_AntiDebug(); } @catch(NSException *e) { DLog(@"AntiDebug: %@", e); }
        @try { andromeda_hook_DeviceCheck(); } @catch(NSException *e) { DLog(@"DeviceCheck: %@", e); }
        @try { andromeda_hook_AppAttest(); } @catch(NSException *e) { DLog(@"AppAttest: %@", e); }
        @try { andromeda_hook_Sandbox(); } @catch(NSException *e) { DLog(@"Sandbox: %@", e); }
        @try { andromeda_hook_SymLookup(); } @catch(NSException *e) { DLog(@"SymLookup: %@", e); }
        @try { andromeda_hook_URLScheme(); } @catch(NSException *e) { DLog(@"URLScheme: %@", e); }
        @try { andromeda_hook_EnvVars(); } @catch(NSException *e) { DLog(@"EnvVars: %@", e); }
        @try { andromeda_hook_MachBootstrap(); } @catch(NSException *e) { DLog(@"MachBootstrap: %@", e); }
        @try { andromeda_hook_ObjCRuntime(); } @catch(NSException *e) { DLog(@"ObjCRuntime: %@", e); }
        @try { andromeda_hook_Syscall(); } @catch(NSException *e) { DLog(@"Syscall: %@", e); }
        @try { andromeda_hook_TweakClasses(); } @catch(NSException *e) { DLog(@"TweakClasses: %@", e); }
        @try { andromeda_hook_UIImage(); } @catch(NSException *e) { DLog(@"UIImage: %@", e); }

        @try { andromeda_hook_HardwareFingerprint(); } @catch(NSException *e) { DLog(@"HardwareFingerprint: %@", e); }
        @try { andromeda_hook_IOKit(); } @catch(NSException *e) { DLog(@"IOKit: %@", e); }
        @try { andromeda_hook_Behavioral(); } @catch(NSException *e) { DLog(@"Behavioral: %@", e); }
        @try { andromeda_hook_Sensors(); } @catch(NSException *e) { DLog(@"Sensors: %@", e); }
        @try { andromeda_hook_MobileGestalt(); } @catch(NSException *e) { DLog(@"MobileGestalt: %@", e); }
        @try { andromeda_hook_NetworkInterface(); } @catch(NSException *e) { DLog(@"NetworkInterface: %@", e); }
        @try { andromeda_hook_ProcFiles(); } @catch(NSException *e) { DLog(@"ProcFiles: %@", e); }
        @try { andromeda_hook_IOHID(); } @catch(NSException *e) { DLog(@"IOHID: %@", e); }

        if(isDating) {
            @try { andromeda_hook_DatingApps(); } @catch(NSException *e) { DLog(@"DatingApps: %@", e); }
        }

        if(isSocial) {
            @try { andromeda_hook_SocialApps(); } @catch(NSException *e) { DLog(@"SocialApps: %@", e); }
        }

        DLog(@"Hooks initialized for %@", bundleIdentifier);
    } @catch(NSException *e) {
        DLog(@"Andromeda ctor error: %@", e);
    }
}
