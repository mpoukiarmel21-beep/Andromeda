#import "hooks.h"

static const char** (*orig_objc_copyImageNames)(unsigned int*) = NULL;
static const char* (*orig_class_getImageName)(Class) = NULL;
static unsigned int (*orig_objc_getClassList)(Class*, int) = NULL;

static BOOL andromeda_is_suspicious_image(const char* name) {
    if(!name) return NO;
    if(strstr(name, "Substrate") || strstr(name, "substitute")
    || strstr(name, "TweakInject") || strstr(name, "Andromeda")
    || strstr(name, "MobileSubstrate") || strstr(name, "CydiaSubstrate")
    || strstr(name, "ellekit") || strstr(name, "libhooker")
    || strstr(name, "Cephei") || strstr(name, "preferenceloader")
    || strstr(name, "rocketbootstrap") || strstr(name, "AppList")
    || strstr(name, "Flipswitch") || strstr(name, "Activator")
    || strstr(name, "DynamicLibraries") || strstr(name, "PreferenceBundles")) {
        return YES;
    }
    NSString* n = @(name);
    for(NSString* s in [DetectionSignatures suspiciousDylibNames]) {
        if([n rangeOfString:s options:NSCaseInsensitiveSearch].location != NSNotFound) return YES;
    }
    return NO;
}

static const char** hooked_objc_copyImageNames(unsigned int* outCount) {
    const char** images = orig_objc_copyImageNames(outCount);
    if(!isCallerTweak() && images && outCount && *outCount > 0) {
        unsigned int count = *outCount;
        unsigned int fc = 0;
        for(unsigned int i = 0; i < count; i++) {
            if(!andromeda_is_suspicious_image(images[i])) fc++;
        }
        const char** filtered = (const char**)malloc(fc * sizeof(const char*));
        if(!filtered) return images;
        unsigned int idx = 0;
        for(unsigned int i = 0; i < count; i++) {
            if(!andromeda_is_suspicious_image(images[i])) {
                filtered[idx++] = images[i];
            }
        }
        free((void*)images);
        *outCount = fc;
        return filtered;
    }
    return images;
}

static const char* hooked_class_getImageName(Class cls) {
    const char* name = orig_class_getImageName(cls);
    if(!isCallerTweak() && name && andromeda_is_suspicious_image(name)) {
        return "/usr/lib/libobjc.A.dylib";
    }
    return name;
}

static unsigned int hooked_objc_getClassList(Class* buffer, int bufferCount) {
    unsigned int totalCount = orig_objc_getClassList(buffer, bufferCount);
    if(!isCallerTweak() && totalCount > 0 && buffer && bufferCount > 0) {
        unsigned int writeIdx = 0;
        for(unsigned int i = 0; i < totalCount && i < (unsigned int)bufferCount; i++) {
            if(buffer[i]) {
                const char* className = class_getName(buffer[i]);
                if(className) {
                    NSString* cn = @(className);
                    if([cn containsString:@"Substrate"]
                    || [cn containsString:@"Cephei"]
                    || [cn containsString:@"TweakInject"]
                    || [cn containsString:@"Andromeda"]
                    || [cn hasPrefix:@"_TtC"]
                    || [cn containsString:@"Hook"]
                    || [cn containsString:@"Inject"]) {
                        continue;
                    }
                }
                buffer[writeIdx++] = buffer[i];
            }
        }
        return writeIdx;
    }
    return totalCount;
}

void andromeda_hook_ObjCRuntime(void) {
    MSHookFunction((void*)objc_copyImageNames, (void*)hooked_objc_copyImageNames, (void**)&orig_objc_copyImageNames);
    MSHookFunction((void*)class_getImageName, (void*)hooked_class_getImageName, (void**)&orig_class_getImageName);
}

void andromeda_hook_TweakClasses(void) {
    MSHookFunction((void*)objc_getClassList, (void*)hooked_objc_getClassList, (void**)&orig_objc_getClassList);
}
