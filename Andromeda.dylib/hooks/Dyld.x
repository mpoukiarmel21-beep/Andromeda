#import "hooks.h"

static void* (*orig_dlopen)(const char*, int) = NULL;
static void* (*orig_dlsym)(void*, const char*) = NULL;
static int (*orig_dlclose)(void*) = NULL;
static int (*orig_dladdr)(const void*, Dl_info*) = NULL;
static uint32_t (*orig__dyld_image_count)(void) = NULL;
static const char* (*orig__dyld_get_image_name)(uint32_t) = NULL;
static const struct mach_header* (*orig__dyld_get_image_header)(uint32_t) = NULL;
static intptr_t (*orig__dyld_get_image_vmaddr_slide)(uint32_t) = NULL;

static BOOL is_suspicious_dylib(const char* name) {
    if(!name) return NO;

    if(strstr(name, "Substrate") || strstr(name, "substitute")
    || strstr(name, "TweakInject") || strstr(name, "MobileSubstrate")
    || strstr(name, "CydiaSubstrate") || strstr(name, "ellekit")
    || strstr(name, "libhooker") || strstr(name, "Andromeda")
    || strstr(name, "Cephei") || strstr(name, "preferenceloader")
    || strstr(name, "rocketbootstrap") || strstr(name, "AppList")
    || strstr(name, "Flipswitch") || strstr(name, "Activator")
    || strstr(name, "Crane") || strstr(name, "Watusi")
    || strstr(name, "iGameGod") || strstr(name, "Hestia")
    || strstr(name, "Shadow") || strstr(name, "A-Bypass")
    || strstr(name, "FlyJB") || strstr(name, "KernBypass")
    || strstr(name, "libsubstitute") || strstr(name, "libsubstrate")
    || strstr(name, "libellekit") || strstr(name, "SubstrateLoader")
    || strstr(name, "SubstrateInserter") || strstr(name, "substitute-loader")
    || strstr(name, "DynamicLibraries") || strstr(name, "PreferenceBundles")
    || strstr(name, "PreferenceLoader") || strstr(name, "TweakInject")) {
        return YES;
    }

    NSString* nsName = @(name);
    for(NSString* suspicious in [DetectionSignatures suspiciousDylibNames]) {
        if([nsName rangeOfString:suspicious options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

static void* hooked_dlopen(const char* path, int mode) {
    if(path && is_suspicious_dylib(path)) {
        DLog(@"Blocked dlopen of: %s", path);
        return NULL;
    }
    return orig_dlopen(path, mode);
}

static void* hooked_dlsym(void* handle, const char* symbol) {
    if(isCallerTweak()) return orig_dlsym(handle, symbol);

    if(symbol) {
        if(strcmp(symbol, "MSHookFunction") == 0
        || strcmp(symbol, "MSHookMessageEx") == 0
        || strcmp(symbol, "MSFindSymbol") == 0
        || strcmp(symbol, "MSGetImageByName") == 0
        || strcmp(symbol, "MSHookMemory") == 0
        || strcmp(symbol, "MSCloseImage") == 0
        || strcmp(symbol, "objc_setHook_getClass") == 0
        || strncmp(symbol, "fishhook_", 9) == 0
        || strncmp(symbol, "rebind_symbols", 14) == 0
        || strncmp(symbol, "MSHook", 6) == 0
        || strncmp(symbol, "SubHook", 7) == 0
        || strncmp(symbol, "LHHook", 6) == 0
        || strncmp(symbol, "substitute_", 11) == 0) {
            return NULL;
        }
    }
    return orig_dlsym(handle, symbol);
}

static int hooked_dlclose(void* handle) {
    return orig_dlclose(handle);
}

static int hooked_dladdr(const void* addr, Dl_info* info) {
    if(!isCallerTweak() && addr) {
        const char* name = dyld_image_path_containing_address(addr);
        if(name && is_suspicious_dylib(name)) {
            if(info) {
                info->dli_fname = "/usr/lib/libSystem.B.dylib";
                info->dli_fbase = (void*)0x1000;
                info->dli_sname = NULL;
                info->dli_saddr = NULL;
            }
            return 1;
        }
    }
    return orig_dladdr(addr, info);
}

static uint32_t hooked__dyld_image_count(void) {
    return orig__dyld_image_count();
}

static const char* hooked__dyld_get_image_name(uint32_t index) {
    const char* name = orig__dyld_get_image_name(index);
    if(!isCallerTweak() && name && is_suspicious_dylib(name)) {
        return "/usr/lib/libobjc.A.dylib";
    }
    return name;
}

static const struct mach_header* hooked__dyld_get_image_header(uint32_t index) {
    return orig__dyld_get_image_header(index);
}

static intptr_t hooked__dyld_get_image_vmaddr_slide(uint32_t index) {
    return orig__dyld_get_image_vmaddr_slide(index);
}

%hook NSBundle

+ (NSArray*)allBundles {
    NSArray* bundles = %orig;
    if(!bundles) return bundles;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:bundles.count];
    for(NSBundle* bundle in bundles) {
        if(![_andromeda isPathRestricted:[bundle bundlePath]]) {
            [filtered addObject:bundle];
        }
    }
    return [filtered copy];
}

+ (NSArray*)allFrameworks {
    NSArray* frameworks = %orig;
    if(!frameworks) return frameworks;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:frameworks.count];
    for(NSBundle* bundle in frameworks) {
        if(![_andromeda isPathRestricted:[bundle bundlePath]]) {
            [filtered addObject:bundle];
        }
    }
    return [filtered copy];
}

- (NSString*)resourcePath {
    NSString* path = %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        return [[NSBundle mainBundle] bundlePath];
    }
    return path;
}

- (NSArray*)pathsForResourcesOfType:(NSString*)ext inDirectory:(NSString*)subpath {
    NSArray* paths = %orig;
    if(!paths) return paths;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:paths.count];
    for(NSString* path in paths) {
        if(![_andromeda isPathRestricted:path]) {
            [filtered addObject:path];
        }
    }
    return [filtered copy];
}

%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_Dyld(void) {
    MSHookFunction((void*)dlopen, (void*)hooked_dlopen, (void**)&orig_dlopen);
    MSHookFunction((void*)dlsym, (void*)hooked_dlsym, (void**)&orig_dlsym);
    MSHookFunction((void*)dlclose, (void*)hooked_dlclose, (void**)&orig_dlclose);
    MSHookFunction((void*)dladdr, (void*)hooked_dladdr, (void**)&orig_dladdr);
    MSHookFunction((void*)_dyld_image_count, (void*)hooked__dyld_image_count, (void**)&orig__dyld_image_count);
    MSHookFunction((void*)_dyld_get_image_name, (void*)hooked__dyld_get_image_name, (void**)&orig__dyld_get_image_name);
    MSHookFunction((void*)_dyld_get_image_header, (void*)hooked__dyld_get_image_header, (void**)&orig__dyld_get_image_header);
    MSHookFunction((void*)_dyld_get_image_vmaddr_slide, (void*)hooked__dyld_get_image_vmaddr_slide, (void**)&orig__dyld_get_image_vmaddr_slide);
}
