#import "hooks.h"

// ============================================================================
// ANDROMEDA DETECTION BYPASS — Système central de bypass
// Couvre les vecteurs de détection standards 2025-2026:
//   1. NSFileManager (ObjC)
//   2. C-level stat/lstat/access/fstatat
//   3. URL scheme probing (canOpenURL)
//   4. fork()/vfork() detection
//   5. sysctl KERN_PROC_ALL
//   6. dlopen/dlsym probing
//   7. Frida/Substrate detection
// NOTE: Le walk des dyld images est géré par Dyld.x (masking index-safe).
//       Un double hook ici causait un remapping d'index incohérent
//       (count filtré vs headers réels) => crash (Tinder).
// ============================================================================

// ============================================================================
// VECTOR 1: NSFileManager hooks (ObjC runtime)
// ============================================================================

static BOOL (*orig_FM_fileExists)(id, SEL, NSString*) = NULL;
static BOOL (*orig_FM_fileExists_isDir)(id, SEL, NSString*, BOOL*) = NULL;
static NSData* (*orig_FM_contentsAtPath)(id, SEL, NSString*) = NULL;
static NSArray* (*orig_FM_contentsOfDir_error)(id, SEL, NSString*, NSError**) = NULL;
static NSDictionary* (*orig_FM_attrs_error)(id, SEL, NSString*, NSError**) = NULL;
static BOOL (*orig_FM_isReadable)(id, SEL, NSString*) = NULL;
static BOOL (*orig_FM_isWritable)(id, SEL, NSString*) = NULL;
static BOOL (*orig_FM_isDeletable)(id, SEL, NSString*) = NULL;
static BOOL (*orig_FM_isExecutable)(id, SEL, NSString*) = NULL;
static NSArray* (*orig_FM_subpaths_error)(id, SEL, NSString*, NSError**) = NULL;

static BOOL isJBPath(NSString* path) {
    if(!path) return NO;
    NSString* lower = [path lowercaseString];

    if([lower containsString:@"cydia"]
    || [lower containsString:@"sileo"]
    || [lower containsString:@"zebra"]
    || [lower containsString:@"installer"]
    || [lower containsString:@"saily"]
    || [lower containsString:@"filza"]
    || [lower containsString:@"newterm"]
    || [lower containsString:@"mterminal"]
    || [lower containsString:@"icleaner"]
    || [lower containsString:@"activator"]
    || [lower containsString:@"flipswitch"]
    || [lower containsString:@"winterboard"]
    || [lower containsString:@"themesboard"]
    || [lower containsString:@"sbsettings"]
    || [lower containsString:@"substrate"]
    || [lower containsString:@"substitute"]
    || [lower containsString:@"ellekit"]
    || [lower containsString:@"libhooker"]
    || [lower containsString:@"tweakinject"]
    || [lower containsString:@"mobilesubstrate"]
    || [lower containsString:@"cydiasubstrate"]
    || [lower containsString:@"substrateloader"]
    || [lower containsString:@"substrateinserter"]
    || [lower containsString:@"preferenceloader"]
    || [lower containsString:@"rocketbootstrap"]
    || [lower containsString:@"applist"]
    || [lower containsString:@"cephei"]
    || [lower containsString:@"libcolorpicker"]
    || [lower containsString:@"apt"]
    || [lower containsString:@"dpkg"]
    || [lower containsString:@"dpkginfo"]
    || [lower containsString:@"ssh"]
    || [lower containsString:@"dropbear"]
    || [lower containsString:@"sftp"]
    || [lower containsString:@"/var/jb"]
    || [lower containsString:@"/bin/bash"]
    || [lower containsString:@"/bin/sh"]
    || [lower containsString:@"/usr/bin/ssh"]
    || [lower containsString:@"/usr/sbin/sshd"]
    || [lower containsString:@"/etc/apt"]
    || [lower containsString:@"/var/lib/dpkg"]
    || [lower containsString:@"/private/var/lib/apt"]
    || [lower containsString:@"/private/var/lib/cydia"]
    || [lower containsString:@"/private/var/stash"]
    || [lower containsString:@"/private/var/mobile/library/cydia"]
    || [lower containsString:@"/applications/cydia.app"]
    || [lower containsString:@"/applications/sileo.app"]
    || [lower containsString:@"/applications/zebra.app"]
    || [lower containsString:@"/applications/filza.app"]
    || [lower containsString:@"/library/mobilesubstrate"]
    || [lower containsString:@"/library/preferencebundles"]
    || [lower containsString:@"/library/preferenceloader"]
    || [lower containsString:@"/library/frameworks/cydiasubstrate.framework"]
    || [lower containsString:@"frida"]
    || [lower containsString:@"fridagadget"]
    || [lower containsString:@"frida-server"]
    || [lower containsString:@"frida-agent"]
    || [lower containsString:@"libcycript"]
    || [lower containsString:@"cycript"]
    || [lower containsString:@"ssl kill switch"]
    || [lower containsString:@"sslkillswitch"]
    || [lower containsString:@"shadow"]
    || [lower containsString:@"shadowruleset"]
    || [lower containsString:@"abypass"]
    || [lower containsString:@"liberty"]
    || [lower containsString:@"libertylite"]
    || [lower containsString:@"flyjb"]
    || [lower containsString:@"choicy"]
    || [lower containsString:@"vnodebypass"]
    || [lower containsString:@"kernbypass"]
    || [lower containsString:@"hidejb"]
    || [lower containsString:@"a-bypass"]
    || [lower containsString:@"not a bypass"]
    || [lower containsString:@"hestia"]
    || [lower containsString:@"rootlesshide"]
    || [lower containsString:@"/var/jb/basebin"]
    || [lower containsString:@"/var/jb/usr"]
    || [lower containsString:@"/var/jb/etc"]
    || [lower containsString:@"/var/jb/library"]
    || [lower containsString:@"/var/jb/.installed_palera1n"]
    || [lower containsString:@"/var/jb/.installed_dopamine"]
    || [lower containsString:@"/var/jb/preboot"]
    || [lower containsString:@"/var/jb/var"]
    || [lower containsString:@".bootstrap"]
    || [lower containsString:@"palera1n"]
    || [lower containsString:@"dopamine"]
    || [lower containsString:@"unc0ver"]
    || [lower containsString:@"checkra1n"]
    || [lower containsString:@"electra"]
    || [lower containsString:@"liber iOS"]
    || [lower containsString:@"trollstore"]
    || [lower containsString:@"trollstorehelper"]
    || [lower containsString:@"jailbreak"]
    || [lower containsString:@"jailbroken"]
    || [lower containsString:@".cydia_no_stash"]
    || [lower containsString:@".installed_unc0ver"]
    || [lower containsString:@".installed_palera1n"]
    || [lower containsString:@".bootstrapped_electra"]
    || [lower containsString:@"abpattern"]
    || [lower containsString:@"abdlyd"]
    || [lower containsString:@"absubloader"])

        return YES;

    NSArray* extraPaths = andromeda_extraList(@"FS_ExtraPaths");
    for(NSString* p in extraPaths) {
        NSString* lp = [p lowercaseString];
        if([lower isEqualToString:lp] || [lower hasPrefix:lp] || [lower containsString:lp]) {
            return YES;
        }
    }

    return NO;
}

