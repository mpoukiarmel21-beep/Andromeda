#import "hooks.h"

%group andromeda_tinder

%hook TNDRUser
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isShadowBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TNDRMetaManager
- (BOOL)hasBannedDevice {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceBlacklisted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TNDRSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperedBinaries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook TNDRDeviceIntegrity
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerPresent {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasValidSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook TNDRAppIntegrity
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSignatureValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkCodeSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateCodeSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook IOSSecuritySuite
- (BOOL)isDeviceFlagged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_bumble

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLDeviceChecker
- (BOOL)isDeviceBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbrokenDevice {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLIntegrityCheck
- (BOOL)checkIntegrity {
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

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_bumble_bff

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLDeviceChecker
- (BOOL)isDeviceBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbrokenDevice {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLIntegrityCheck
- (BOOL)checkIntegrity {
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

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_hily

%hook HLYSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isInsecureEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isAttestationValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook HLYDeviceIntegrity
- (BOOL)checkIntegrity {
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
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isEmulator {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)validateAppSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook HLYAppIntegrityCheck
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkCodeSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkBundleIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook HLYRuntimeSecurity
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
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook HLYFingerprintManager
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
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
- (BOOL)evaluateDevice {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isDeviceTrusted {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%end

%group andromeda_badoo

%hook BDODeviceInfo
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
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
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerPresent {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isEmulator {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isAppSignatureValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BDOSecurity
- (BOOL)checkDeviceSecurity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerPresent {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isAttestationValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkRuntimeIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasDetectedSuspicion {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isAppEnvironmentTrusted {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BDOIntegrityCheck
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkIntegrity {
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
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkCodeSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateAppSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BDORuntimeSecurity
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
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BDODeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
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
    if(!andromeda_appBypassActive()) return %orig;
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_fruitz

%hook FRZSecurityCheck
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
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDebuggerPresent {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isEmulator {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FRZIntegrityValidator
- (BOOL)validate {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)checkIntegrity {
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
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkCodeSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)validateAppSignature {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FRZRuntimeSecurity
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
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FRZDeviceFingerprint
- (NSDictionary*)deviceFingerprint {
    if(!andromeda_appBypassActive()) return %orig;
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
    if(!andromeda_appBypassActive()) return %orig;
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_feels

%hook FLSSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isInsecureEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook FLSIntegrityCheck
- (BOOL)checkIntegrity {
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
- (BOOL)hasSuspiciousLibraries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook FLSDeviceFingerprint
- (NSDictionary*)fingerprint {
    if(!andromeda_appBypassActive()) return %orig;
    return @{
        @"model": [_spoofer spoofedDeviceModel],
        @"os_version": [_spoofer spoofedOSVersion],
        @"is_jailbroken": @NO
    };
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook FLSRuntimeSecurity
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
- (BOOL)isHooked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_hinge

%hook HNGDeviceCheck
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

%hook HNGSecurityIntegration
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_grindr

%hook GRDRSecurityManager
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

%end

%group andromeda_happn

%hook HPNDeviceSecurity
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbreakDetected {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%end

%group andromeda_okcupid

%hook OKCDeviceCheck
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_meetic

%hook MTCSecurityManager
- (BOOL)isDeviceSafe {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperedBinaries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLDeviceChecker
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLIntegrityCheck
- (BOOL)isValid {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)isTampered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkIntegrity {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id *)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString *)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray *)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_match

%hook MatchSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperedBinaries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)checkForJailbreak {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceModified {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook BMBLSecurityManager
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
%end

%hook BMBLAccountManager
- (BOOL)isBlocked {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSuspended {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isBanned {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_pof

%hook POFSecurityManager
- (BOOL)isDeviceCompromised {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isDeviceRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRooted {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isSafeEnvironment {
    if(!andromeda_appBypassActive()) return %orig;
    return YES;
}
- (BOOL)hasTamperedBinaries {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
- (BOOL)isRuntimePatched {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%hook IOSSecuritySuite
+ (BOOL)amIJailbroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIReverseEngineered {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIProxied {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIManipulated {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)amIJailbrokenWithFailMessage:(id*)msg {
    if(!andromeda_appBypassActive()) return %orig;
    if(msg) *msg = @"";
    return NO;
}
+ (NSString*)deviceIdiomString {
    if(!andromeda_appBypassActive()) return %orig;
    return @"iPhone";
}
+ (NSArray*)amIAttachedToDebugger {
    if(!andromeda_appBypassActive()) return %orig;
    return @[];
}
%end

%hook flutter_jailbreak_detection
+ (BOOL)isJailBroken {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
+ (BOOL)isDebugged {
    if(!andromeda_appBypassActive()) return %orig;
    return NO;
}
%end

%end

%group andromeda_eharmony
%end

%group andromeda_zoosk
%end

%group andromeda_lex
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

static BOOL andromeda_datingInitDone = NO;

static NSString* andromeda_resolveTinderMode(void) {
    // Legacy Tinder_Bypass_Mode selector; kept only as fallback for the
    // per-app Tweak_LittleMac / Tweak_CodingJesus switches.
    NSString* legacy = andromeda_prefs()[@"Tinder_Bypass_Mode"];
    if([legacy isKindOfClass:[NSString class]] && legacy.length) return legacy;
    return @"default";
}

static BOOL andromeda_tweakSwitch(NSString* bid, NSString* key) {
    // Per-app switch, with the legacy global Tinder selector as fallback.
    if(andromeda_appTweakEnabled(bid, key)) return YES;
    if([bid isEqualToString:@"com.cardify.tinder"]) {
        NSString* legacy = andromeda_resolveTinderMode();
        if([key isEqualToString:@"Tweak_LittleMac"]) return [legacy isEqualToString:@"littlemac"];
        if([key isEqualToString:@"Tweak_CodingJesus"]) return [legacy isEqualToString:@"codingjesus"];
    }
    return NO;
}

void andromeda_hook_DatingApps(void) {
    NSString* bid = [[AndromedaCore sharedInstance] bundleIdentifier];
    DLog(@"Setting up dating app hooks for: %@", bid);

    if([bid isEqualToString:@"com.cardify.tinder"]) {
        // CodingJesus adapted for Tinder = the original external spoofer.
        // LittleMac adapted for Tinder = the original external bypass.
        if(andromeda_tweakSwitch(bid, @"Tweak_CodingJesus")) {
            DLog(@"[Andromeda] Tinder: CodingJesus ON -> loading Tinder Advanced Spoofer");
            andromeda_applyExternalBypass(bid, @"codingjesus");
        }
        if(andromeda_tweakSwitch(bid, @"Tweak_LittleMac")) {
            DLog(@"[Andromeda] Tinder: LittleMac ON -> loading LittleMac Tinder Bypass");
            andromeda_applyExternalBypass(bid, @"littlemac");
        }
        if(andromeda_datingInitDone) return;
        // Built-in detection-class hooks only when neither external tweak is active.
        if(!andromeda_tweakSwitch(bid, @"Tweak_CodingJesus") && !andromeda_tweakSwitch(bid, @"Tweak_LittleMac")) {
            %init(andromeda_tinder);
        }
        andromeda_datingInitDone = YES;
        return;
    }

    if(andromeda_datingInitDone) return;

    // Adapted LittleMac for every other dating app = hooking the app's own
    // jailbreak-detection classes (same technique, ported to that app).
    // Active whenever this app is protected and any bypass tool is on.
    BOOL classHooks = andromeda_appBypassActive();

    if(classHooks) {
        if([bid isEqualToString:@"com.bumble.app"]) {
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
        else if([bid isEqualToString:@"com.meetic.iphone"]) {
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
    andromeda_datingInitDone = YES;
}
