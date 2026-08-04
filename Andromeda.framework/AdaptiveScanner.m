#import "Headers/AdaptiveScanner.h"
#import "Headers/DetectionSignatures.h"
#import "../common.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <substrate.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>

static NSArray<NSString *>* kSuspiciousSelectorPatterns = nil;
static NSArray<NSString *>* kSuspiciousClassPatterns = nil;
static NSMutableSet<NSString *>* hookedSelectors = nil;
static NSMutableArray<NSDictionary *>* scanResults = nil;

@interface AdaptiveScanner ()
@property (nonatomic, assign) BOOL scanning;
@property (nonatomic, strong) NSArray<NSString *> *lastSelectors;
@property (nonatomic, strong) NSArray<NSString *> *lastClasses;
@end

@implementation AdaptiveScanner

+ (void)load {
    kSuspiciousSelectorPatterns = @[
        @"jailbreak", @"jailbroken", @"jailBreak",
        @"isRoot", @"isRooted", @"rooted",
        @"isCompromised", @"compromised",
        @"isTampered", @"tampered", @"tamper",
        @"isHooked", @"hooked",
        @"isDebug", @"debugged", @"debugger",
        @"isEmulator", @"emulator",
        @"isSimulator", @"simulator",
        @"checkIntegrity", @"integrity",
        @"securityCheck", @"security",
        @"deviceCheck", @"deviceIntegrity",
        @"appIntegrity", @"runtimeIntegrity",
        @"antiDebug", @"antiTamper",
        @"detectInjection", @"injection",
        @"detectFrida", @"frida",
        @"detectCycript", @"cycript",
        @"substrate", @"substitute", @"tweak",
        @"cydia", @"sileo", @"zebra",
        @"sandbox", @"restricted",
        @"fileExists.*cydia", @"fileExists.*sileo",
        @"pathFor.*jb", @"check.*file",
        @"hasJailbreakFiles", @"suspiciousFile",
        @"dyld.*inject", @"load.*dylib"
    ];

    kSuspiciousClassPatterns = @[
        @"Security", @"Integrity", @"Jailbreak",
        @"Root", @"Tamper", @"Debug", @"Hook",
        @"DeviceCheck", @"Fingerprint",
        @"Anti", @"Protect", @"Shield",
        @"Guard", @"Trust", @"Verify",
        @"Check", @"Detect", @"Monitor",
        @"Runtime.*Security", @"App.*Integrity"
    ];

    hookedSelectors = [NSMutableSet set];
    scanResults = [NSMutableArray array];
}

+ (instancetype)sharedInstance {
    static AdaptiveScanner *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[AdaptiveScanner alloc] init];
    });
    return instance;
}

- (BOOL)isScanning {
    return self.scanning;
}

- (NSArray<NSString *> *)lastDetectedSelectors {
    return self.lastSelectors ?: @[];
}

- (NSArray<NSString *> *)lastDetectedClasses {
    return self.lastClasses ?: @[];
}

#pragma mark - Selector Pattern Matching

- (BOOL)selectorMatchesSuspiciousPattern:(const char *)selName {
    if (!selName) return NO;
    NSString *selStr = @(selName);
    NSString *selLower = [selStr lowercaseString];

    for (NSString *pattern in kSuspiciousSelectorPatterns) {
        NSString *patLower = [pattern lowercaseString];

        if ([patLower containsString:@"*"]) {
            NSArray *parts = [patLower componentsSeparatedByString:@"*"];
            BOOL match = YES;
            NSUInteger searchFrom = 0;
            for (NSString *part in parts) {
                if (part.length == 0) continue;
                NSRange range = [selLower rangeOfString:part options:0 range:NSMakeRange(searchFrom, selLower.length - searchFrom)];
                if (range.location == NSNotFound) {
                    match = NO;
                    break;
                }
                searchFrom = range.location + range.length;
            }
            if (match) return YES;
        } else {
            if ([selLower containsString:patLower]) return YES;
        }
    }

    return NO;
}

- (BOOL)classMatchesSuspiciousPattern:(const char *)className {
    if (!className) return NO;
    NSString *classStr = @(className);

    for (NSString *pattern in kSuspiciousClassPatterns) {
        if ([classStr rangeOfString:pattern options:NSCaseInsensitiveSearch].location != NSNotFound) {
            return YES;
        }
    }

    for (NSString *known in [DetectionSignatures knownDetectionClasses]) {
        if ([classStr isEqualToString:known]) return YES;
    }

    return NO;
}

#pragma mark - Generic Hook Implementations

static BOOL hooked_bool_return_NO(id self, SEL _cmd) {
    return NO;
}

static BOOL hooked_bool_return_YES(id self, SEL _cmd) {
    return YES;
}

static int hooked_int_return_0(id self, SEL _cmd) {
    return 0;
}