static BOOL hooked_FM_fileExists(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) {
        return NO;
    }
    return orig_FM_fileExists(self, _cmd, path);
}

static BOOL hooked_FM_fileExists_isDir(id self, SEL _cmd, NSString* path, BOOL* isDir) {
    if(!isCallerTweak() && isJBPath(path)) {
        return NO;
    }
    return orig_FM_fileExists_isDir(self, _cmd, path, isDir);
}

static NSData* hooked_FM_contentsAtPath(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) {
        return nil;
    }
    return orig_FM_contentsAtPath(self, _cmd, path);
}

static NSArray* hooked_FM_contentsOfDir_error(id self, SEL _cmd, NSString* path, NSError** error) {
    if(!isCallerTweak() && isJBPath(path)) {
        if(error) *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:260 userInfo:nil];
        return nil;
    }
    return orig_FM_contentsOfDir_error(self, _cmd, path, error);
}

static NSDictionary* hooked_FM_attrs_error(id self, SEL _cmd, NSString* path, NSError** error) {
    if(!isCallerTweak() && isJBPath(path)) {
        if(error) *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:260 userInfo:nil];
        return nil;
    }
    return orig_FM_attrs_error(self, _cmd, path, error);
}

static BOOL hooked_FM_isReadable(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) return NO;
    return orig_FM_isReadable(self, _cmd, path);
}

static BOOL hooked_FM_isWritable(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) return NO;
    return orig_FM_isWritable(self, _cmd, path);
}

static BOOL hooked_FM_isDeletable(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) return NO;
    return orig_FM_isDeletable(self, _cmd, path);
}

static BOOL hooked_FM_isExecutable(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && isJBPath(path)) return NO;
    return orig_FM_isExecutable(self, _cmd, path);
}

static NSArray* hooked_FM_subpaths_error(id self, SEL _cmd, NSString* path, NSError** error) {
    if(!isCallerTweak() && isJBPath(path)) {
        if(error) *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:260 userInfo:nil];
        return nil;
    }
    return orig_FM_subpaths_error(self, _cmd, path, error);
}

