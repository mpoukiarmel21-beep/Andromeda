#import "hooks.h"

static int (*orig_uname)(struct utsname*) = NULL;
static int (*orig_gethostuuid)(uuid_t, const struct timespec*) = NULL;

static int hooked_uname(struct utsname* name) {
    int result = orig_uname(name);
    if(result == 0 && name) {
        NSString* spoofedVersion = [_spoofer spoofedOSVersion];
        NSString* spoofedModel = [_spoofer spoofedDeviceModel];
        snprintf(name->release, sizeof(name->release), "%s", [spoofedVersion UTF8String]);
        snprintf(name->version, sizeof(name->version), "Darwin Kernel Version 23.0.0");
        snprintf(name->machine, sizeof(name->machine), "%s", [spoofedModel UTF8String]);
    }
    return result;
}

static int hooked_gethostuuid(uuid_t uuid, const struct timespec* timeout) {
    int result = orig_gethostuuid(uuid, timeout);
    if(result == 0) {
        NSUUID* spoofed = [_spoofer spoofedAdvertisingUUID];
        [spoofed getUUIDBytes:uuid];
    }
    return result;
}

%hook UIScreen

- (CGRect)bounds {
    return %orig;
}

- (CGRect)nativeBounds {
    return %orig;
}

- (CGFloat)nativeScale {
    return %orig;
}

- (CGFloat)scale {
    return %orig;
}

%end

%hook UIDevice

- (NSString*)model {
    NSString* spoofed = [_spoofer spoofedDeviceModel];
    return spoofed ?: %orig;
}

- (NSString*)uniqueIdentifier {
    return [_spoofer spoofedUDID];
}

- (NSUUID*)identifierForVendor {
    return [_spoofer spoofedAdvertisingUUID];
}

- (NSString*)systemVersion {
    NSString* spoofed = [_spoofer spoofedOSVersion];
    return spoofed ?: %orig;
}

- (NSString*)systemName {
    return @"iOS";
}

- (NSString*)name {
    return @"iPhone";
}

- (float)batteryLevel {
    return [[_spoofer spoofedBatteryLevel] floatValue] / 100.0f;
}

- (UIDeviceBatteryState)batteryState {
    return UIDeviceBatteryStateUnplugged;
}

- (BOOL)isProximityMonitoringEnabled {
    return NO;
}

%end

%hook CTCellularData
- (CTCellularDataRestrictedState)restrictedState {
    return kCTCellularDataRestrictedStateUnknown;
}
%end

%ctor {
    %init;
}

void andromeda_hook_HardwareFingerprint(void) {
    MSHookFunction((void*)uname, (void*)hooked_uname, (void**)&orig_uname);
    MSHookFunction((void*)gethostuuid, (void*)hooked_gethostuuid, (void**)&orig_gethostuuid);
}
