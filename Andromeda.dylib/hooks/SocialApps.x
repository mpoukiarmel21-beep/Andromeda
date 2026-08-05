#import "hooks.h"

%group andromeda_instagram

%hook IGAnalyticsSession
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGDeviceChecker
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeveloperModeEnabled {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook IGSecurityManager
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGIntegrityCheck
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkAppIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkDeviceIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBAnalytics
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBDeviceInformation
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBAppIntegrity
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isCodeSigned {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook RCTDeviceInfo
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGDirectSecurity
- (BOOL)isDeviceTrusted {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook IGUserSession
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGRuntimeSecurity
- (BOOL)isSubstrateLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSubstituteLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasInjectedDynamicLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
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
- (BOOL)isDeviceIntact {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasValidSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTamperDetected {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBBuildEnvironment
- (BOOL)isAppStoreBuild {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDebuggerAttached {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isInternalBuild {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IGSecurityController
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRootDetectionEnabled {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)shouldBlockAction {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_threads

%hook THAppSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook THDeviceIntegrity
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerPresent {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook THSecurityCheck
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BHInstagramAppIntegrity
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook THRuntimeSecurity
- (BOOL)isSubstrateLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSubstituteLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasInjectedDynamicLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook THDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%hook THIntegrityValidator
- (BOOL)validateAppIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateDeviceIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTampering {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_facebook

%hook FBSecurityManager
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBDeviceCheck
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBDeviceIntegrity
- (BOOL)isDeviceIntact {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasValidSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTamperDetected {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBBuildEnvironment
- (BOOL)isAppStoreBuild {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDebuggerAttached {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isInternalBuild {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FBAppIntegrity
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%end

%group andromeda_snapchat

%hook SCSecurityManager
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook SCDeviceCheck
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook SCIntegrityValidator
- (BOOL)validateDeviceIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateAppIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperDetection {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook SCRuntimeSecurity
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSubstrateLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasInjectedLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook SCDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
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
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TTDeviceCheck
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TTIntegrityValidator
- (BOOL)validateDeviceIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateAppIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperDetection {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TTRuntimeSecurity
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSubstrateLoaded {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasInjectedLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerDetected {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TTDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO,
        @"is_compromised": @NO
    };
}
%end

%hook TTSecurityController
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)shouldBlockAction {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

static BOOL andromeda_socialInitDone = NO;

void andromeda_hook_SocialApps(void) {
    NSString* bid = [[AndromedaCore sharedInstance] bundleIdentifier];
    DLog(@"Setting up social app hooks for: %@", bid);

    if(andromeda_socialInitDone) return;

    // Adapted LittleMac for social apps = hooking the app's own detection classes.
    // Enabled by the built-in Hook_SocialApps switch or the per-app LittleMac switch.
    // CodingJesus = device fingerprint spoofing (applied by reinjectNow via the spoof hooks).
    BOOL classHooks = andromeda_hookEnabledForKey(@"Hook_SocialApps") || andromeda_appTweakEnabled(bid, @"Tweak_LittleMac");

    if(classHooks) {
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
    andromeda_socialInitDone = YES;
}
