#import "Headers/AndromedaCore.h"
#import "Headers/DetectionSignatures.h"
#import <dlfcn.h>
#import <sys/stat.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>

@implementation AndromedaCore {
    NSDictionary* _prefs;
    NSArray* _appSpecificBypasses;
    NSMutableSet* _enabledHooks;
}

+ (instancetype)sharedInstance {
    static AndromedaCore* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[AndromedaCore alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        _enabledHooks = [NSMutableSet set];
        [self loadPreferences];
    }
    return self;
}

- (NSString*)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier] ?: @"com.unknown.app";
}

- (NSString*)executablePath {
    return [[NSBundle mainBundle] executablePath] ?: @"/unknown";
}

- (BOOL)isSystemApp {
    NSString* path = self.executablePath;
    return [path hasPrefix:@"/Applications"]
        || [path hasPrefix:@"/System"]
        || [path hasPrefix:@"/private/preboot"]
        || [path hasPrefix:@"/var/jb"];
}

- (BOOL)isDatingApp {
    return [self isDatingAppBundleId:self.bundleIdentifier];
}

- (BOOL)isSocialApp {
    return [self isSocialAppBundleId:self.bundleIdentifier];
}

- (BOOL)isProtectedApp {
    return self.isDatingApp || self.isSocialApp;
}

- (BOOL)isDatingAppBundleId:(NSString*)bundleId {
    NSDictionary* datingApps = [DetectionSignatures datingAppBundleIds];
    for(NSString* category in datingApps) {
        if([datingApps[category] containsObject:bundleId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSocialAppBundleId:(NSString*)bundleId {
    NSDictionary* socialApps = [DetectionSignatures socialAppBundleIds];
    for(NSString* category in socialApps) {
        if([socialApps[category] containsObject:bundleId]) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary*)preferences {
    return _prefs;
}

- (NSArray*)appSpecificBypasses {
    return _appSpecificBypasses;
}

- (void)loadPreferences {
    _prefs = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    if(!_prefs) {
        _prefs = @{
            @"Global_Enabled": @YES,
            @"Hook_Filesystem": @YES,
            @"Hook_Dyld": @YES,
            @"Hook_AntiDebug": @YES,
            @"Hook_DeviceCheck": @YES,
            @"Hook_AppAttest": @YES,
            @"Hook_HardwareFingerprint": @YES,
            @"Hook_IOKit": @YES,
            @"Hook_Sandbox": @YES,
            @"Hook_SymLookup": @YES,
            @"Hook_URLScheme": @YES,
            @"Hook_EnvVars": @YES,
            @"Hook_MachBootstrap": @YES,
            @"Hook_ObjCRuntime": @YES,
            @"Hook_Syscall": @YES,
            @"Hook_TweakClasses": @YES,
            @"Hook_Behavioral": @YES,
            @"Hook_VnodeBypass": @YES,
            @"Hook_UIImage": @YES,
            @"Strengths_DatingApps": @"maximum",
            @"Strengths_SocialApps": @"high"
        };
    }
}

- (BOOL)isPathRestricted:(NSString*)path {
    if(!path) return NO;
    
    for(NSString* jbPath in [DetectionSignatures jailbreakPaths_fs]) {
        if([path hasPrefix:jbPath]) return YES;
        if([path isEqualToString:jbPath]) return YES;
    }
    
    for(NSString* containingPart in [DetectionSignatures jailbreakPaths_containing]) {
        if([path rangeOfString:containingPart options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return YES;
        }
    }
    
    for(NSString* prefix in [DetectionSignatures jailbreakPaths_prefix]) {
        if([[path lastPathComponent] hasPrefix:prefix]) return YES;
    }
    
    for(NSString* suffix in [DetectionSignatures jailbreakPaths_suffix]) {
        if([path hasSuffix:suffix]) return YES;
    }
    
    for(NSString* symlink in [DetectionSignatures jailbreakSymlinks]) {
        char resolved[PATH_MAX];
        if(realpath([symlink UTF8String], resolved) != NULL) {
            NSString* resolvedPath = @(resolved);
            if([path hasPrefix:resolvedPath] || [path isEqualToString:resolvedPath]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isPathJailbreakRelated:(NSString*)path {
    return [self isPathRestricted:path];
}

- (BOOL)isAddrExternal:(const void*)addr {
    if(!addr) return YES;
    
    intptr_t slide = 0;
    const struct mach_header* mainHeader = NULL;
    
    for(uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char* name = _dyld_get_image_name(i);
        const struct mach_header* hdr = _dyld_get_image_header(i);
        if(name && strstr(name, [[self executablePath] UTF8String])) {
            mainHeader = hdr;
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    if(!mainHeader) return YES;
    
    intptr_t addr_val = (intptr_t)addr - slide;
    
    if(addr_val >= (intptr_t)mainHeader && addr_val < ((intptr_t)mainHeader + 0x100000000)) {
        return NO;
    }
    
    uint32_t self_count = 0;
    for(uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char* name = _dyld_get_image_name(i);
        if(name && (strstr(name, "Andromeda.dylib") || strstr(name, "libsubstitute"))) {
            const struct mach_header* hdr = _dyld_get_image_header(i);
            intptr_t sl = _dyld_get_image_vmaddr_slide(i);
            intptr_t a = (intptr_t)addr;
            intptr_t h = (intptr_t)hdr + sl;
            if(a >= h && a < h + 0x100000) {
                self_count++;
            }
        }
    }
    
    return self_count == 0;
}

- (BOOL)shouldDisableTweakForApp:(NSString*)bundleId {
    if([self isDatingAppBundleId:bundleId]) return YES;
    if([self isSocialAppBundleId:bundleId]) return YES;
    return NO;
}

- (void)applyVnodeBypass {
    DLog(@"vnode bypass: requested to hide jailbreak files");
}

- (void)restoreVnodeBypass {
    DLog(@"vnode bypass: restoring hidden files");
}

@end
