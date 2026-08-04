#import "Headers/DeviceFingerprintSpoofer.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <dlfcn.h>
#import "../common.h"

static NSArray* _andromedaDeviceProfiles(void) {
    static NSArray* s_profiles = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString* path = @"/var/jb/Library/Andromeda/deviceProfiles.json";
        NSData* data = [NSData dataWithContentsOfFile:path];
        if(data) {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if([obj isKindOfClass:[NSArray class]] && [obj count] > 0) {
                s_profiles = obj;
            }
        }
        if(!s_profiles) {
            s_profiles = @[
                @{ @"model": @"iPhone14,2", @"productType": @"iPhone14,2", @"osVersion": @"18.4.1", @"buildVersion": @"22E240", @"resolution": @"1170x2532" },
                @{ @"model": @"iPhone14,3", @"productType": @"iPhone14,3", @"osVersion": @"18.4.1", @"buildVersion": @"22E240", @"resolution": @"1284x2778" },
                @{ @"model": @"iPhone15,2", @"productType": @"iPhone15,2", @"osVersion": @"18.5", @"buildVersion": @"22F76", @"resolution": @"1290x2796" },
                @{ @"model": @"iPhone15,3", @"productType": @"iPhone15,3", @"osVersion": @"18.5", @"buildVersion": @"22F76", @"resolution": @"1290x2796" },
                @{ @"model": @"iPhone16,1", @"productType": @"iPhone16,1", @"osVersion": @"18.3.1", @"buildVersion": @"22D63", @"resolution": @"1179x2556" }
            ];
        }
    });
    return s_profiles;
}

@implementation DeviceFingerprintSpoofer {
    NSDictionary* _spoofProfile;
    NSMutableDictionary* _overrides;
}

+ (instancetype)sharedInstance {
    static DeviceFingerprintSpoofer* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[DeviceFingerprintSpoofer alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
        _overrides = [NSMutableDictionary dictionary];
        [self loadOrGenerateSpoofProfile];
    }
    return self;
}

- (void)loadOrGenerateSpoofProfile {
    @try {
        NSDictionary* saved = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
        NSDictionary* profile = saved[@"Internal_DeviceProfile"];
        if([profile isKindOfClass:[NSDictionary class]] && [profile count] > 0) {
            _spoofProfile = profile;
            DLog(@"using persisted spoof profile (stable fingerprint)");
            return;
        }

        [self generateSpoofProfile];

        NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
        if(!prefs) prefs = [NSMutableDictionary dictionary];
        prefs[@"Internal_DeviceProfile"] = _spoofProfile;
        [prefs writeToFile:@ANDROMEDA_PREFS atomically:YES];
        DLog(@"generated + persisted spoof profile");
    } @catch(NSException *e) {
        [self generateSpoofProfile];
    }
}

- (void)generateSpoofProfile {
    NSArray* profiles = _andromedaDeviceProfiles();
    uint32_t idx = arc4random_uniform((uint32_t)profiles.count);
    NSDictionary* base = profiles[idx];

    NSUUID* advId = [NSUUID UUID];

    _spoofProfile = @{
        @"model": base[@"model"] ?: @"iPhone15,2",
        @"resolution": base[@"resolution"] ?: @"1290x2796",
        @"osVersion": base[@"osVersion"] ?: @"18.5",
        @"buildVersion": base[@"buildVersion"] ?: @"22F76",
        @"advertisingUUID": [advId UUIDString],
        @"batteryLevel": @(arc4random_uniform(80) + 20),
        @"name": @"iPhone"
    };
}

- (void)reloadFromPreferences:(NSDictionary*)prefs {
    @try {
        if(![prefs isKindOfClass:[NSDictionary class]]) return;

        [_overrides removeAllObjects];
        NSDictionary* keys = @{
            @"Spoof_Model": @"model",
            @"Spoof_ProductType": @"productType",
            @"Spoof_MachineName": @"machineName",
            @"Spoof_SerialNumber": @"serialNumber",
            @"Spoof_UDID": @"udid",
            @"Spoof_ECID": @"ecid",
            @"Spoof_MLBSerial": @"mlbSerial",
            @"Spoof_OSVersion": @"osVersion",
            @"Spoof_BuildVersion": @"buildVersion",
            @"Spoof_DeviceName": @"name",
            @"Spoof_WiFiMAC": @"wifiMAC",
            @"Spoof_BluetoothMAC": @"bluetoothMAC"
        };

        BOOL hasCustom = NO;
        for(NSString* prefKey in keys) {
            id val = prefs[prefKey];
            if(val && [val isKindOfClass:[NSString class]] && [(NSString*)val length] > 0) {
                _overrides[keys[prefKey]] = val;
                hasCustom = YES;
            }
        }

        if(hasCustom) {
            NSMutableDictionary* merged = [NSMutableDictionary dictionaryWithDictionary:_spoofProfile];
            for(NSString* k in _overrides) {
                merged[k] = _overrides[k];
            }
            _spoofProfile = merged;
        }
    } @catch(NSException *e) {}
}

