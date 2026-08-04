#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "AndromedaCore.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^AdaptiveScanCompletion)(NSArray<NSString *> *detectedSelectors, NSArray<NSString *> *detectedClasses);

@interface AdaptiveScanner : NSObject

+ (instancetype)sharedInstance;

- (void)scanAndHookTargetAppWithCompletion:(nullable AdaptiveScanCompletion)completion;
- (BOOL)isScanning;
- (NSArray<NSString *> *)lastDetectedSelectors;
- (NSArray<NSString *> *)lastDetectedClasses;

@end

NS_ASSUME_NONNULL_END