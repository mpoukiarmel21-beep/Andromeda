#import "hooks.h"

%group andromeda_appattest

%hook DCAppAttestService

+ (BOOL)isSupported {
    if(isCallerTweak()) return %orig;
    return NO;
}

- (void)generateKeyWithCompletionHandler:(void(^)(id, NSError*))handler {
    if(isCallerTweak()) { %orig; return; }
    if(handler) {
        NSError* error = [NSError errorWithDomain:@"com.andromeda"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"App Attest not supported"}];
        handler(nil, error);
    }
}

- (void)attestKey:(NSString*)clientDataHash completionHandler:(void(^)(NSData*, NSError*))handler {
    if(isCallerTweak()) { %orig; return; }
    if(handler) {
        NSError* error = [NSError errorWithDomain:@"com.andromeda"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"App Attest not supported"}];
        handler(nil, error);
    }
}

%end

%hook DCDevice

+ (BOOL)currentDeviceSupportsDeviceCheck {
    if(isCallerTweak()) return %orig;
    return NO;
}

- (void)generateTokenWithCompletionHandler:(void(^)(NSData*, NSError*))handler {
    if(isCallerTweak()) { %orig; return; }
    if(handler) {
        NSError* error = [NSError errorWithDomain:@"com.andromeda"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"Device check not supported"}];
        handler(nil, error);
    }
}

%end

%hook ASDeviceIdentity

+ (void)deviceIdentityWithCompletion:(void(^)(id, NSError*))completion {
    if(isCallerTweak()) { %orig; return; }
    if(completion) {
        NSError* error = [NSError errorWithDomain:@"com.andromeda"
                                             code:-1
                                         userInfo:@{NSLocalizedDescriptionKey: @"Device identity not available"}];
        completion(nil, error);
    }
}

%end

%end

void andromeda_hook_AppAttest(void) {
    NSLog(@"[Andromeda] AppAttestBypass: Installing...");

    if(NSClassFromString(@"DCAppAttestService") || NSClassFromString(@"DCDevice") || NSClassFromString(@"ASDeviceIdentity")) {
        %init(andromeda_appattest);
    }
}
