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

static inline BOOL andromeda_prefEnabled(NSString* key) {
    @try {
        NSNumber* val = [[AndromedaCore sharedInstance] preferences][key];
        if(!val) return YES;
        return [val boolValue];
    } @catch(NSException *e) {
        return YES;
    }
}

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

        NSNumber* debugMode = [[AndromedaCore sharedInstance] preferences][@"Debug_Mode"];
        if(debugMode && [debugMode isKindOfClass:[NSNumber class]] && [debugMode boolValue]) {
            return YES;
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
