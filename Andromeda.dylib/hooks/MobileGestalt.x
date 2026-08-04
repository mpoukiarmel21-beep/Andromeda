#import "hooks.h"

static CFTypeRef (*orig_MGCopyAnswer)(CFStringRef) = NULL;
static CFTypeRef (*orig_MGCopyMultipleAnswers)(CFArrayRef, CFDictionaryRef*) = NULL;

static CFTypeRef hooked_MGCopyAnswer(CFStringRef question) {
    CFTypeRef result = orig_MGCopyAnswer(question);

    if(!isCallerTweak() && question) {
        NSString* q = (__bridge NSString*)question;

        if([q isEqualToString:@"ProductType"]
        || [q isEqualToString:@"hw.model"]
        || [q isEqualToString:@"HWModelStr"]
        || [q isEqualToString:@"hw.machine"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedDeviceModel];
        }

        if([q isEqualToString:@"UniqueDeviceID"]
        || [q isEqualToString:@"UniqueChipID"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedUDID];
        }

        if([q isEqualToString:@"SerialNumber"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedSerialNumber];
        }

        if([q isEqualToString:@"ProductVersion"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedOSVersion];
        }

        if([q isEqualToString:@"BuildVersion"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedBuildVersion];
        }

        if([q isEqualToString:@"WifiAddress"]
        || [q isEqualToString:@"BluetoothAddress"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedWiFiMAC];
        }

        if([q isEqualToString:@"DeviceSupportsAppAttest"]
        || [q isEqualToString:@"DeviceSupportsDCAppAttest"]) {
            return kCFBooleanFalse;
        }
    }

    return result;
}

static CFTypeRef hooked_MGCopyMultipleAnswers(CFArrayRef questions, CFDictionaryRef* answers) {
    return orig_MGCopyMultipleAnswers(questions, answers);
}

void andromeda_hook_MobileGestalt(void) {
    @try {
        const char* paths[] = {
            "/usr/lib/libMobileGestalt.dylib",
            "/var/jb/usr/lib/libMobileGestalt.dylib",
            NULL
        };
        for(int i = 0; paths[i]; i++) {
            void* lib = dlopen(paths[i], RTLD_LAZY);
            if(lib) {
                void* mc = dlsym(lib, "MGCopyAnswer");
                if(mc) {
                    MSHookFunction(mc, (void*)hooked_MGCopyAnswer, (void**)&orig_MGCopyAnswer);
                }
                break;
            }
        }
    } @catch(NSException *e) {}
}