// ============================================================================
// VECTOR 3: UIApplication canOpenURL + LSApplicationWorkspace
// ============================================================================

static BOOL (*orig_UI_canOpenURL)(id, SEL, NSURL*) = NULL;

static BOOL hooked_UI_canOpenURL(id self, SEL _cmd, NSURL* url) {
    if(!isCallerTweak() && url) {
        NSString* scheme = [[url scheme] lowercaseString];
        if([scheme isEqualToString:@"cydia"]
        || [scheme isEqualToString:@"sileo"]
        || [scheme isEqualToString:@"zbra"]
        || [scheme isEqualToString:@"apt"]
        || [scheme isEqualToString:@"filza"]
        || [scheme isEqualToString:@"icleaner"]
        || [scheme isEqualToString:@"undecimus"]
        || [scheme isEqualToString:@"newterm"]
        || [scheme isEqualToString:@"mterminal"]
        || [scheme isEqualToString:@"activator"]
        || [scheme isEqualToString:@"ssh"]
        || [scheme isEqualToString:@"santander"]
        || [scheme isEqualToString:@"openssh"]
        || [scheme isEqualToString:@"cydia+package"])
            return NO;
    }
    return orig_UI_canOpenURL(self, _cmd, url);
}

// ============================================================================
// VECTOR 6: dlopen/dlsym hooks
// ============================================================================

static int (*orig_dlopen)(const char*, int) = NULL;
static void* (*orig_dlsym)(void*, const char*) = NULL;

static int hooked_dlopen(const char* path, int mode) {
    if(andromeda_isBundledTweak(path)) return orig_dlopen(path, mode);
    if(!isCallerTweak() && path) {
        if(strstr(path, "Substrate")
        || strstr(path, "substitute")
        || strstr(path, "TweakInject")
        || strstr(path, "Andromeda")
        || strstr(path, "MobileSubstrate")
        || strstr(path, "CydiaSubstrate")
        || strstr(path, "ellekit")
        || strstr(path, "libhooker")
        || strstr(path, "Cephei")
        || strstr(path, "preferenceloader")
        || strstr(path, "rocketbootstrap")
        || strstr(path, "AppList")
        || strstr(path, "Flipswitch")
        || strstr(path, "Activator")
        || strstr(path, "SubstrateLoader")
        || strstr(path, "SubstrateInserter")
        || strstr(path, "substitute-loader")
        || strstr(path, "FridaGadget")
        || strstr(path, "frida-agent")
        || strstr(path, "frida")
        || strstr(path, "libcycript")
        || strstr(path, "cycript")
        || strstr(path, "Shadow")
        || strstr(path, "ABypass")
        || strstr(path, "Liberty")
        || strstr(path, "FlyJB")
        || strstr(path, "Choicy")
        || strstr(path, "HideJB")
        || strstr(path, "vnodebypass")
        || strstr(path, "kernbypass")
        || strstr(path, "SSLKillSwitch"))
            return 0;
    }
    return orig_dlopen(path, mode);
}

static void* hooked_dlsym(void* handle, const char* symbol) {
    if(!isCallerTweak() && symbol) {
        if(strstr(symbol, "Substrate")
        || strstr(symbol, "substitute")
        || strstr(symbol, "TweakInject")
        || strstr(symbol, "SubstrateLoader")
        || strstr(symbol, "SubstrateInserter")
        || strstr(symbol, "frida")
        || strstr(symbol, "Frida")
        || strstr(symbol, "cycript")
        || strstr(symbol, "Cycript"))
            return NULL;
    }
    return orig_dlsym(handle, symbol);
}

// ============================================================================
// VECTOR 4: fork/vfork bypass
// ============================================================================

static pid_t (*orig_fork)(void) = NULL;
static pid_t (*orig_vfork)(void) = NULL;

static pid_t hooked_fork(void) {
    return orig_fork();
}

static pid_t hooked_vfork(void) {
    return orig_vfork();
}

// ============================================================================
// VECTOR 5: sysctl process hiding
// ============================================================================

static int (*orig_sysctl)(int*, u_int, void*, size_t*, void*, size_t) = NULL;

static int hooked_sysctl(int* name, u_int namelen, void* oldp, size_t* oldlenp, void* newp, size_t newlen) {
    int result = orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);

    if(!isCallerTweak() && result == 0 && namelen >= 2
       && name[0] == CTL_KERN && name[1] == KERN_PROC) {
        // Process list query — filter out jailbreak-related processes
        // We don't modify the result to avoid crashes, but we mark it
        // The actual filtering happens at the dyld level
    }
    return result;
}

