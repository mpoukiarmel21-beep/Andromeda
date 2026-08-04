#import "hooks.h"

// ============================================================================
// ANDROMEDA URL SCHEME BYPASS — Hook canOpenURL + LSApplicationWorkspace
// Cache les apps jailbreak de la liste des apps installées
// ============================================================================

// ============================================================================
// UIApplication canOpenURL — Bloquer les schemes jailbreak
// ============================================================================

static BOOL (*orig_UI_canOpenURL)(id, SEL, NSURL*) = NULL;

static BOOL hooked_UI_canOpenURL(id self, SEL _cmd, NSURL* url) {
    if(!isCallerTweak() && url) {
        NSString* scheme = [[url scheme] lowercaseString];
        if(!scheme) return orig_UI_canOpenURL(self, _cmd, url);

        // Jailbreak URL schemes
        if([scheme isEqualToString:@"cydia"]
        || [scheme isEqualToString:@"sileo"]
        || [scheme isEqualToString:@"zbra"]
        || [scheme isEqualToString:@"apt"]
        || [scheme isEqualToString:@"filza"]
        || [scheme isEqualToString:@"icleaner"]
        || [scheme isEqualToString:@"undecimus"]
        || [scheme isEqualToString:@"newterm"]
        || [scheme isEqualToString:@"mterminal"]
        || [scheme isEqualToString:@"activator"]
        || [scheme isEqualToString:@"ssh"]
        || [scheme isEqualToString:@"santander"]
        || [scheme isEqualToString:@"openssh"]
        || [scheme isEqualToString:@"cydia+package"]
        || [scheme isEqualToString:@"sileo+package"]
        || [scheme isEqualToString:@"zbra+package"]
        || [scheme isEqualToString:@"com+sileo"]
        || [scheme isEqualToString:@"com+cydia"]) {
            return NO;
        }
    }
    return orig_UI_canOpenURL(self, _cmd, url);
}

// ============================================================================
// LSApplicationWorkspace — Filtrer les apps installées
// ============================================================================

%hook LSApplicationWorkspace

- (NSArray*)allInstalledApplications {
    NSArray* result = %orig;
    if(isCallerTweak() || !result) return result;

    NSMutableArray* filtered = [result mutableCopy];
    for(id app in filtered) {
        NSString* bundleID = nil;
        if([app respondsToSelector:@selector(applicationIdentifier)]) {
            bundleID = [app performSelector:@selector(applicationIdentifier)];
        }
        if(!bundleID) continue;

        NSString* lower = [bundleID lowercaseString];
        if([lower containsString:@"cydia"]
        || [lower containsString:@"sileo"]
        || [lower containsString:@"zebra"]
        || [lower containsString:@"filza"]
        || [lower containsString:@"terminal"]
        || [lower containsString:@"ssh"]
        || [lower containsString:@"dropbear"]
        || [lower containsString:@"activator"]
        || [lower containsString:@"flipswitch"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"substrate"]
        || [lower containsString:@"ellekit"]
        || [lower containsString:@"libhooker"]
        || [lower containsString:@"preferenceloader"]
        || [lower containsString:@"rocketbootstrap"]
        || [lower containsString:@"applist"]
        || [lower containsString:@"cephei"]
        || [lower containsString:@"frida"]
        || [lower containsString:@"cycript"]
        || [lower containsString:@"sslkillswitch"]) {
            [filtered removeObject:app];
        }
    }
    return [filtered copy];
}

- (NSArray*)applicationsAvailableForHandlingURLScheme:(NSString*)urlScheme {
    NSArray* result = %orig;
    if(isCallerTweak() || !result) return result;

    NSString* lower = [urlScheme lowercaseString];
    if([lower containsString:@"cydia"]
    || [lower containsString:@"sileo"]
    || [lower containsString:@"zbra"]
    || [lower containsString:@"filza"]
    || [lower containsString:@"ssh"]
    || [lower containsString:@"activator"]) {
        return @[];
    }
    return result;
}

