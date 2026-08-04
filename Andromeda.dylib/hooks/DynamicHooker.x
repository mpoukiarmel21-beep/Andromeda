#import "hooks.h"

// ============================================================================
// ANDROMEDA DYNAMIC HOOKER — Scanner runtime pour classes de détection
// Hook automatiquement toutes les classes contenant des mots-clés de détection
// Cela couvre ~90% des apps sans hooks spécifiques
// ============================================================================

// Mots-clés à rechercher dans les noms de classes
static NSArray* detectionKeywords = nil;

__attribute__((unused)) static BOOL dynamicHook_returnYES(id self, SEL _cmd) {
    return YES;
}

__attribute__((unused)) static BOOL dynamicHook_returnNO(id self, SEL _cmd) {
    return NO;
}

__attribute__((unused)) static id dynamicHook_returnNil(id self, SEL _cmd) {
    return nil;
}

__attribute__((unused)) static id dynamicHook_returnYES_dict(id self, SEL _cmd) {
    return @YES;
}

// ============================================================================
// Scanner et hooker les classes de détection
// ============================================================================

static void scanAndHookDetectionClasses(void) {
    NSLog(@"[Andromeda] DynamicHooker: Scanning runtime for detection classes...");

    unsigned int classCount = 0;
    Class* classes = objc_copyClassList(&classCount);
    if(!classes) return;

    int hookedCount = 0;

    for(unsigned int i = 0; i < classCount; i++) {
        const char* className = class_getName(classes[i]);
        if(!className) continue;

        NSString* name = @(className);

        // Vérifier si le nom contient un mot-clé de détection
        BOOL shouldHook = NO;
        for(NSString* keyword in detectionKeywords) {
            if([name containsString:keyword]) {
                shouldHook = YES;
                break;
            }
        }

        if(!shouldHook) continue;

        // Hook toutes les méthodes retournant BOOL
        unsigned int methodCount = 0;
        Method* methods = class_copyMethodList(classes[i], &methodCount);

        for(unsigned int j = 0; j < methodCount; j++) {
            SEL sel = method_getName(methods[j]);
            const char* selName = sel_getName(sel);
            if(!selName) continue;

            NSString* selStr = @(selName);

            // Hook les méthodes de détection courantes
            if([selStr containsString:@"isJailbroken"]
            || [selStr containsString:@"isDeviceJailbroken"]
            || [selStr containsString:@"isRooted"]
            || [selStr containsString:@"isDeviceRooted"]
            || [selStr containsString:@"isCompromised"]
            || [selStr containsString:@"isDeviceCompromised"]
            || [selStr containsString:@"isDeviceSafe"]
            || [selStr containsString:@"isSafeEnvironment"]
            || [selStr containsString:@"isInsecureEnvironment"]
            || [selStr containsString:@"isTampered"]
            || [selStr containsString:@"isDebuggerPresent"]
            || [selStr containsString:@"hasSuspiciousLibraries"]
            || [selStr containsString:@"isEmulator"]
            || [selStr containsString:@"validateAppSignature"]
            || [selStr containsString:@"isRuntimePatched"]
            || [selStr containsString:@"isHooked"]
            || [selStr containsString:@"isSubstrateLoaded"]
            || [selStr containsString:@"isSubstituteLoaded"]
            || [selStr containsString:@"hasInjectedDynamicLibraries"]
            || [selStr containsString:@"checkIntegrity"]
            || [selStr containsString:@"checkDeviceIntegrity"]
            || [selStr containsString:@"checkAppIntegrity"]
            || [selStr containsString:@"checkCodeSignature"]
            || [selStr containsString:@"checkBundleIntegrity"]
            || [selStr containsString:@"checkDeviceSecurity"]
            || [selStr containsString:@"evaluateDevice"]
            || [selStr containsString:@"isDeviceTrusted"]
            || [selStr containsString:@"isDeviceBanned"]
            || [selStr containsString:@"isDeviceFlagged"]
            || [selStr containsString:@"isBanned"]
            || [selStr containsString:@"isShadowBanned"]
            || [selStr containsString:@"isSuspended"]
            || [selStr containsString:@"isBlocked"]
            || [selStr containsString:@"hasBannedDevice"]
            || [selStr containsString:@"isDeviceBlacklisted"]
            || [selStr containsString:@"amIJailbroken"]
            || [selStr containsString:@"amIReverseEngineered"]
            || [selStr containsString:@"amIDebugged"]
            || [selStr containsString:@"amIRunInEmulator"]) {

                // Vérifier le type de retour
                char retType;
                method_getReturnType(methods[j], &retType, sizeof(retType));

                if(retType == 'B' || retType == 'c') {
                    IMP newIMP;
                    if([selStr containsString:@"isJailbroken"]
                    || [selStr containsString:@"isRooted"]
                    || [selStr containsString:@"isCompromised"]
                    || [selStr containsString:@"isTampered"]
                    || [selStr containsString:@"isDebuggerPresent"]
                    || [selStr containsString:@"hasSuspiciousLibraries"]
                    || [selStr containsString:@"isRuntimePatched"]
                    || [selStr containsString:@"isHooked"]
                    || [selStr containsString:@"isSubstrateLoaded"]
                    || [selStr containsString:@"isSubstituteLoaded"]
                    || [selStr containsString:@"hasInjectedDynamicLibraries"]
                    || [selStr containsString:@"isEmulator"]
                    || [selStr containsString:@"isDeviceBanned"]
                    || [selStr containsString:@"isDeviceFlagged"]
                    || [selStr containsString:@"isBanned"]
                    || [selStr containsString:@"isShadowBanned"]
                    || [selStr containsString:@"isSuspended"]
                    || [selStr containsString:@"isBlocked"]
                    || [selStr containsString:@"hasBannedDevice"]
                    || [selStr containsString:@"isDeviceBlacklisted"]
                    || [selStr containsString:@"amIJailbroken"]
                    || [selStr containsString:@"amIReverseEngineered"]
                    || [selStr containsString:@"amIDebugged"]
                    || [selStr containsString:@"amIRunInEmulator"]) {
                        newIMP = (IMP)dynamicHook_returnNO;
                    } else {
                        newIMP = (IMP)dynamicHook_returnYES;
                    }

                    method_setImplementation(methods[j], newIMP);
                    hookedCount++;
                    NSLog(@"[Andromeda] DynamicHooker: Hooked -[%@ %s]", name, selName);
                }
            }
        }

        free(methods);
    }

    free(classes);
    NSLog(@"[Andromeda] DynamicHooker: Scan complete. Hooked %d methods", hookedCount);
}

