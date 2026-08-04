#import "hooks.h"

static CFTypeRef (*orig_MGCopyAnswer)(CFStringRef) = NULL;

static CFTypeRef hooked_MGCopyAnswer(CFStringRef question) {
    CFTypeRef result = orig_MGCopyAnswer(question);

    if(!isCallerTweak() && question) {
        NSString* q = (__bridge NSString*)question;

        if([q isEqualToString:@"ProductType"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedProductType];
        }

        if([q isEqualToString:@"hw.model"]
        || [q isEqualToString:@"HWModelStr"]
        || [q isEqualToString:@"hw.machine"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedDeviceModel];
        }

        if([q isEqualToString:@"UniqueDeviceID"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedUDID];
        }

        if([q isEqualToString:@"UniqueChipID"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedECID];
        }

        if([q isEqualToString:@"SerialNumber"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedSerialNumber];
        }

        if([q isEqualToString:@"MLBSerialNumber"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedMLBSerial];
        }

        if([q isEqualToString:@"DeviceName"]) {
            if(result) CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedDeviceName];
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