static id hooked_id_return_nil(id self, SEL _cmd) {
    return nil;
}

#pragma mark - Runtime Enumeration & Hooking

- (void)scanAndHookTargetAppWithCompletion:(AdaptiveScanCompletion)completion {
    if (self.scanning) {
        if (completion) completion(@[], @[]);
        return;
    }

    self.scanning = YES;
    [hookedSelectors removeAllObjects];
    [scanResults removeAllObjects];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<NSString *> *detectedSelectors = [NSMutableArray array];
        NSMutableArray<NSString *> *detectedClasses = [NSMutableArray array];

        unsigned int classCount = 0;
        Class *classes = objc_copyClassList(&classCount);

        for (unsigned int i = 0; i < classCount; i++) {
            Class cls = classes[i];
            const char *className = class_getName(cls);
            if (!className) continue;

            BOOL classSuspicious = [self classMatchesSuspiciousPattern:className];

            unsigned int methodCount = 0;
            Method *methods = class_copyMethodList(cls, &methodCount);

            for (unsigned int j = 0; j < methodCount; j++) {
                SEL sel = method_getName(methods[j]);
                const char *selName = sel_getName(sel);
                if (!selName) continue;

                BOOL selSuspicious = [self selectorMatchesSuspiciousPattern:selName];

                if (selSuspicious || classSuspicious) {
                    NSString *key = [NSString stringWithFormat:@"%@.%s", @(className), selName];
                    if ([hookedSelectors containsObject:key]) continue;

                    Method method = methods[j];
                    const char *typeEncoding = method_getTypeEncoding(method);

                    if (!typeEncoding) continue;

                    NSString *retType = [self returnTypeFromEncoding:typeEncoding];

                    IMP newImp = NULL;
                    if ([retType isEqualToString:@"B"]) {
                        if ([self shouldReturnYESForSelector:selName]) {
                            newImp = (IMP)hooked_bool_return_YES;
                        } else {
                            newImp = (IMP)hooked_bool_return_NO;
                        }
                    } else if ([retType isEqualToString:@"i"] || [retType isEqualToString:@"q"] || [retType isEqualToString:@"l"]) {
                        newImp = (IMP)hooked_int_return_0;
                    } else if ([retType isEqualToString:@"@"]) {
                        newImp = (IMP)hooked_id_return_nil;
                    }

                    if (newImp) {
                        method_setImplementation(method, newImp);
                        [hookedSelectors addObject:key];
                        [detectedSelectors addObject:key];

                        NSDictionary *result = @{
                            @"class": @(className),
                            @"selector": @(selName),
                            @"returnType": retType,
                            @"hooked": @YES
                        };
                        [scanResults addObject:result];
                    }
                }
            }

            free(methods);

            if (classSuspicious) {
                [detectedClasses addObject:@(className)];
            }
        }

        free(classes);

        self.scanning = NO;
        self.lastSelectors = [detectedSelectors copy];
        self.lastClasses = [detectedClasses copy];

        NSLog(@"[Andromeda Adaptive] Scan complete: %lu selectors hooked in %lu classes",
              (unsigned long)detectedSelectors.count,
              (unsigned long)detectedClasses.count);

        for (NSDictionary *r in scanResults) {
            NSLog(@"[Andromeda Adaptive]   -> %@.%@ (ret=%@)",
                  r[@"class"], r[@"selector"], r[@"returnType"]);
        }

        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(detectedSelectors, detectedClasses);
            });
        }
    });
}

#pragma mark - Helpers

- (NSString *)returnTypeFromEncoding:(const char *)encoding {
    if (!encoding) return @"?";
    NSMutableString *returnType = [NSMutableString string];
    BOOL inReturnType = YES;
    BOOL inStruct = NO;
    int parenDepth = 0;

    for (const char *p = encoding; *p; p++) {
        char c = *p;
        if (inReturnType) {
            if (c == '{') {
                inStruct = YES;
                parenDepth++;
                [returnType appendFormat:@"%c", c];
            } else if (c == '}') {
                parenDepth--;
                [returnType appendFormat:@"%c", c];
                if (parenDepth == 0) inStruct = NO;
            } else if (!inStruct) {
                [returnType appendFormat:@"%c", c];
                inReturnType = NO;
            } else {
                [returnType appendFormat:@"%c", c];
            }
        }
    }

    return returnType.length > 0 ? returnType : @"?";
}

- (BOOL)shouldReturnYESForSelector:(const char *)selName {
    if (!selName) return NO;
    NSString *sel = @(selName);
    NSArray *yesSelectors = @[
        @"checkIntegrity", @"isCodeSigned",
        @"isDeviceSecure", @"passesSecurityCheck"
    ];
    for (NSString *ys in yesSelectors) {
        if ([sel.lowercaseString containsString:ys.lowercaseString]) return YES;
    }
    return NO;
}

@end
