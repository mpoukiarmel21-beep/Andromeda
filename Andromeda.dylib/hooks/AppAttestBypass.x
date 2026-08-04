#import "hooks.h"

// DCAppAttestService
typedef BOOL (*isSupported_t)(id, SEL);
static isSupported_t orig_isSupported = NULL;

static BOOL hooked_isSupported(id self, SEL _cmd) {
    if(isCallerTweak()) return orig_isSupported(self, _cmd);
    return NO;
}

// DCDevice
typedef BOOL (*supportsDeviceCheck_t)(id, SEL);
static supportsDeviceCheck_t orig_supportsDeviceCheck = NULL;

static BOOL hooked_supportsDeviceCheck(id self, SEL _cmd) {
    if(isCallerTweak()) return orig_supportsDeviceCheck(self, _cmd);
    return NO;
}

void andromeda_hook_AppAttestBypass_install(void) {
    NSLog(@"[Andromeda] AppAttestBypass: Installing...");

    Class cls;

    cls = NSClassFromString(@"DCAppAttestService");
    if(cls) {
        Method m = class_getClassMethod(cls, @selector(isSupported));
        if(m) {
            orig_isSupported = (isSupported_t)method_getImplementation(m);
            method_setImplementation(m, (IMP)hooked_isSupported);
            NSLog(@"[Andromeda] AppAttestBypass: DCAppAttestService.isSupported hooked");
        }
    }

    cls = NSClassFromString(@"DCDevice");
    if(cls) {
        Method m = class_getClassMethod(cls, @selector(currentDeviceSupportsDeviceCheck));
        if(m) {
            orig_supportsDeviceCheck = (supportsDeviceCheck_t)method_getImplementation(m);
            method_setImplementation(m, (IMP)hooked_supportsDeviceCheck);
            NSLog(@"[Andromeda] AppAttestBypass: DCDevice hooked");
        }
    }

    NSLog(@"[Andromeda] AppAttestBypass: Done");
}
