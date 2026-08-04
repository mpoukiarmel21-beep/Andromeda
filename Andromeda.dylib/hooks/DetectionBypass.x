#import "hooks.h"

static BOOL (*orig_NSFileManager_fileExistsAtPath)(id, SEL, NSString*) = NULL;
static BOOL (*orig_NSFileManager_fileExistsAtPath_isDirectory)(id, SEL, NSString*, BOOL*) = NULL;
static NSData* (*orig_NSFileManager_contentsAtPath)(id, SEL, NSString*) = NULL;
static NSArray* (*orig_NSFileManager_contentsOfDirectoryAtPath_error)(id, SEL, NSString*, NSError**) = NULL;
static NSDictionary* (*orig_NSFileManager_attributesOfItemAtPath_error)(id, SEL, NSString*, NSError**) = NULL;

static BOOL hooked_NSFileManager_fileExistsAtPath(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && path) {
        NSString* lower = [path lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substitute"]
        || [lower containsString:@"tweakinject"]
        || [lower containsString:@"libhooker"]
        || [lower containsString:@"ellekit"]
        || [lower containsString:@"apt"]
        || [lower containsString:@"dpkg"]
        || [lower containsString:@"ssh"]
        || [lower containsString:@"dropbear"]
        || [lower containsString:@"filza"]
        || [lower containsString:@"terminal"]
        || [lower containsString:@"mobilesubstrate"]
        || [lower containsString:@"cydiasubstrate"]
        || [lower containsString:@"preferenceloader"]
        || [lower containsString:@"rocketbootstrap"]
        || [lower containsString:@"applist"]
        || [lower containsString:@"activator"]
        || [lower containsString:@"flipswitch"]
        || [lower containsString:@"cephei"]
        || [lower containsString:@"libcolorpicker"]
        || [lower containsString:@"jailbreak"]
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
        || [lower containsString:@"/library/mobilesubstrate"]
        || [lower containsString:@"/library/preferencebundles"]
        || [lower containsString:@"/library/preferenceloader"]
        || [lower containsString:@"/library/frameworks/cydiasubstrate.framework"]
        || [lower containsString:@"substrateloader"]
        || [lower containsString:@"substrateinserter"]
        || [lower containsString:@"tweakinject"]) {
            NSLog(@"[Andromeda] Blocked fileExists: %@", path);
            return NO;
        }
    }
    return orig_NSFileManager_fileExistsAtPath(self, _cmd, path);
}

static BOOL hooked_NSFileManager_fileExistsAtPath_isDirectory(id self, SEL _cmd, NSString* path, BOOL* isDir) {
    if(!isCallerTweak() && path) {
        NSString* lower = [path lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substitute"]
        || [lower containsString:@"tweakinject"]
        || [lower containsString:@"apt"]
        || [lower containsString:@"dpkg"]
        || [lower containsString:@"jailbreak"]
        || [lower containsString:@"/var/jb"]
        || [lower containsString:@"/bin/bash"]
        || [lower containsString:@"/bin/sh"]
        || [lower containsString:@"/usr/bin/ssh"]
        || [lower containsString:@"/etc/apt"]
        || [lower containsString:@"/var/lib/dpkg"]
        || [lower containsString:@"/applications/cydia.app"]
        || [lower containsString:@"/applications/sileo.app"]
        || [lower containsString:@"/applications/zebra.app"]
        || [lower containsString:@"/library/mobilesubstrate"]
        || [lower containsString:@"substrateloader"]
        || [lower containsString:@"tweakinject"]) {
            NSLog(@"[Andromeda] Blocked fileExists:isDir: %@", path);
            return NO;
        }
    }
    return orig_NSFileManager_fileExistsAtPath_isDirectory(self, _cmd, path, isDir);
}

static NSData* hooked_NSFileManager_contentsAtPath(id self, SEL _cmd, NSString* path) {
    if(!isCallerTweak() && path) {
        NSString* lower = [path lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substitute"]
        || [lower containsString:@"tweakinject"]
        || [lower containsString:@"apt"]
        || [lower containsString:@"dpkg"]
        || [lower containsString:@"jailbreak"]
        || [lower containsString:@"/var/jb"]
        || [lower containsString:@"/library/mobilesubstrate"]
        || [lower containsString:@"substrateloader"]
        || [lower containsString:@"tweakinject"]) {
            NSLog(@"[Andromeda] Blocked contentsAtPath: %@", path);
            return nil;
        }
    }
    return orig_NSFileManager_contentsAtPath(self, _cmd, path);
}