- (NSString*)spoofedDeviceModel {
    return _overrides[@"model"] ?: _spoofProfile[@"model"];
}

- (NSString*)spoofedDeviceIdentifier {
    return _overrides[@"model"] ?: _spoofProfile[@"model"];
}

- (NSString*)spoofedProductType {
    return _overrides[@"productType"] ?: (_spoofProfile[@"productType"] ?: [self spoofedDeviceModel]);
}

- (NSString*)spoofedMachineName {
    return _overrides[@"machineName"] ?: (_spoofProfile[@"machineName"] ?: [self spoofedDeviceModel]);
}

- (NSString*)spoofedSerialNumber {
    if(_overrides[@"serialNumber"]) return _overrides[@"serialNumber"];
    NSMutableString* serial = [NSMutableString stringWithCapacity:12];
    NSString* chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for(int i = 0; i < 12; i++) {
        [serial appendFormat:@"%C", [chars characterAtIndex:arc4random_uniform((uint32_t)chars.length)]];
    }
    return serial;
}

- (NSString*)spoofedUDID {
    if(_overrides[@"udid"]) return _overrides[@"udid"];
    NSMutableString* udid = [NSMutableString stringWithCapacity:40];
    NSString* hex = @"0123456789ABCDEF";
    for(int i = 0; i < 40; i++) {
        [udid appendFormat:@"%C", [hex characterAtIndex:arc4random_uniform(16)]];
    }
    return udid;
}

- (NSString*)spoofedECID {
    if(_overrides[@"ecid"]) return _overrides[@"ecid"];
    NSMutableString* ecid = [NSMutableString stringWithCapacity:16];
    NSString* hex = @"0123456789ABCDEF";
    for(int i = 0; i < 16; i++) {
        [ecid appendFormat:@"%C", [hex characterAtIndex:arc4random_uniform(16)]];
    }
    return ecid;
}

- (NSString*)spoofedMLBSerial {
    if(_overrides[@"mlbSerial"]) return _overrides[@"mlbSerial"];
    NSMutableString* mlb = [NSMutableString stringWithCapacity:15];
    [mlb appendString:@"F2LQ"];
    NSString* chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for(int i = 0; i < 11; i++) {
        [mlb appendFormat:@"%C", [chars characterAtIndex:arc4random_uniform((uint32_t)chars.length)]];
    }
    return mlb;
}

- (NSString*)spoofedWiFiMAC {
    if(_overrides[@"wifiMAC"]) return _overrides[@"wifiMAC"];
    return [self _randomMAC];
}

- (NSString*)spoofedBluetoothMAC {
    if(_overrides[@"bluetoothMAC"]) return _overrides[@"bluetoothMAC"];
    return [self _randomMAC];
}

- (NSString*)_randomMAC {
    NSMutableString* mac = [NSMutableString stringWithCapacity:17];
    NSString* hex = @"0123456789ABCDEF";
    for(int i = 0; i < 6; i++) {
        if(i > 0) [mac appendString:@":"];
        [mac appendFormat:@"%C%C", [hex characterAtIndex:arc4random_uniform(16)], [hex characterAtIndex:arc4random_uniform(16)]];
    }
    return mac;
}

- (NSNumber*)spoofedBatteryLevel {
    return _spoofProfile[@"batteryLevel"];
}

- (NSString*)spoofedScreenResolution {
    return _spoofProfile[@"resolution"];
}

- (NSString*)spoofedOSVersion {
    return _overrides[@"osVersion"] ?: _spoofProfile[@"osVersion"];
}

- (NSString*)spoofedBuildVersion {
    return _overrides[@"buildVersion"] ?: _spoofProfile[@"buildVersion"];
}

- (NSString*)spoofedDeviceName {
    return _overrides[@"name"] ?: _spoofProfile[@"name"];
}

- (NSDictionary*)spoofedDeviceInfo {
    return _spoofProfile;
}

- (NSUUID*)spoofedAdvertisingUUID {
    return [[NSUUID alloc] initWithUUIDString:_spoofProfile[@"advertisingUUID"]];
}

- (NSDictionary*)currentSpoofProfile {
    return _spoofProfile;
}

- (BOOL)isSpoofingEnabled {
    return YES;
}

@end
