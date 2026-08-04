#import "hooks.h"

%hook DCAppAttestService

- (BOOL)isSupported {
    return NO;
}

+ (DCAppAttestService*)sharedService {
    return nil;
}

- (void)generateKeyWithCompletionHandler:(void (^)(NSString* keyId, NSError* error))completionHandler {
    if(completionHandler) {
        NSError* error = [NSError errorWithDomain:@"DCErrorDomain" code:1 userInfo:@{NSLocalizedDescriptionKey: @"App Attest not supported"}];
        completionHandler(nil, error);
    }
}

- (void)attestKey:(NSString*)keyId clientDataHash:(NSData*)clientDataHash completionHandler:(void (^)(NSData* attestationObject, NSError* error))completionHandler {
    if(completionHandler) {
        NSError* error = [NSError errorWithDomain:@"DCErrorDomain" code:2 userInfo:@{NSLocalizedDescriptionKey: @"Attestation failed"}];
        completionHandler(nil, error);
    }
}

- (void)generateAssertion:(NSString*)keyId clientDataHash:(NSData*)clientDataHash completionHandler:(void (^)(NSData* assertionObject, NSError* error))completionHandler {
    if(completionHandler) {
        NSError* error = [NSError errorWithDomain:@"DCErrorDomain" code:3 userInfo:@{NSLocalizedDescriptionKey: @"Assertion failed"}];
        completionHandler(nil, error);
    }
}

%end

%hook LAContext

- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError**)error {
    if(policy == LAPolicyDeviceOwnerAuthentication) {
        if(error) *error = [NSError errorWithDomain:@"LAErrorDomain" code:-6 userInfo:nil];
        return NO;
    }
    return %orig;
}

%end

%ctor {
    %init;
}

static void* (*orig_SecTaskCopyValueForEntitlement)(void*, void*, void*, void*) = NULL;

static void* hooked_SecTaskCopyValueForEntitlement(void* task, void* entitlement, void* authType, void* error) {
    CFStringRef entStr = (CFStringRef)entitlement;
    if(entStr && CFGetTypeID(entStr) == CFStringGetTypeID()) {
        NSString* ent = (__bridge NSString*)entStr;
        if([ent containsString:@"get-task-allow"]
        || [ent containsString:@"task_for_pid-allow"]
        || [ent containsString:@"dynamic-codesigning"]
        || [ent containsString:@"platform-application"]) {
            return NULL;
        }
    }
    return orig_SecTaskCopyValueForEntitlement(task, entitlement, authType, error);
}

void andromeda_hook_AppAttest(void) {
    void* secHandle = dlopen("/System/Library/Frameworks/Security.framework/Security", RTLD_NOW);
    if(secHandle) {
        void* func = dlsym(secHandle, "SecTaskCopyValueForEntitlement");
        if(func) {
            MSHookFunction(func, (void*)hooked_SecTaskCopyValueForEntitlement, (void**)&orig_SecTaskCopyValueForEntitlement);
        }
    }
}
