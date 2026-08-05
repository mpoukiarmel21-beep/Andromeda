#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <stdarg.h>
#import <sys/stat.h>
#import <sys/statvfs.h>
#import <sys/mount.h>
#import <sys/syscall.h>
#import <sys/utsname.h>
#import <sys/syslimits.h>
#import <sys/time.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/ioctl.h>
#import <sys/param.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <net/if_types.h>
#import <ifaddrs.h>
#import <errno.h>
#import <fcntl.h>
#import <dirent.h>
#import <dlfcn.h>
#import <spawn.h>
#import <unistd.h>
#import <mach-o/dyld.h>
#import <mach-o/dyld_images.h>
#import <mach-o/nlist.h>
#import <mach/mach.h>
#import <mach/mach_traps.h>
#import <mach/task_info.h>
#import <mach/task.h>
#import <mach/host_priv.h>
#import <mach/host_special_ports.h>
#import <mach/task_special_ports.h>
#import <mach/vm_map.h>
#import <sandbox.h>
#import <bootstrap.h>
#import <IOKit/IOKitLib.h>
#import <objc/runtime.h>
#import <Security/Security.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

#import "common.h"
#import "vendor/apple/dyld_priv.h"
#import "vendor/apple/codesign.h"
#import "vendor/apple/ptrace.h"

#import <Andromeda.h>

#import <substrate.h>

#ifndef MSHookFunction
#define MSHookFunction(a, b, c) MSHookFunction(a, b, c)
#endif

#ifndef MSHookMessageEx
#define MSHookMessageEx(class, sel, imp, old) MSHookMessageEx(class, sel, imp, old)
#endif

#ifndef P_TRACED
#define P_TRACED 0x00000800
#endif

#ifndef CTL_KERN
#define CTL_KERN 1
#endif

#ifndef KERN_PROC
#define KERN_PROC 14
#endif

#ifndef KERN_PROC_PID
#define KERN_PROC_PID 1
#endif

#ifndef F_GETPATH
#define F_GETPATH 50
#endif

#define _andromeda              [AndromedaCore sharedInstance]
#define _spoofer                [DeviceFingerprintSpoofer sharedInstance]
#define isCallerTweak()         [_andromeda isAddrExternal:__builtin_extract_return_addr(__builtin_return_address(0))]

static inline BOOL andromeda_isBundledTweak(const char* path) {
    return path && strncmp(path, "/var/jb/Library/Andromeda/Tweaks/", 33) == 0;
}

static inline NSDictionary* andromeda_prefs(void) {
    return [[AndromedaCore sharedInstance] preferences];
}

static inline BOOL andromeda_prefEnabled(NSString* key) {
    @try {
        NSNumber* val = andromeda_prefs()[key];
        if(!val) return YES;
        return [val boolValue];
    } @catch(NSException *e) {
        return YES;
    }
}