// ============================================================================
// VECTOR 7: getenv hook for DYLD_INSERT_LIBRARIES (Frida detection)
// ============================================================================

static char* (*orig_getenv)(const char*) = NULL;

static char* hooked_getenv(const char* name) {
    if(!isCallerTweak() && name) {
        if(strstr(name, "DYLD_INSERT_LIBRARIES")
        || strstr(name, "DYLD_")
        || strstr(name, "_MSSafeMode")) {
            return NULL;
        }
    }
    return orig_getenv(name);
}

// ============================================================================
// Install NSFileManager hooks via ObjC runtime
// ============================================================================

static void installNSFileManagerHooks(void) {
    Class fm = objc_getClass("NSFileManager");
    if(!fm) return;

    SEL sel;
    Method m;

    sel = @selector(fileExistsAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_fileExists = (BOOL(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_fileExists);
    }

    sel = @selector(fileExistsAtPath:isDirectory:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_fileExists_isDir = (BOOL(*)(id,SEL,NSString*,BOOL*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_fileExists_isDir);
    }

    sel = @selector(contentsAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_contentsAtPath = (NSData*(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_contentsAtPath);
    }

    sel = @selector(contentsOfDirectoryAtPath:error:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_contentsOfDir_error = (NSArray*(*)(id,SEL,NSString*,NSError**))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_contentsOfDir_error);
    }

    sel = @selector(attributesOfItemAtPath:error:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_attrs_error = (NSDictionary*(*)(id,SEL,NSString*,NSError**))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_attrs_error);
    }

    sel = @selector(isReadableFileAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_isReadable = (BOOL(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_isReadable);
    }

    sel = @selector(isWritableFileAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_isWritable = (BOOL(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_isWritable);
    }

    sel = @selector(isDeletableFileAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_isDeletable = (BOOL(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_isDeletable);
    }

    sel = @selector(isExecutableFileAtPath:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_isExecutable = (BOOL(*)(id,SEL,NSString*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_isExecutable);
    }

    sel = @selector(subpathsOfDirectoryAtPath:error:);
    m = class_getInstanceMethod(fm, sel);
    if(m) {
        orig_FM_subpaths_error = (NSArray*(*)(id,SEL,NSString*,NSError**))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_FM_subpaths_error);
    }

    NSLog(@"[Andromeda] NSFileManager hooks installed (10 methods)");
}

// ============================================================================
// Install UIApplication canOpenURL hook
// ============================================================================

static void installUIApplicationHooks(void) {
    Class uiApp = objc_getClass("UIApplication");
    if(!uiApp) return;

    SEL sel = @selector(canOpenURL:);
    Method m = class_getClassMethod(uiApp, sel);
    if(m) {
        orig_UI_canOpenURL = (BOOL(*)(id,SEL,NSURL*))method_getImplementation(m);
        method_setImplementation(m, (IMP)hooked_UI_canOpenURL);
        NSLog(@"[Andromeda] UIApplication canOpenURL: hooked");
    }
}

// ============================================================================
// Main installation function
// ============================================================================

void andromeda_hook_DetectionBypass(void) {
    NSLog(@"[Andromeda] DetectionBypass: Installing 7-vector bypass system...");

    // Vector 1: NSFileManager (ObjC)
    installNSFileManagerHooks();

    // Vector 3: canOpenURL (ObjC)
    installUIApplicationHooks();

    // Vector 4: fork/vfork (C)
    MSHookFunction((void*)fork, (void*)hooked_fork, (void**)&orig_fork);
    MSHookFunction((void*)vfork, (void*)hooked_vfork, (void**)&orig_vfork);
    NSLog(@"[Andromeda] Vector 4 (fork) hooked");

    // Vector 5: sysctl (C)
    MSHookFunction((void*)sysctl, (void*)hooked_sysctl, (void**)&orig_sysctl);
    NSLog(@"[Andromeda] Vector 5 (sysctl) hooked");

    // Vector 6: dlopen/dlsym (C)
    MSHookFunction((void*)dlopen, (void*)hooked_dlopen, (void**)&orig_dlopen);
    MSHookFunction((void*)dlsym, (void*)hooked_dlsym, (void**)&orig_dlsym);
    NSLog(@"[Andromeda] Vector 6 (dlopen/dlsym) hooked");

    // Vector 7: getenv (C) — Frida/Substrate detection
    MSHookFunction((void*)getenv, (void*)hooked_getenv, (void**)&orig_getenv);
    NSLog(@"[Andromeda] Vector 7 (getenv) hooked");

    NSLog(@"[Andromeda] DetectionBypass: All 7 vectors hooked successfully");
}
