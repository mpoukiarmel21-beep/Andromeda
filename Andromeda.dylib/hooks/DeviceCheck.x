#import "hooks.h"

%hook UIDevice
+ (BOOL)isJailbroken { return NO; }
- (BOOL)isJailBreak { return NO; }
- (BOOL)isJailBroken { return NO; }
- (BOOL)jailbroken { return NO; }
%end

%hook NSProcessInfo
- (NSDictionary*)environment {
    NSDictionary* env = %orig;
    if(!isCallerTweak() && env) {
        NSMutableDictionary* filtered = [env mutableCopy];
        for(NSString* key in [DetectionSignatures suspiciousEnvVars]) {
            [filtered removeObjectForKey:key];
        }
        return [filtered copy];
    }
    return env;
}

- (NSString*)globallyUniqueString {
    return [_spoofer spoofedUDID];
}
%end

%hook DTTJailbreakDetection
+ (BOOL)isJailbroken { return NO; }
%end

%hook IOSSecuritySuite
- (BOOL)amIJailbroken { return NO; }
- (BOOL)amIJailbrokenWithFailMessage:(id)arg { return NO; }
- (BOOL)amIJailbrokenWithFailedChecks:(id)arg { return NO; }
- (BOOL)amIRunInEmulator { return NO; }
- (BOOL)amIDebugged { return NO; }
- (BOOL)amIReverseEngineered { return NO; }
- (BOOL)amIProxied { return NO; }
+ (BOOL)amIJailbroken { return NO; }
%end

%hook JailbreakDetection
- (bool)jailbroken { return false; }
- (bool)isJailbroken { return false; }
%end

%hook DeviceCheck
- (BOOL)isJailbroken { return NO; }
+ (BOOL)isJailbroken { return NO; }
%end

%hook JailbreakDetectionVC
- (BOOL)isJailbroken { return NO; }
%end

%hook AppsFlyerUtils
+ (BOOL)isJailBreakon { return NO; }
+ (bool)isJailbrokenWithSkipAdvancedJailbreakValidation:(bool)a { return false; }
%end

%hook jailBreak
+ (bool)isJailBreak { return false; }
%end

%hook GBDeviceInfo
- (BOOL)isJailbroken { return NO; }
%end

%hook CMARAppRestrictionsDelegate
- (bool)isDeviceNonCompliant { return false; }
%end

%hook ADYSecurityChecks
+ (bool)isDeviceJailbroken { return false; }
%end

%hook UBReportMetadataDevice
- (void*)is_rooted { return NULL; }
%end

%hook UtilitySystem
+ (bool)isJailbreak { return false; }
%end

%hook CPWRDeviceInfo
- (bool)isJailbroken { return false; }
%end

%hook CPWRSessionInfo
- (bool)isJailbroken { return false; }
%end

%hook KSSystemInfo
+ (bool)isJailbroken { return false; }
%end

%hook v_VDMap
- (bool)isJailbrokenDetected { return false; }
- (bool)isJailBrokenDetectedByVOS { return false; }
- (bool)isDFPHookedDetecedByVOS { return false; }
- (bool)isCodeInjectionDetectedByVOS { return false; }
- (bool)isDebuggerCheckDetectedByVOS { return false; }
- (bool)isAppSignerCheckDetectedByVOS { return false; }
- (bool)isRuntimeTamperingDetected { return false; }
%end

%hook SDMUtils
- (BOOL)isJailBroken { return NO; }
%end

%hook OneSignalJailbreakDetection
+ (BOOL)isJailbroken { return NO; }
%end

%hook DigiPassHandler
- (BOOL)rootedDeviceTestResult { return NO; }
%end

%hook AWMyDeviceGeneralInfo
- (bool)isCompliant { return true; }
%end

%hook DTXSessionInfo
- (bool)isJailbroken { return false; }
%end

%hook DTXDeviceInfo
- (bool)isJailbroken { return false; }
%end

%hook jailBrokenJudge
- (bool)isJailBreak { return false; }
- (bool)isCydiaJailBreak { return false; }
- (bool)isApplicationsJailBreak { return false; }
- (bool)ischeckCydiaJailBreak { return false; }
- (bool)isPathJailBreak { return false; }
- (bool)boolIsjailbreak { return false; }
%end

%hook FBAdBotDetector
- (bool)isJailBrokenDevice { return false; }
%end

%hook TNGDeviceTool
+ (bool)isJailBreak { return false; }
+ (bool)isJailBreak_file { return false; }
+ (bool)isJailBreak_cydia { return false; }
+ (bool)isJailBreak_appList { return false; }
+ (bool)isJailBreak_env { return false; }
%end

%hook DTDeviceInfo
+ (bool)isJailbreak { return false; }
%end

%hook SecVIDeviceUtil
+ (bool)isJailbreak { return false; }
%end

%hook RVPBridgeExtension4Jailbroken
- (bool)isJailbroken { return false; }
%end

%hook ZDetection
+ (bool)isRootedOrJailbroken { return false; }
%end

%hook FreeraspPlugin
- (instancetype)init { return nil; }
%end

%hook FreeraspCore
- (BOOL)detectJailbreak { return NO; }
%end

%hook EMDSKPPConfiguration
- (bool)jailBroken { return false; }
%end

%hook EnrollParameters
- (void*)jailbroken { return NULL; }
%end

%hook EMDskppConfigurationBuilder
- (bool)jailbreakStatus { return false; }
%end

%hook FCRSystemMetadata
- (bool)isJailbroken { return false; }
%end

%hook GemaltoConfiguration
+ (bool)isJailbreak { return false; }
%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_DeviceCheck(void) {}