static inline NSArray* andromeda_extraList(NSString* key) {
    @try {
        NSString* raw = andromeda_prefs()[key];
        if(!raw || ![raw isKindOfClass:[NSString class]] || raw.length == 0) return @[];
        NSArray* parts = [raw componentsSeparatedByString:@","];
        NSMutableArray* cleaned = [NSMutableArray array];
        for(NSString* p in parts) {
            NSString* t = [p stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(t.length > 0) [cleaned addObject:t];
        }
        return cleaned;
    } @catch(NSException *e) {
        return @[];
    }
}

static inline NSString* andromeda_detectionMode(void) {
    @try {
        NSString* mode = andromeda_prefs()[@"Detection_Mode"];
        if(mode && [mode isKindOfClass:[NSString class]] && mode.length > 0) return mode;
    } @catch(NSException *e) {}
    return @"spoof";
}

static inline int andromeda_logLevel(void) {
    @try {
        NSString* level = andromeda_prefs()[@"Log_Level"];
        if(!level || ![level isKindOfClass:[NSString class]]) return 2;
        if([level isEqualToString:@"none"]) return 0;
        if([level isEqualToString:@"errors"]) return 1;
        if([level isEqualToString:@"verbose"]) return 3;
        return 2;
    } @catch(NSException *e) {
        return 2;
    }
}

#define ALog(level, fmt, ...) \
    do { if(andromeda_logLevel() >= (level)) NSLog(@"[Andromeda] " fmt, ##__VA_ARGS__); } while(0)

static inline BOOL andromeda_isProtectedProcess(void) {
    @try {
        NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        if(!bundleIdentifier) return NO;
        if([bundleIdentifier hasPrefix:@"com.apple"]) return NO;

        NSString* executablePath = [[NSBundle mainBundle] executablePath];
        if(!executablePath) return NO;
        if([executablePath hasPrefix:@"/Applications"]
        || [executablePath hasPrefix:@"/System"]
        || [executablePath hasPrefix:@"/private/preboot"]
        || [executablePath hasPrefix:@"/usr/libexec"]
        || [executablePath hasPrefix:@"/usr/bin"]
        || [executablePath hasPrefix:@"/usr/sbin"]
        || [executablePath hasPrefix:@"/var/jb"]) {
            return NO;
        }

        NSDictionary* perAppCfg = [[AndromedaCore sharedInstance] perAppConfigurationForBundleId:bundleIdentifier];
        if(perAppCfg) {
            id enabled = perAppCfg[@"enabled"];
            if(enabled && [enabled isKindOfClass:[NSNumber class]]) return [enabled boolValue];
            return YES;
        }

        NSNumber* debugMode = andromeda_prefs()[@"Debug_Mode"];
        if(debugMode && [debugMode isKindOfClass:[NSNumber class]] && [debugMode boolValue]) {
            return YES;
        }

        if([andromeda_prefs()[@"Global_ApplyToAll"] boolValue]) {
            return YES;
        }

        NSString* appKey = [@"App_" stringByAppendingString:bundleIdentifier];
        NSNumber* appOverride = andromeda_prefs()[appKey];
        if(appOverride && [appOverride isKindOfClass:[NSNumber class]]) {
            return [appOverride boolValue];
        }

        return [[AndromedaCore sharedInstance] isProtectedApp];
    } @catch(NSException *e) {
        return NO;
    }
}

extern void andromeda_hook_Filesystem(void);
extern void andromeda_hook_Dyld(void);
extern void andromeda_hook_AntiDebug(void);
extern void andromeda_hook_DeviceCheck(void);
extern void andromeda_hook_AppAttest(void);
extern void andromeda_hook_HardwareFingerprint(void);
extern void andromeda_hook_IOKit(void);
extern void andromeda_hook_Sandbox(void);
extern void andromeda_hook_SymLookup(void);
extern void andromeda_hook_URLScheme(void);
extern void andromeda_hook_EnvVars(void);
extern void andromeda_hook_MachBootstrap(void);
extern void andromeda_hook_ObjCRuntime(void);
extern void andromeda_hook_Syscall(void);
extern void andromeda_hook_TweakClasses(void);
extern void andromeda_hook_Behavioral(void);
extern void andromeda_hook_UIImage(void);
extern void andromeda_hook_Sensors(void);
extern void andromeda_hook_MobileGestalt(void);
extern void andromeda_hook_NetworkInterface(void);
extern void andromeda_hook_ProcFiles(void);
extern void andromeda_hook_IOHID(void);
extern void andromeda_hook_DatingApps(void);
extern void andromeda_hook_SocialApps(void);
extern void andromeda_hook_Adaptive(void);
extern void andromeda_hook_DetectionBypass(void);
extern void andromeda_hook_ProcessHiding(void);
extern void andromeda_hook_FridaBypass(void);
extern void andromeda_hook_DynamicHooker(void);
extern void andromeda_hook_AppAttestBypass_install(void);
extern void andromeda_hook_URLSchemeBypass_install(void);