// ============================================================================
// Initialisation
// ============================================================================

void andromeda_hook_DynamicHooker(void) {
    NSLog(@"[Andromeda] DynamicHooker: Initializing...");

    // Initialiser les mots-clés de détection
    detectionKeywords = @[
        @"Security",
        @"Jailbreak",
        @"Jailbroken",
        @"Integrity",
        @"DeviceCheck",
        @"DeviceInfo",
        @"AppIntegrity",
        @"AntiTamper",
        @"RuntimeSecurity",
        @"Fingerprint",
        @"Attestation",
        @"Compromise",
        @"Rooted",
        @"Debugged",
        @"Emulator",
        @"ReverseEngineer",
        @"Hooked",
        @"Substrate",
        @"Substitute",
        @"Shadow",
        @"Bypass",
        @"Protected",
        @"Secure",
        @"Verifier",
        @"Authenticity",
        @"Tamper",
        @"Shield",
        @"Guard",
        @"Defender",
        @"Sentinel",
        @"Monitor",
        @"Inspector",
        @"Detector",
        @"Checker",
        @"Validator",
        @"Evaluator",
        @"Authenticator",
        @"Protector",
        @"AntiCheat",
        @"AntiFraud",
        @"AntiTamper",
        @"SecurityCheck",
        @"DeviceSecurity",
        @"AppSecurity",
        @"PlatformSecurity",
        @"SystemSecurity"
    ];

    // Scanner et hooker
    scanAndHookDetectionClasses();

    NSLog(@"[Andromeda] DynamicHooker: Installation complete");
}
