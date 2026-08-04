#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

#import "../common.h"
#import "hooks/hooks.h"
#import <Andromeda.h>

%group hook_springboard

%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        @try {
            [[AndromedaCore sharedInstance] loadPreferences];
        } @catch(NSException *e) {}
    });
}

%end

%end

%ctor {
    @try {
        NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if(!bundleIdentifier) return;

        if([bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
            %init(hook_springboard);
            return;
        }

        NSString* executablePath = [[NSBundle mainBundle] executablePath];
        if(!executablePath) return;

        NSString* bundleType = [[executablePath stringByDeletingLastPathComponent] pathExtension];
        if(![bundleType isEqualToString:@"app"]) return;

        if([executablePath hasPrefix:@"/Applications"]
        || [executablePath hasPrefix:@"/System"]
        || [executablePath hasPrefix:@"/private/preboot"]
        || [executablePath hasPrefix:@"/private/var"]
        || [executablePath hasPrefix:@"/var/jb"]
        || [executablePath hasPrefix:@"/usr/libexec"]
        || [executablePath hasPrefix:@"/usr/bin"]
        || [executablePath hasPrefix:@"/usr/sbin"]) {
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

        DLog(@"Andromeda loaded in: %@", bundleIdentifier);

        BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
        BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];
        BOOL isProtected = isDating || isSocial;

        if(!isProtected) return;

        %init;

        DLog(@"Enabling hooks for: %@ (dating=%d social=%d)", bundleIdentifier, isDating, isSocial);

        andromeda_hook_Filesystem();
        andromeda_hook_Dyld();
        andromeda_hook_AntiDebug();
        andromeda_hook_DeviceCheck();
        andromeda_hook_AppAttest();
        andromeda_hook_Sandbox();
        andromeda_hook_SymLookup();
        andromeda_hook_URLScheme();
        andromeda_hook_EnvVars();
        andromeda_hook_MachBootstrap();
        andromeda_hook_ObjCRuntime();
        andromeda_hook_Syscall();
        andromeda_hook_TweakClasses();
        andromeda_hook_UIImage();

        andromeda_hook_HardwareFingerprint();
        andromeda_hook_IOKit();
        andromeda_hook_Behavioral();
        andromeda_hook_Sensors();
        andromeda_hook_MobileGestalt();
        andromeda_hook_NetworkInterface();
        andromeda_hook_ProcFiles();
        andromeda_hook_IOHID();

        if(isDating) {
            andromeda_hook_DatingApps();
        }

        if(isSocial) {
            andromeda_hook_SocialApps();
        }

        DLog(@"Hooks initialized for %@", bundleIdentifier);
    } @catch(NSException *e) {
        DLog(@"Andromeda ctor error: %@", e);
    }
}
