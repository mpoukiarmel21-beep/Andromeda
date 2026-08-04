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
        [[AndromedaCore sharedInstance] loadPreferences];
        DLog(@"Andromeda loaded in SpringBoard");
    });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    %orig;
}

%end

%end

%ctor {
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];

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
    || [executablePath hasPrefix:@"/var/jb"]
    || [executablePath hasPrefix:@"/usr/libexec"]) {
        return;
    }

    if([bundleIdentifier hasPrefix:@"com.opa334"]
    || [bundleIdentifier hasPrefix:@"org.coolstar"]
    || [bundleIdentifier hasPrefix:@"science.xnu"]
    || [bundleIdentifier hasPrefix:@"com.apple"]
    || [bundleIdentifier hasPrefix:@"com.samiiau"]
    || [bundleIdentifier hasPrefix:@"com.llsc12"]
    || [bundleIdentifier hasPrefix:@"me.jjolano"]
    || [bundleIdentifier hasPrefix:@"com.andromeda"]) {
        return;
    }

    DLog(@"Andromeda loaded in app: %@", bundleIdentifier);

    [AndromedaCore sharedInstance];

    NSDictionary* prefs = [[AndromedaCore sharedInstance] preferences];
    if(!prefs || ![prefs[@"Global_Enabled"] boolValue]) {
        DLog(@"Andromeda globally disabled");
        return;
    }

    BOOL isDating = [[AndromedaCore sharedInstance] isDatingApp];
    BOOL isSocial = [[AndromedaCore sharedInstance] isSocialApp];
    BOOL isProtected = isDating || isSocial;

    DLog(@"App type: dating=%d social=%d protected=%d", isDating, isSocial, isProtected);

    if(!isProtected && ![prefs[@"Global_ApplyToAll"] boolValue]) {
        DLog(@"Non-protected app, skipping hooks");
        return;
    }

    DLog(@"Initializing all hooks...");

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

    if(isProtected || kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_14_0) {
        andromeda_hook_HardwareFingerprint();
        andromeda_hook_IOKit();
        andromeda_hook_Behavioral();
        andromeda_hook_Sensors();
        andromeda_hook_MobileGestalt();
        andromeda_hook_NetworkInterface();
        andromeda_hook_ProcFiles();
        andromeda_hook_IOHID();
    }

    if(isDating) {
        DLog(@"Enabling dating app specific hooks");
        andromeda_hook_DatingApps();
    }

    if(isSocial) {
        DLog(@"Enabling social app specific hooks");
        andromeda_hook_SocialApps();
    }

    DLog(@"Andromeda hooks fully initialized for %@", bundleIdentifier);
}
