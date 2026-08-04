#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetectionSignatures : NSObject

+ (NSArray<NSString*>*)jailbreakPaths_fs;
+ (NSArray<NSString*>*)jailbreakPaths_containing;
+ (NSArray<NSString*>*)jailbreakPaths_prefix;
+ (NSArray<NSString*>*)jailbreakPaths_suffix;
+ (NSArray<NSString*>*)jailbreakSymlinks;
+ (NSArray<NSString*>*)jailbreakApps;
+ (NSArray<NSString*>*)jailbreakFilesToHide;
+ (NSArray<NSString*>*)suspiciousDylibNames;
+ (NSArray<NSString*>*)bannedURLSchemes;
+ (NSArray<NSString*>*)knownDetectionClasses;
+ (NSArray<NSString*>*)knownDetectionSelectors;
+ (NSDictionary<NSString*, NSArray<NSString*>*>*)appSpecificDetectionClasses;
+ (NSArray<NSString*>*)suspiciousEnvVars;
+ (NSArray<NSString*>*)suspiciousProcFiles;
+ (NSArray<NSString*>*)suspiciousProcessNames;
+ (NSArray<NSString*>*)suspiciousDyldSymbols;
+ (NSDictionary<NSString*, NSArray<NSString*>*>*)datingAppBundleIds;
+ (NSDictionary<NSString*, NSArray<NSString*>*>*)socialAppBundleIds;
+ (NSDictionary<NSString*, NSDictionary*>*)appSpecificConfigurations;

@end

NS_ASSUME_NONNULL_END
