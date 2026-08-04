#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceFingerprintSpoofer : NSObject

+ (instancetype)sharedInstance;

- (NSString*)spoofedDeviceModel;
- (NSString*)spoofedDeviceIdentifier;
- (NSString*)spoofedSerialNumber;
- (NSString*)spoofedUDID;
- (NSString*)spoofedWiFiMAC;
- (NSString*)spoofedBluetoothMAC;
- (NSNumber*)spoofedBatteryLevel;
- (NSString*)spoofedScreenResolution;
- (NSString*)spoofedOSVersion;
- (NSString*)spoofedBuildVersion;
- (NSDictionary*)spoofedDeviceInfo;
- (NSUUID*)spoofedAdvertisingUUID;

@property (nonatomic, readonly) NSDictionary* currentSpoofProfile;
@property (nonatomic, readonly) BOOL isSpoofingEnabled;

@end

NS_ASSUME_NONNULL_END
