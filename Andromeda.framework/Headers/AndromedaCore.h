#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AndromedaCore : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSString* bundleIdentifier;
@property (nonatomic, readonly) NSString* executablePath;
@property (nonatomic, readonly) BOOL isSystemApp;
@property (nonatomic, readonly) BOOL isDatingApp;
@property (nonatomic, readonly) BOOL isSocialApp;
@property (nonatomic, readonly) BOOL isProtectedApp;
@property (nonatomic, readonly) NSDictionary* preferences;
@property (nonatomic, readonly) NSDictionary* rawPreferences;
@property (nonatomic, readonly) NSDictionary* effectivePreferences;
@property (nonatomic, readonly) NSArray* appSpecificBypasses;

- (void)loadPreferences;
- (NSDictionary*)perAppConfigurationForBundleId:(NSString*)bundleId;
- (BOOL)isPathRestricted:(NSString*)path;
- (BOOL)isPathJailbreakRelated:(NSString*)path;
- (BOOL)isAddrExternal:(const void*)addr;
- (BOOL)shouldDisableTweakForApp:(NSString*)bundleId;
- (BOOL)isDatingAppBundleId:(NSString*)bundleId;
- (BOOL)isSocialAppBundleId:(NSString*)bundleId;

@end

NS_ASSUME_NONNULL_END
