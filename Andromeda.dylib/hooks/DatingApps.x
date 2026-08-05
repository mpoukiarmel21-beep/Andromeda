#import "hooks.h"

%group andromeda_tinder

%hook TNDRUser
- (BOOL)isBanned { return NO; }
- (BOOL)isShadowBanned { return NO; }
- (BOOL)isSuspended { return NO; }
- (BOOL)isBlocked { return NO; }
%end

%hook TNDRDeletionDetector
- (BOOL)isDeviceBanned { return NO; }
- (BOOL)isDeviceFlagged { return NO; }
%end

%hook TNDRMetaManager
- (BOOL)hasBannedDevice { return NO; }
- (BOOL)isDeviceBlacklisted { return NO; }
%end

%hook TNDRSecurityManager
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isSafeEnvironment { return YES; }
%end

%hook TNDRDeviceIntegrity
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
%end

%hook TNDRAppIntegrity
- (BOOL)isValid { return YES; }
- (BOOL)checkCodeSignature { return YES; }
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken { return NO; }
+ (BOOL)isDebugged { return NO; }
%end

%end

%group andromeda_bumble

%hook BMBLAccountManager
- (BOOL)isBlocked { return NO; }
- (BOOL)isSuspended { return NO; }
- (BOOL)isBanned { return NO; }
%end

%hook BMBLDeviceChecker
- (BOOL)isDeviceBanned { return NO; }
- (BOOL)isJailbrokenDevice { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook BMBLSecurityManager
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isDeviceRooted { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isSafeEnvironment { return YES; }
%end

%hook BMBLIntegrityCheck
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%end

%group andromeda_hily

%hook HLYSecurityManager
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isInsecureEnvironment { return NO; }
- (BOOL)isAttestationValid { return YES; }
- (BOOL)isDeviceSafe { return YES; }
%end

%hook HLYDeviceIntegrity
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
- (BOOL)isEmulator { return NO; }
- (BOOL)validateAppSignature { return YES; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook HLYAppIntegrityCheck
- (BOOL)isValid { return YES; }
- (BOOL)checkCodeSignature { return YES; }
- (BOOL)checkBundleIntegrity { return YES; }
%end

%hook HLYRuntimeSecurity
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)isSubstituteLoaded { return NO; }
- (BOOL)hasInjectedDynamicLibraries { return NO; }
- (BOOL)isRuntimePatched { return NO; }
- (BOOL)isHooked { return NO; }
%end

%hook HLYFingerprintManager
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"screen_resolution": [_spoofer spoofedScreenResolution],
        @"device_type": @"iPhone",
        @"is_jailbroken": @NO,
        @"is_compromised": @NO,
        @"is_rooted": @NO
    };
}
%end

%hook HLYTrustEvaluator
- (BOOL)evaluateDevice { return YES; }
- (BOOL)isDeviceTrusted { return YES; }
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%end

%group andromeda_badoo

%hook BDODeviceInfo
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isCompromised { return NO; }
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
- (BOOL)isEmulator { return NO; }
- (BOOL)isRuntimePatched { return NO; }
- (BOOL)isAppSignatureValid { return YES; }
%end

%hook BDOSecurity
- (BOOL)checkDeviceSecurity { return YES; }
- (BOOL)isSafeEnvironment { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isDeviceRooted { return NO; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)isAttestationValid { return YES; }
- (BOOL)checkRuntimeIntegrity { return YES; }
- (BOOL)hasDetectedSuspicion { return NO; }
- (BOOL)isAppEnvironmentTrusted { return YES; }
%end

%hook BDOIntegrityCheck
- (BOOL)isValid { return YES; }
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
- (BOOL)checkCodeSignature { return YES; }
- (BOOL)validateAppSignature { return YES; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook BDORuntimeSecurity
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)isSubstituteLoaded { return NO; }
- (BOOL)hasInjectedDynamicLibraries { return NO; }
- (BOOL)isHooked { return NO; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook BDODeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"screen_resolution": [_spoofer spoofedScreenResolution],
        @"device_type": @"iPhone",
        @"is_jailbroken": @NO,
        @"is_compromised": @NO,
        @"is_rooted": @NO
    };
}
- (NSDictionary*)fingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%end

%group andromeda_fruitz

%hook FRZSecurityCheck
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
- (BOOL)isEmulator { return NO; }
%end

%hook FRZIntegrityValidator
- (BOOL)validate { return YES; }
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
- (BOOL)checkCodeSignature { return YES; }
- (BOOL)validateAppSignature { return YES; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook FRZRuntimeSecurity
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)isSubstituteLoaded { return NO; }
- (BOOL)hasInjectedDynamicLibraries { return NO; }
- (BOOL)isHooked { return NO; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook FRZDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"screen_resolution": [_spoofer spoofedScreenResolution],
        @"device_type": @"iPhone",
        @"is_jailbroken": @NO,
        @"is_compromised": @NO,
        @"is_rooted": @NO
    };
}
- (NSDictionary*)fingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%end

%group andromeda_feels

%hook FLSSecurityManager
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isInsecureEnvironment { return NO; }
- (BOOL)isDeviceSafe { return YES; }
%end

%hook FLSIntegrityCheck
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
- (BOOL)hasSuspiciousLibraries { return NO; }
%end

%hook FLSDeviceFingerprint
- (NSDictionary*)fingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken { return NO; }
+ (BOOL)amIReverseEngineered { return NO; }
+ (BOOL)amIDebugged { return NO; }
+ (BOOL)amIProxied { return NO; }
+ (BOOL)amIManipulated { return NO; }
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString { return @"iPhone"; }
+ (NSArray*)amIAttachedToDebugger { return @[]; }
%end

