#import "Headers/DeviceFingerprintSpoofer.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <dlfcn.h>

@implementation DeviceFingerprintSpoofer {
    NSDictionary* _spoofProfile;
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
        [self generateSpoofProfile];
    }
    return self;
}

- (void)generateSpoofProfile {
    NSArray* models = @[@"iPhone14,2", @"iPhone14,3", @"iPhone14,5", @"iPhone15,2", @"iPhone15,3"];
    NSArray* res = @[@"1170x2532", @"1284x2778", @"1290x2796", @"1179x2556"];
    NSArray* versions = @[@"18.3.1", @"18.4", @"18.4.1", @"18.5"];
    NSArray* builds = @[@"22D63", @"22E240", @"22E245", @"22F76"];
    
    uint32_t idx = arc4random_uniform((uint32_t)models.count);
    
    NSUUID* advId = [NSUUID UUID];
    
    _spoofProfile = @{
        @"model": models[idx],
        @"resolution": res[arc4random_uniform((uint32_t)res.count)],
        @"osVersion": versions[arc4random_uniform((uint32_t)versions.count)],
        @"buildVersion": builds[arc4random_uniform((uint32_t)builds.count)],
        @"advertisingUUID": [advId UUIDString],
        @"batteryLevel": @(arc4random_uniform(80) + 20),
        @"name": [NSString stringWithFormat:@"iPhone (%@)", models[idx]]
    };
}

- (NSString*)spoofedDeviceModel {
    return _spoofProfile[@"model"];
}

- (NSString*)spoofedDeviceIdentifier {
    return _spoofProfile[@"model"];
}

- (NSString*)spoofedSerialNumber {
    NSMutableString* serial = [NSMutableString stringWithCapacity:12];
    NSString* chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for(int i = 0; i < 12; i++) {
        [serial appendFormat:@"%C", [chars characterAtIndex:arc4random_uniform((uint32_t)chars.length)]];
    }
    return serial;
}

- (NSString*)spoofedUDID {
    NSMutableString* udid = [NSMutableString stringWithCapacity:40];
    NSString* hex = @"0123456789ABCDEF";
    for(int i = 0; i < 40; i++) {
        [udid appendFormat:@"%C", [hex characterAtIndex:arc4random_uniform(16)]];
    }
    return udid;
}

- (NSString*)spoofedWiFiMAC {
    NSMutableString* mac = [NSMutableString stringWithCapacity:17];
    NSString* hex = @"0123456789ABCDEF";
    for(int i = 0; i < 6; i++) {
        if(i > 0) [mac appendString:@":"];
        [mac appendFormat:@"%C%C", [hex characterAtIndex:arc4random_uniform(16)], [hex characterAtIndex:arc4random_uniform(16)]];
    }
    return mac;
}

- (NSString*)spoofedBluetoothMAC {
    return [self spoofedWiFiMAC];
}

- (NSNumber*)spoofedBatteryLevel {
    return _spoofProfile[@"batteryLevel"];
}

- (NSString*)spoofedScreenResolution {
    return _spoofProfile[@"resolution"];
}

- (NSString*)spoofedOSVersion {
    return _spoofProfile[@"osVersion"];
}

- (NSString*)spoofedBuildVersion {
    return _spoofProfile[@"buildVersion"];
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