static NSArray* hooked_NSFileManager_contentsOfDirectoryAtPath_error(id self, SEL _cmd, NSString* path, NSError** error) {
    if(!isCallerTweak() && path) {
        NSString* lower = [path lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substitute"]
        || [lower containsString:@"tweakinject"]
        || [lower containsString:@"apt"]
        || [lower containsString:@"dpkg"]
        || [lower containsString:@"jailbreak"]
        || [lower containsString:@"/var/jb"]
        || [lower containsString:@"/library/mobilesubstrate"]
        || [lower containsString:@"substrateloader"]
        || [lower containsString:@"tweakinject"]) {
            NSLog(@"[Andromeda] Blocked contentsOfDirectory: %@", path);
            if(error) *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:260 userInfo:nil];
            return nil;
        }
    }
    return orig_NSFileManager_contentsOfDirectoryAtPath_error(self, _cmd, path, error);
}

static NSDictionary* hooked_NSFileManager_attributesOfItemAtPath_error(id self, SEL _cmd, NSString* path, NSError** error) {
    if(!isCallerTweak() && path) {
        NSString* lower = [path lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substitute"]
        || [lower containsString:@"tweakinject"]
        || [lower containsString:@"apt"]
        || [lower containsString:@"dpkg"]
        || [lower containsString:@"jailbreak"]
        || [lower containsString:@"/var/jb"]
        || [lower containsString:@"/library/mobilesubstrate"]
        || [lower containsString:@"substrateloader"]
        || [lower containsString:@"tweakinject"]) {
            NSLog(@"[Andromeda] Blocked attributes: %@", path);
            if(error) *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:260 userInfo:nil];
            return nil;
        }
    }
    return orig_NSFileManager_attributesOfItemAtPath_error(self, _cmd, path, error);
}

static BOOL (*orig_UIApplication_canOpenURL)(id, SEL, NSURL*) = NULL;

static BOOL hooked_UIApplication_canOpenURL(id self, SEL _cmd, NSURL* url) {
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
        || [scheme isEqualToString:@"ssh"]) {
            NSLog(@"[Andromeda] Blocked canOpenURL: %@", url);
            return NO;
        }
    }
    return orig_UIApplication_canOpenURL(self, _cmd, url);
}

static int (*orig_dlopen)(const char*, int) = NULL;
static void* (*orig_dlsym)(void*, const char*) = NULL;

static int hooked_dlopen(const char* path, int mode) {
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
        || strstr(path, "substitute-loader")) {
            NSLog(@"[Andromeda] Blocked dlopen: %s", path);
            return 0;
        }
    }
    return orig_dlopen(path, mode);
}

static void* hooked_dlsym(void* handle, const char* symbol) {
    if(!isCallerTweak() && symbol) {
        if(strstr(symbol, "Substrate")
        || strstr(symbol, "substitute")
        || strstr(symbol, "TweakInject")
        || strstr(symbol, "SubstrateLoader")
        || strstr(symbol, "SubstrateInserter")) {
            NSLog(@"[Andromeda] Blocked dlsym: %s", symbol);
            return NULL;
        }
    }
    return orig_dlsym(handle, symbol);
}

static uint32_t (*orig__dyld_image_count)(void) = NULL;
static const char* (*orig__dyld_get_image_name)(uint32_t) = NULL;
static const struct mach_header* (*orig__dyld_get_image_header)(uint32_t) = NULL;

static uint32_t hooked__dyld_image_count(void) {
    if(isCallerTweak()) return orig__dyld_image_count();
    uint32_t count = orig__dyld_image_count();
    uint32_t filtered = 0;
    for(uint32_t i = 0; i < count; i++) {
        const char* name = orig__dyld_get_image_name(i);
        if(name && !strstr(name, "Substrate")
        && !strstr(name, "substitute")
        && !strstr(name, "TweakInject")
        && !strstr(name, "Andromeda")
        && !strstr(name, "MobileSubstrate")
        && !strstr(name, "CydiaSubstrate")
        && !strstr(name, "ellekit")
        && !strstr(name, "libhooker")
        && !strstr(name, "Cephei")
        && !strstr(name, "preferenceloader")
        && !strstr(name, "rocketbootstrap")
        && !strstr(name, "AppList")
        && !strstr(name, "Flipswitch")
        && !strstr(name, "Activator")
        && !strstr(name, "SubstrateLoader")
        && !strstr(name, "SubstrateInserter")
        && !strstr(name, "substitute-loader")
        && !strstr(name, "DynamicLibraries")
        && !strstr(name, "PreferenceBundles")) {
            filtered++;
        }
    }
    return filtered;
}

