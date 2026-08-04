#import "hooks.h"

%group andromeda_instagram

%hook IGAnalyticsSession
- (BOOL)isJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook IGDeviceChecker
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isDeveloperModeEnabled { return NO; }
- (BOOL)isDeviceSafe { return YES; }
%end

%hook IGSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook IGIntegrityCheck
- (BOOL)isValid { return YES; }
- (BOOL)checkAppIntegrity { return YES; }
- (BOOL)checkDeviceIntegrity { return YES; }
- (BOOL)isTampered { return NO; }
%end

%hook FBAnalytics
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook FBDeviceInformation
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isRooted { return NO; }
- (BOOL)isTampered { return NO; }
%end

%hook FBAppIntegrity
- (BOOL)isValid { return YES; }
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isCodeSigned { return YES; }
%end

%hook RCTDeviceInfo
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook IGDirectSecurity
- (BOOL)isDeviceTrusted { return YES; }
- (BOOL)isDeviceSafe { return YES; }
%end

%hook IGUserSession
- (BOOL)isSuspended { return NO; }
- (BOOL)isBanned { return NO; }
- (BOOL)isBlocked { return NO; }
%end

%hook IGRuntimeSecurity
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)isSubstituteLoaded { return NO; }
- (BOOL)hasInjectedDynamicLibraries { return NO; }
- (BOOL)isRuntimePatched { return NO; }
%end

%hook IGDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"screen_resolution": [_spoofer spoofedScreenResolution],
        @"device_type": @"iPhone",
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%hook FBDeviceIntegrity
- (BOOL)isDeviceIntact { return YES; }
- (BOOL)hasValidSignature { return YES; }
- (BOOL)isTamperDetected { return NO; }
%end

%hook FBBuildEnvironment
- (BOOL)isAppStoreBuild { return YES; }
- (BOOL)isDebuggerAttached { return NO; }
- (BOOL)isInternalBuild { return NO; }
%end

%hook IGSecurityController
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isRootDetectionEnabled { return NO; }
- (BOOL)shouldBlockAction { return NO; }
%end

%end

%group andromeda_threads

%hook THAppSecurityManager
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isRooted { return NO; }
%end

%hook THDeviceIntegrity
- (BOOL)checkIntegrity { return YES; }
- (BOOL)isValid { return YES; }
- (BOOL)isTampered { return NO; }
- (BOOL)isDebuggerPresent { return NO; }
%end

%hook THSecurityCheck
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook BHInstagramAppIntegrity
- (BOOL)isValid { return YES; }
- (BOOL)checkIntegrity { return YES; }
%end

%hook THRuntimeSecurity
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)isSubstituteLoaded { return NO; }
- (BOOL)hasInjectedDynamicLibraries { return NO; }
%end

%hook THDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%hook THIntegrityValidator
- (BOOL)validateAppIntegrity { return YES; }
- (BOOL)validateDeviceIntegrity { return YES; }
- (BOOL)hasTampering { return NO; }
%end

%end

%group andromeda_facebook

%hook FBSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook FBDeviceCheck
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook FBDeviceIntegrity
- (BOOL)isDeviceIntact { return YES; }
- (BOOL)hasValidSignature { return YES; }
- (BOOL)isTamperDetected { return NO; }
%end

%hook FBBuildEnvironment
- (BOOL)isAppStoreBuild { return YES; }
- (BOOL)isDebuggerAttached { return NO; }
- (BOOL)isInternalBuild { return NO; }
%end

%hook FBAppIntegrity
- (BOOL)isValid { return YES; }
- (BOOL)checkIntegrity { return YES; }
%end

%end

%group andromeda_snapchat

%hook SCSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook SCDeviceCheck
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook SCIntegrityValidator
- (BOOL)validateDeviceIntegrity { return YES; }
- (BOOL)validateAppIntegrity { return YES; }
- (BOOL)hasTamperDetection { return NO; }
%end

%hook SCRuntimeSecurity
- (BOOL)isHooked { return NO; }
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)hasInjectedLibraries { return NO; }
%end

%hook SCDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%end

%group andromeda_tiktok

%hook TTSecurityManager
- (BOOL)isDeviceSafe { return YES; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)isCompromised { return NO; }
%end

%hook TTDeviceCheck
- (BOOL)isDeviceJailbroken { return NO; }
- (BOOL)isDeviceCompromised { return NO; }
%end

%hook TTIntegrityValidator
- (BOOL)validateDeviceIntegrity { return YES; }
- (BOOL)validateAppIntegrity { return YES; }
- (BOOL)hasTamperDetection { return NO; }
%end

%hook TTRuntimeSecurity
- (BOOL)isHooked { return NO; }
- (BOOL)isSubstrateLoaded { return NO; }
- (BOOL)hasInjectedLibraries { return NO; }
- (BOOL)isDebuggerDetected { return NO; }
%end

%hook TTDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%hook TTSecurityController
- (BOOL)isDeviceCompromised { return NO; }
- (BOOL)isJailbroken { return NO; }
- (BOOL)shouldBlockAction { return NO; }
%end

%end

void andromeda_hook_SocialApps(void) {
    NSString* bid = [[AndromedaCore sharedInstance] bundleIdentifier];
    DLog(@"Setting up social app hooks for: %@", bid);

    if([bid isEqualToString:@"com.burbn.instagram"]) {
        %init(andromeda_instagram);
    }
    else if([bid isEqualToString:@"com.instagram.barcelona"]) {
        %init(andromeda_threads);
    }
    else if([bid isEqualToString:@"com.facebook.Facebook"]) {
        %init(andromeda_facebook);
    }
    else if([bid isEqualToString:@"com.snapchat.Snapchat"]) {
        %init(andromeda_snapchat);
    }
    else if([bid isEqualToString:@"com.zhiliaoapp.musically"]) {
        %init(andromeda_tiktok);
    }
}
