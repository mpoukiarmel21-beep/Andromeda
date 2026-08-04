#import "hooks.h"

static CFTypeRef (*orig_IORegistryEntryCreateCFProperty)(io_registry_entry_t, CFStringRef, CFAllocatorRef, IOOptionBits) = NULL;
static kern_return_t (*orig_IORegistryEntryCreateCFProperties)(io_registry_entry_t, CFMutableDictionaryRef*, CFAllocatorRef, IOOptionBits) = NULL;

static CFTypeRef hooked_IORegistryEntryCreateCFProperty(io_registry_entry_t entry, CFStringRef key, CFAllocatorRef allocator, IOOptionBits options) {
    CFTypeRef result = orig_IORegistryEntryCreateCFProperty(entry, key, allocator, options);

    if(!isCallerTweak() && result && key) {
        NSString* keyStr = (__bridge NSString*)key;

        if([keyStr isEqualToString:@"model"]
        || [keyStr isEqualToString:@"product-description"]
        || [keyStr isEqualToString:@"hw.model"]) {
            CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedDeviceModel];
        }

        if([keyStr isEqualToString:@"serial-number"]
        || [keyStr isEqualToString:@"IOPlatformSerialNumber"]) {
            CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedSerialNumber];
        }

        if([keyStr isEqualToString:@"unique-chip-id"]
        || [keyStr isEqualToString:@"device-id"]
        || [keyStr isEqualToString:@"IOPlatformUUID"]) {
            CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedUDID];
        }

        if([keyStr isEqualToString:@"WifiAddress"]
        || [keyStr isEqualToString:@"BluetoothAddress"]) {
            CFRelease(result);
            return (__bridge_retained CFTypeRef)[_spoofer spoofedWiFiMAC];
        }
    }

    return result;
}

static kern_return_t hooked_IORegistryEntryCreateCFProperties(io_registry_entry_t entry, CFMutableDictionaryRef* properties, CFAllocatorRef allocator, IOOptionBits options) {
    kern_return_t ret = orig_IORegistryEntryCreateCFProperties(entry, properties, allocator, options);
    if(!isCallerTweak() && ret == KERN_SUCCESS && properties && *properties) {
        CFDictionarySetValue(*properties, CFSTR("model"), (__bridge CFStringRef)[_spoofer spoofedDeviceModel]);
        CFDictionarySetValue(*properties, CFSTR("serial-number"), (__bridge CFStringRef)[_spoofer spoofedSerialNumber]);
        CFDictionarySetValue(*properties, CFSTR("unique-chip-id"), (__bridge CFStringRef)[_spoofer spoofedUDID]);
    }
    return ret;
}

void andromeda_hook_IOKit(void) {
    MSHookFunction((void*)IORegistryEntryCreateCFProperty, (void*)hooked_IORegistryEntryCreateCFProperty, (void**)&orig_IORegistryEntryCreateCFProperty);
    MSHookFunction((void*)IORegistryEntryCreateCFProperties, (void*)hooked_IORegistryEntryCreateCFProperties, (void**)&orig_IORegistryEntryCreateCFProperties);
}