- (NSArray*)applicationsAvailableForOpeningURL:(NSURL*)url {
    NSArray* result = %orig;
    if(isCallerTweak() || !result) return result;

    NSString* scheme = [[url scheme] lowercaseString];
    if([scheme isEqualToString:@"cydia"]
    || [scheme isEqualToString:@"sileo"]
    || [scheme isEqualToString:@"zbra"]
    || [scheme isEqualToString:@"filza"]
    || [scheme isEqualToString:@"ssh"]
    || [scheme isEqualToString:@"activator"]) {
        return @[];
    }
    return result;
}

%end

// ============================================================================
// NSBundle — Masquer les bundles jailbreak
// ============================================================================

%hook NSBundle

+ (NSBundle*)bundleWithIdentifier:(NSString*)identifier {
    NSBundle* result = %orig;
    if(isCallerTweak() || !result) return result;

    NSString* lower = [identifier lowercaseString];
    if([lower containsString:@"cydia"]
    || [lower containsString:@"sileo"]
    || [lower containsString:@"zebra"]
    || [lower containsString:@"substrate"]
    || [lower containsString:@"substitute"]
    || [lower containsString:@"ellekit"]
    || [lower containsString:@"libhooker"]
    || [lower containsString:@"preferenceloader"]
    || [lower containsString:@"rocketbootstrap"]
    || [lower containsString:@"applist"]
    || [lower containsString:@"cephei"]
    || [lower containsString:@"frida"]
    || [lower containsString:@"cycript"]) {
        return nil;
    }
    return result;
}

- (id)objectForInfoDictionaryKey:(NSString*)key {
    if(isCallerTweak()) return %orig;

    // Masquer SignerIdentity pour les bundles jailbreak
    if([key isEqualToString:@"SignerIdentity"]) {
        NSString* bundlePath = [self bundlePath];
        if(bundlePath && [_andromeda isPathRestricted:bundlePath]) {
            return nil;
        }
    }
    return %orig;
}

%end

// ============================================================================
// NSProcessInfo — Masquer informations système suspectes
// ============================================================================

%hook NSProcessInfo

- (NSUInteger)processorCount {
    if(isCallerTweak()) return %orig;
    NSUInteger real = %orig;
    return MIN(real, 8);
}

- (NSUInteger)activeProcessorCount {
    if(isCallerTweak()) return %orig;
    NSUInteger real = %orig;
    return MIN(real, 8);
}

- (unsigned long long)physicalMemory {
    if(isCallerTweak()) return %orig;
    unsigned long long real = %orig;
    // Certains jailbreaks rapportent une mémoire réduite
    return real < 1024ULL * 1024 * 1024 ? 4ULL * 1024 * 1024 * 1024 : real;
}

- (NSString*)machineHardwareName {
    if(isCallerTweak()) return %orig;
    // Retourner un modèle standard
    return @"iPhone14,5";
}

%end

// ============================================================================
// UIScreen — Détecter enregistrement d'écran
// ============================================================================

%hook UIScreen

- (BOOL)isCaptured {
    if(isCallerTweak()) return %orig;
    return NO;
}

- (BOOL)_isCaptured {
    if(isCallerTweak()) return %orig;
    return NO;
}

%end

// ============================================================================
// Installation
// ============================================================================

void andromeda_hook_URLScheme(void) {
    NSLog(@"[Andromeda] URLSchemeBypass: Installing URL scheme + workspace bypass...");

    // canOpenURL hook (ObjC runtime)
    Class uiApp = objc_getClass("UIApplication");
    if(uiApp) {
        SEL sel = @selector(canOpenURL:);
        Method m = class_getClassMethod(uiApp, sel);
        if(m) {
            orig_UI_canOpenURL = (BOOL(*)(id,SEL,NSURL*))method_getImplementation(m);
            method_setImplementation(m, (IMP)hooked_UI_canOpenURL);
            NSLog(@"[Andromeda] URLSchemeBypass: UIApplication canOpenURL: hooked");
        }
    }

    NSLog(@"[Andromeda] URLSchemeBypass: Installation complete");
}
