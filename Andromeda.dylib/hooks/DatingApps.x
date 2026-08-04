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

%end

%group andromeda_badoo

%hook BDODeviceInfo
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRooted { return NO; }
- (BOOL)isCompromised { return NO; }
- (BOOL)isDeviceSafe { return YES; }
%end

%hook BDOSecurity
- (BOOL)checkDeviceSecurity { return YES; }
- (BOOL)isSafeEnvironment { return YES; }
- (BOOL)isJailbroken { return NO; }
%end

%hook BDOIntegrityCheck
- (BOOL)isValid { return YES; }
- (BOOL)checkIntegrity { return YES; }
%end

%end

%group andromeda_fruitz

%hook FRZSecurityCheck
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook FRZIntegrityValidator
- (BOOL)validate { return YES; }
- (BOOL)checkIntegrity { return YES; }
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

void andromeda_hook_DatingApps(void) {
    NSString* bid = [[AndromedaCore sharedInstance] bundleIdentifier];
    DLog(@"Setting up dating app hooks for: %@", bid);

    if([bid isEqualToString:@"com.cardify.tinder"] || [bid isEqualToString:@"com.tinder.tinder"]) {
        %init(andromeda_tinder);
    }
    else if([bid isEqualToString:@"com.bumble.bumble"] || [bid isEqualToString:@"com.bumblecorp.bumble"]) {
        %init(andromeda_bumble);
    }
    else if([bid isEqualToString:@"com.hily.app"] || [bid isEqualToString:@"com.hily.corp"]) {
        %init(andromeda_hily);
    }
    else if([bid isEqualToString:@"com.badoo.iphone"] || [bid isEqualToString:@"com.badoo.enterprise"]) {
        %init(andromeda_badoo);
    }
    else if([bid isEqualToString:@"com.fruitz.app"] || [bid isEqualToString:@"com.getfruitz.Fruitz"]) {
        %init(andromeda_fruitz);
    }
    else if([bid isEqualToString:@"com.feels.frn"] || [bid isEqualToString:@"com.feels.app"]) {
        %init(andromeda_feels);
    }
    else if([bid isEqualToString:@"com.hinge.co"] || [bid isEqualToString:@"com.hinge.Hinge"]) {
        %init(andromeda_hinge);
    }
    else if([bid isEqualToString:@"com.grindrguy.grindrx"] || [bid isEqualToString:@"com.grindr.inc"]) {
        %init(andromeda_grindr);
    }
    else if([bid isEqualToString:@"com.happn.ios"] || [bid isEqualToString:@"com.ftw_and_co.happn"]) {
        %init(andromeda_happn);
    }
    else if([bid isEqualToString:@"com.okcupid.OKCupid"] || [bid isEqualToString:@"com.okcupid.app"]) {
        %init(andromeda_okcupid);
    }
    else if([bid isEqualToString:@"com.meetic.iphone"] || [bid isEqualToString:@"com.meetic.Meetic"]) {
        %init(andromeda_meetic);
    }
}