static const char* hooked__dyld_get_image_name(uint32_t index) {
    if(isCallerTweak()) return orig__dyld_get_image_name(index);
    uint32_t count = orig__dyld_image_count();
    uint32_t filtered = 0;
    for(uint32_t i = 0; i < count; i++) {
        const char* name = orig__dyld_get_image_name(i);
        if(name && !strstr(name, "Substrate")
        && !strstr(name, "substitute")
        && !strstr(name, "TweakInject")
        && !strstr(name, "Andromeda")
        && !strstr(name, "MobileSubstrate")
        && !strstr(name, "CydiaSubstrate")
        && !strstr(name, "ellekit")
        && !strstr(name, "libhooker")
        && !strstr(name, "Cephei")
        && !strstr(name, "preferenceloader")
        && !strstr(name, "rocketbootstrap")
        && !strstr(name, "AppList")
        && !strstr(name, "Flipswitch")
        && !strstr(name, "Activator")
        && !strstr(name, "SubstrateLoader")
        && !strstr(name, "SubstrateInserter")
        && !strstr(name, "substitute-loader")
        && !strstr(name, "DynamicLibraries")
        && !strstr(name, "PreferenceBundles")) {
            if(filtered == index) return name;
            filtered++;
        }
    }
    return orig__dyld_get_image_name(index);
}

static const struct mach_header* hooked__dyld_get_image_header(uint32_t index) {
    return orig__dyld_get_image_header(index);
}

void andromeda_hook_DetectionBypass(void) {
    Class nsFileManager = objc_getClass("NSFileManager");
    if(nsFileManager) {
        SEL sel = @selector(fileExistsAtPath:);
        Method m = class_getInstanceMethod(nsFileManager, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_NSFileManager_fileExistsAtPath);
            NSLog(@"[Andromeda] Hooked NSFileManager fileExistsAtPath:");
        }
        
        sel = @selector(fileExistsAtPath:isDirectory:);
        m = class_getInstanceMethod(nsFileManager, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_NSFileManager_fileExistsAtPath_isDirectory);
            NSLog(@"[Andromeda] Hooked NSFileManager fileExistsAtPath:isDirectory:");
        }
        
        sel = @selector(contentsAtPath:);
        m = class_getInstanceMethod(nsFileManager, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_NSFileManager_contentsAtPath);
            NSLog(@"[Andromeda] Hooked NSFileManager contentsAtPath:");
        }
        
        sel = @selector(contentsOfDirectoryAtPath:error:);
        m = class_getInstanceMethod(nsFileManager, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_NSFileManager_contentsOfDirectoryAtPath_error);
            NSLog(@"[Andromeda] Hooked NSFileManager contentsOfDirectoryAtPath:error:");
        }
        
        sel = @selector(attributesOfItemAtPath:error:);
        m = class_getInstanceMethod(nsFileManager, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_NSFileManager_attributesOfItemAtPath_error);
            NSLog(@"[Andromeda] Hooked NSFileManager attributesOfItemAtPath:error:");
        }
    }
    
    Class uiApplication = objc_getClass("UIApplication");
    if(uiApplication) {
        SEL sel = @selector(canOpenURL:);
        Method m = class_getClassMethod(uiApplication, sel);
        if(m) {
            method_setImplementation(m, (IMP)hooked_UIApplication_canOpenURL);
            NSLog(@"[Andromeda] Hooked UIApplication canOpenURL:");
        }
    }
    
    MSHookFunction((void*)dlopen, (void*)hooked_dlopen, (void**)&orig_dlopen);
    MSHookFunction((void*)dlsym, (void*)hooked_dlsym, (void**)&orig_dlsym);
    MSHookFunction((void*)_dyld_image_count, (void*)hooked__dyld_image_count, (void**)&orig__dyld_image_count);
    MSHookFunction((void*)_dyld_get_image_name, (void*)hooked__dyld_get_image_name, (void**)&orig__dyld_get_image_name);
    MSHookFunction((void*)_dyld_get_image_header, (void*)hooked__dyld_get_image_header, (void**)&orig__dyld_get_image_header);
    
    NSLog(@"[Andromeda] DetectionBypass hooks installed");
}
