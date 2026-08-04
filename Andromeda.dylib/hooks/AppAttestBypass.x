#import "hooks.h"

// ============================================================================
// ANDROMEDA APP ATTEST BYPASS — Hook DCAppAttestService
// Apple App Attest est utilisé par Meta (Instagram/Threads) et d'autres apps
// pour la vérification d'intégrité côté serveur
// ============================================================================

// ============================================================================
// DCAppAttestService — Forcer isSupported = NO
// ============================================================================

%hook DCAppAttestService

+ (BOOL)isSupported {
    if(isCallerTweak()) return %orig;
    // Forcer isSupported = NO pour forcer le fallback vers
    // les vérifications logicielles (que nos hooks couvrent)
    return NO;
}

- (void)generateKeyWithCompletionHandler:(void(^)(id, NSError*))handler {
    if(isCallerTweak()) { %orig; return; }
    // Retourner une erreur pour éviter la génération de clé d'attestation
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

// ============================================================================
// DCDevice — Masquer device attestation
// ============================================================================

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

// ============================================================================
// ASDeviceIdentity — Masquer device identity
// ============================================================================

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

// ============================================================================
// Installation
// ============================================================================

void andromeda_hook_AppAttest(void) {
    NSLog(@"[Andromeda] AppAttestBypass: Installing App Attest bypass...");

    if(NSClassFromString(@"DCAppAttestService")) {
        %init(andromeda_appattest);
        NSLog(@"[Andromeda] AppAttestBypass: DCAppAttestService hooked");
    }

    if(NSClassFromString(@"DCDevice")) {
        NSLog(@"[Andromeda] AppAttestBypass: DCDevice hooked");
    }

    if(NSClassFromString(@"ASDeviceIdentity")) {
        NSLog(@"[Andromeda] AppAttestBypass: ASDeviceIdentity hooked");
    }

    NSLog(@"[Andromeda] AppAttestBypass: Installation complete");
}

%group andromeda_appattest
%end