%end

%group andromeda_hinge

%hook HNGDeviceCheck
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook HNGSecurityIntegration
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
%end

%end

%group andromeda_grindr

%hook GRDRSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%end

%group andromeda_happn

%hook HPNDeviceSecurity
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbreakDetected { return NO; }
- (BOOL)isDeviceSafe { return YES; }
%end

%end

%group andromeda_okcupid

%hook OKCDeviceCheck
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
%end

%end

%group andromeda_meetic

%hook MTCSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
%end

%end

%group andromeda_match
%end

%group andromeda_pof
%end

%group andromeda_eharmony
%end

%group andromeda_zoosk
%end

%group andromeda_lex
%end

%group andromeda_bumble_bff
%end

%group andromeda_once
%end

%group andromeda_theleague
%end

%group andromeda_clover
%end

%group andromeda_hud
%end

%group andromeda_turnup
%end

%group andromeda_boo
%end

%group andromeda_iris
%end

%group andromeda_lovoo
%end

%group andromeda_adopte
%end

%group andromeda_jaumo
%end

%group andromeda_tantan
%end

static void andromeda_loadTinderTweak(NSString* name) {
    if(!name.length) return;
    NSString* path = [NSString stringWithFormat:@"/var/jb/Library/Andromeda/Tweaks/%@.dylib", name];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        dlopen(path.UTF8String, RTLD_NOW);
        const char* err = dlerror();
        NSLog(@"[Andromeda] External Tinder tweak '%@' %@", name, err ? [NSString stringWithUTF8String:err] : @"loaded successfully");
    } else {
        NSLog(@"[Andromeda] External Tinder tweak '%@' NOT FOUND at %@", name, path);
    }
}

void andromeda_hook_DatingApps(void) {
    NSString* bid = [[AndromedaCore sharedInstance] bundleIdentifier];
    DLog(@"Setting up dating app hooks for: %@", bid);

    if([bid isEqualToString:@"com.cardify.tinder"]) {
        NSString* tinderMode = andromeda_prefs()[@"Tinder_Bypass_Mode"];
        if([tinderMode isEqualToString:@"codingjesus"]) {
            DLog(@"[Andromeda] Tinder: using Tinder Advanced Spoofer (codingjesus)");
            andromeda_loadTinderTweak(@"TinderAdvancedSpoofer");
        } else if([tinderMode isEqualToString:@"littlemac"]) {
            DLog(@"[Andromeda] Tinder: using LittleMac Tinder Bypass");
            andromeda_loadTinderTweak(@"bhook");
            andromeda_loadTinderTweak(@"jbbypass");
        } else {
            %init(andromeda_tinder);
        }
    }
    else if([bid isEqualToString:@"com.bumble.app"]) {
        %init(andromeda_bumble);
    }
    else if([bid isEqualToString:@"co.hily.app"]) {
        %init(andromeda_hily);
    }
    else if([bid isEqualToString:@"com.badoo.badoo"]) {
        %init(andromeda_badoo);
    }
    else if([bid isEqualToString:@"com.ftw-and-co.fruitz"]) {
        %init(andromeda_fruitz);
    }
    else if([bid isEqualToString:@"com.feels.Feels"]) {
        %init(andromeda_feels);
    }
    else if([bid isEqualToString:@"co.hinge.app"]) {
        %init(andromeda_hinge);
    }
    else if([bid isEqualToString:@"com.grindrapp.ios"]) {
        %init(andromeda_grindr);
    }
    else if([bid isEqualToString:@"com.happn.happn"]) {
        %init(andromeda_happn);
    }
    else if([bid isEqualToString:@"com.okcupid.okcupid"]) {
        %init(andromeda_okcupid);
    }
    else if([bid isEqualToString:@"com.meetic.meetic"]) {
        %init(andromeda_meetic);
    }
    else if([bid isEqualToString:@"com.match.Match"]) {
        %init(andromeda_match);
    }
    else if([bid isEqualToString:@"com.pof.pof"]) {
        %init(andromeda_pof);
    }
    else if([bid isEqualToString:@"com.eharmony.eharmony"]) {
        %init(andromeda_eharmony);
    }
    else if([bid isEqualToString:@"com.zoosk.zoosk"]) {
        %init(andromeda_zoosk);
    }
    else if([bid isEqualToString:@"com.lex.lex"]) {
        %init(andromeda_lex);
    }
    else if([bid isEqualToString:@"com.bumble.bff"]) {
        %init(andromeda_bumble_bff);
    }
    else if([bid isEqualToString:@"com.once.once"]) {
        %init(andromeda_once);
    }
    else if([bid isEqualToString:@"com.theleague.ios"]) {
        %init(andromeda_theleague);
    }
    else if([bid isEqualToString:@"com.clover.ios"]) {
        %init(andromeda_clover);
    }
    else if([bid isEqualToString:@"com.hud.ios"]) {
        %init(andromeda_hud);
    }
    else if([bid isEqualToString:@"com.turnup.app"]) {
        %init(andromeda_turnup);
    }
    else if([bid isEqualToString:@"com.boo.app"]) {
        %init(andromeda_boo);
    }
    else if([bid isEqualToString:@"com.iris.dating"]) {
        %init(andromeda_iris);
    }
    else if([bid isEqualToString:@"com.lovoo.ios"]) {
        %init(andromeda_lovoo);
    }
    else if([bid isEqualToString:@"com.adopteunmec.ios"]) {
        %init(andromeda_adopte);
    }
    else if([bid isEqualToString:@"com.jaumo.ios"]) {
        %init(andromeda_jaumo);
    }
    else if([bid isEqualToString:@"com.tantan.ios"]) {
        %init(andromeda_tantan);
    }
}
