#import "Headers/DetectionSignatures.h"

@implementation DetectionSignatures

+ (NSDictionary*)_externalDB {
    static NSDictionary* db = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSArray* paths = @[
            @"/var/jb/Library/Andromeda/signatures.json",
            @"/Library/Andromeda/signatures.json"
        ];
        for(NSString* path in paths) {
            NSData* data = [NSData dataWithContentsOfFile:path];
            if(data) {
                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                if([obj isKindOfClass:[NSDictionary class]]) {
                    db = obj;
                    break;
                }
            }
        }
    });
    return db;
}

+ (NSArray*)_mergedArray:(NSArray*)compiled forKey:(NSString*)key {
    if(!compiled || compiled.count == 0) return compiled ?: @[];
    NSDictionary* external = [self _externalDB];
    NSArray* extra = external ? external[key] : nil;
    if(!extra || ![extra isKindOfClass:[NSArray class]] || extra.count == 0) return compiled;
    NSMutableArray* merged = [NSMutableArray arrayWithArray:compiled];
    NSMutableSet* seen = [NSMutableSet setWithArray:compiled];
    for(id item in extra) {
        if(![seen containsObject:item]) {
            [seen addObject:item];
            [merged addObject:item];
        }
    }
    return merged;
}

+ (NSDictionary*)_mergedDict:(NSDictionary*)compiled forKey:(NSString*)key {
    if(!compiled || compiled.count == 0) return compiled ?: @{};
    NSDictionary* external = [self _externalDB];
    NSDictionary* extra = external ? external[key] : nil;
    if(!extra || ![extra isKindOfClass:[NSDictionary class]] || extra.count == 0) return compiled;
    NSMutableDictionary* merged = [NSMutableDictionary dictionaryWithDictionary:compiled];
    for(NSString* k in extra) {
        id existing = merged[k];
        id incoming = extra[k];
        if([existing isKindOfClass:[NSArray class]] && [incoming isKindOfClass:[NSArray class]]) {
            NSMutableArray* list = [NSMutableArray arrayWithArray:existing];
            NSMutableSet* seen = [NSMutableSet setWithArray:existing];
            for(id item in incoming) {
                if(![seen containsObject:item]) {
                    [seen addObject:item];
                    [list addObject:item];
                }
            }
            merged[k] = list;
        } else {
            merged[k] = incoming;
        }
    }
    return merged;
}

+ (NSArray<NSString*>*)jailbreakPaths_fs {
    return [self _mergedArray:[self _compiledJailbreakPathsFS] forKey:@"jailbreakPaths_fs"];
}

+ (NSArray<NSString*>*)_compiledJailbreakPathsFS {
    return @[
        @"/Applications/Cydia.app",
        @"/Applications/Sileo.app",
        @"/Applications/Zebra.app",
        @"/Applications/Installer.app",
        @"/Applications/iCleaner.app",
        @"/Applications/Filza.app",
        @"/Applications/NewTerm.app",
        @"/Applications/MUXer.app",
        @"/Applications/SafeMode.app",
        @"/Library/MobileSubstrate",
        @"/Library/PreferenceBundles",
        @"/Library/PreferenceLoader",
        @"/Library/Frameworks/CydiaSubstrate.framework",
        @"/usr/lib/libsubstitute.dylib",
        @"/usr/lib/libsubstrate.dylib",
        @"/usr/lib/TweakInject",
        @"/usr/libexec/cydia",
        @"/usr/sbin/sshd",
        @"/usr/bin/ssh",
        @"/usr/bin/sbreload",
        @"/usr/bin/ldrestart",
        @"/etc/apt",
        @"/etc/ssh",
        @"/bin/bash",
        @"/bin/sh",
        @"/var/lib/dpkg",
        @"/var/cache/apt",
        @"/var/log/apt",
        @"/var/tmp/cydia.log",
        @"/var/jb",
        @"/private/etc/apt",
        @"/private/etc/ssh",
        @"/private/var/lib/apt",
        @"/private/var/lib/cydia",
        @"/private/var/stash",
        @"/private/var/mobile/Library/Cydia",
        @"/private/var/mobile/Library/Sileo",
        @"/private/var/mobile/Library/Zebra",
        @"/private/var/containers/Bundle/Application",
        @"/private/var/containers/Bundle/tweaksupport",
        @"/var/jb/.bootstrapped", @"/var/jb/.installed_palera1n", @"/var/jb/.installed_dopamine",
        @"/var/jb/.procursus_strapped", @"/var/jb/.bootstrap", @"/var/jb/.jailbreak",
        @"/.bootstrapped", @"/.installed_unc0ver", @"/.installed_taurine", @"/.installed_xina",
        @"/.installed_palera1n", @"/.procursus_strapped", @"/.jbroot",
        @"/cores/binpack"
    ];
}

+ (NSArray<NSString*>*)jailbreakPaths_fs_extra {
    return [self _mergedArray:@[] forKey:@"jailbreakPaths_fs"];
}

+ (NSArray<NSString*>*)jailbreakPaths_containing {
    return [self _mergedArray:@[
        @"cydia",
        @"sileo",
        @"zebra",
        @"substitute",
        @"substrate",
        @"tweakinject",
        @"mobilesubstrate",
        @"apt",
        @"dpkg",
        @"unc0ver",
        @"checkra1n",
        @"palera1n",
        @"taurine",
        @"chimera",
        @"electra",
        @"odyssey",
        @"xina",
        @"dopamine",
        @"bootstrap",
        @"ellekit",
        @"jailbreak",
        @"sbreload",
        @"ldrestart",
        @"sshd",
        @"dropbear",
        @"safe mode",
        @"filza",
        @"icleaner",
        @"newterm",
        @"mterminal",
        @"openssh",
        @"cache.cydia",
        @"var/jb",
        @"preferenceloader",
        @"preferencebundles",
        @"rocketbootstrap",
        @"applist",
        @"flipswitch",
        @"activator"
    ] forKey:@"jailbreakPaths_containing"];
}

+ (NSArray<NSString*>*)jailbreakPaths_prefix {
    return @[
        @"cydia_",
        @"sileo_",
        @"dpkg_",
        @"apt_",
        @"substitute_ins_",
        @"tweakinject_",
        @"mobilesubstrate_",
        @"jb_",
        @"bootstrap_",
        @"ellekit_"
    ];
}

+ (NSArray<NSString*>*)jailbreakPaths_suffix {
    return @[
        @".dylib",
        @"_substitute",
        @"_substrate",
        @"_tweakinject",
        @"_mobilesubstrate",
        @"_ellekit",
        @"_cydia",
        @"_sileo"
    ];
}

+ (NSArray<NSString*>*)jailbreakSymlinks {
    return @[
        @"/jb",
        @"/var/jb",
        @"/.jbroot"
    ];
}

+ (NSArray<NSString*>*)jailbreakApps {
    return @[
        @"com.saurik.Cydia",
        @"org.coolstar.SileoNightly",
        @"org.coolstar.SileoStore",
        @"xyz.willy.Zebra",
        @"com.samgisaninja.FilzaFileManager",
        @"com.muirey03.iCleanerPro",
        @"com.tigisoftware.Filza",
        @"com.mtac.newterm",
        @"com.hbang.newterm3",
        @"com.matchstic.ReProvision",
        @"com.matchstic.ReProvision8",
        @"science.xnu.undecimus",
        @"com.odyssey.odyssey",
        @"org.coolstar.odyssey",
        @"com.odyssey.taurine",
        @"com.electrateam.chimera",
        @"com.electrateam.electra",
        @"com.xina.xina",
        @"com.opa334.Dopamine",
        @"com.opa334.Dopamine-roothide"
    ];
}

+ (NSArray<NSString*>*)jailbreakFilesToHide {
    return @[
        @"/Library/MobileSubstrate/DynamicLibraries",
        @"/usr/lib/TweakInject",
        @"/usr/lib/libsubstitute.dylib",
        @"/usr/lib/libsubstrate.dylib",
        @"/usr/lib/libellekit.dylib",
        @"/etc/apt/sources.list.d",
        @"/var/lib/dpkg/info",
        @"/var/jb/Library",
        @"/var/jb/usr/lib",
        @"/Library/dpkg",
        @"/.bootstrapped",
        @"/.procursus_strapped"
    ];
}

+ (NSArray<NSString*>*)suspiciousDylibNames {
    return [self _mergedArray:@[
        @"SubstrateLoader",
        @"SubstrateInserter",
        @"substitute-loader",
        @"TweakInject",
        @"MobileSubstrate",
        @"CydiaSubstrate",
        @"libsubstitute",
        @"libsubstrate",
        @"libellekit",
        @"libhooker",
        @"Cephei",
        @"preferenceloader",
        @"rocketbootstrap",
        @"AppList",
        @"Flipswitch",
        @"Activator",
        @"libcolorpicker",
        @"libimagepicker",
        @"SafariPlus",
        @"Crane",
        @"Watusi",
        @"iGameGod",
        @"Shadow",
        @"A-Bypass",
        @"Liberty",
        @"KernBypass",
        @"FlyJB",
        @"Hestia",
        @"Sileo",
        @"Zebra",
        @"Cydia",
        @"Filza",
        @"iCleaner"
    ] forKey:@"suspiciousDylibNames"];
}

+ (NSArray<NSString*>*)bannedURLSchemes {
    return [self _mergedArray:@[
        @"cydia://",
        @"sileo://",
        @"zbra://",
        @"apt://",
        @"filza://",
        @"icleaner://",
        @"undecimus://",
        @"newterm://",
        @"mterminal://",
        @"activator://",
        @"ssh://"
    ] forKey:@"bannedURLSchemes"];
}

+ (NSArray<NSString*>*)knownDetectionClasses {
    return [self _mergedArray:@[
        @"IOSSecuritySuite",
        @"JailbreakDetection",
        @"DTTJailbreakDetection",
        @"ELJailbreakDetection",
        @"APJailbreakDetection",
        @"JailbreakChecker",
        @"JailbreakDetector",
        @"AntiJailbreak",
        @"SecurityCheck",
        @"DeviceIntegrity",
        @"IntegrityCheck",
        @"RootCheck",
        @"EmulatorDetection",
        @"RuntimeSecurityCheck",
        @"TamperDetection",
        @"Fortify",
        @"Guardian",
        @"TrustDefender",
        @"iXguard",
        @"SecuredSDK",
        @"ThreatMetrix",
        @"ShieldFraud",
        @"BioCatchSDK",
        @"DataDome",
        @"FingerprintJS",
        @"Incognia",
        @"Sardine",
        @"Persona",
        @"Jumio",
        @"Onfido",
        @"Veriff",
        @"Mitek",
        @"Microblink",
        @"IPQualityScore",
        @"MinFraud",
        @"Seon",
        @"Arkose",
        @"Sift",
        @"Riskified",
        @"Forter",
        @"Signifyd",
        @"FBDeviceInformation",
        @"FBAppIntegrity",
        @"FBDeviceIntegrity",
        @"FBBuildEnvironment",
        @"FBAnalytics",
        @"IGSecurityManager",
        @"IGIntegrityCheck",
        @"IGDeviceChecker",
        @"IGRuntimeSecurity",
        @"IGDeviceFingerprint",
        @"IGSecurityController",
        @"THAppSecurityManager",
        @"THDeviceIntegrity",
        @"THSecurityCheck",
        @"THRuntimeSecurity",
        @"THDeviceFingerprint",
        @"THIntegrityValidator",
        @"SCSecurityManager",
        @"SCDeviceCheck",
        @"SCIntegrityValidator",
        @"SCRuntimeSecurity",
        @"SCDeviceFingerprint",
        @"TTSecurityManager",
        @"TTDeviceCheck",
        @"TTIntegrityValidator",
        @"TTRuntimeSecurity",
        @"TTDeviceFingerprint",
        @"TTSecurityController",
        @"TNDRSecurityManager",
        @"TNDRDeviceIntegrity",
        @"TNDRAppIntegrity",
        @"BMBLSecurityManager",
        @"BMBLDeviceChecker",
        @"BMBLIntegrityCheck",
        @"HLYSecurityManager",
        @"HLYDeviceIntegrity",
        @"HLYAppIntegrityCheck",
        @"HLYRuntimeSecurity",
        @"HLYFingerprintManager",
        @"HLYTrustEvaluator",
        @"BDODeviceInfo",
        @"BDOSecurity",
        @"BDOIntegrityCheck",
        @"FRZSecurityCheck",
        @"FRZIntegrityValidator",
        @"FLSSecurityManager",
        @"FLSIntegrityCheck",
        @"FLSDeviceFingerprint",
        @"HNGDeviceCheck",
        @"HNGSecurityIntegration",
        @"GRDRSecurityManager",
        @"HPNDeviceSecurity",
        @"OKCDeviceCheck",
        @"MTCSecurityManager"
    ] forKey:@"knownDetectionClasses"];
}

+ (NSArray<NSString*>*)knownDetectionSelectors {
    return [self _mergedArray:@[
        @"isJailbroken",
        @"isJailBreak",
        @"isJailBroken",
        @"isDeviceJailbroken",
        @"isJailbreak",
        @"jailbroken",
        @"jailbreak",
        @"isJailbreakDetected",
        @"checkJailbreak",
        @"detectJailbreak",
        @"isCompromised",
        @"isRooted",
        @"isDeviceRooted",
        @"isTampered",
        @"isDeviceTampered",
        @"isRuntimeTampered",
        @"detectTampering",
        @"isDebuggerAttached",
        @"isBeingDebugged",
        @"isDebugged",
        @"checkDebugger",
        @"detectInjection",
        @"isCodeInjected",
        @"checkIntegrity",
        @"deviceIntegrity",
        @"appIntegrity",
        @"isEmulator",
        @"isSimulator",
        @"isHooked",
        @"detectHooks",
        @"isSubstratePresent",
        @"isSubstitutePresent",
        @"hasJailbreakFiles",
        @"checkJailbreakFiles",
        @"checkSuspiciousFiles",
        @"fileCheck",
        @"pathCheck",
        @"accessCheck",
        @"sandboxIntegrity",
        @"checkSandbox",
        @"checkEnvironment",
        @"environmentCheck",
        @"checkDYLD",
        @"detectDYLD",
        @"detectFrida",
        @"detectCycript",
        @"antiDebug",
        @"antiTamper",
        @"antiReverse",
        @"integrityCheck",
        @"securityCheck",
        @"safetyCheck"
    ] forKey:@"knownDetectionSelectors"];
}

+ (NSDictionary<NSString*,NSArray<NSString*>*>*)datingAppBundleIds {
    return @{
        @"tinder": @[
            @"com.cardify.tinder",
            @"co.hinge.app",
            @"com.bumble.app",
            @"co.hily.app",
            @"com.badoo.badoo",
            @"com.ftw-and-co.fruitz",
            @"com.feels.Feels",
            @"com.happn.happn",
            @"com.match.Match",
            @"com.pof.pof",
            @"com.eharmony.eharmony",
            @"com.okcupid.okcupid",
            @"com.zoosk.zoosk",
            @"com.lex.lex",
            @"com.grindrapp.ios",
            @"com.jackd.ios",
            @"com.once.once",
            @"com.theleague.ios",
            @"com.clover.ios",
            @"com.boo.app",
            @"com.iris.dating",
            @"com.lovoo.ios",
            @"com.adopteunmec.ios",
            @"com.jaumo.ios",
            @"com.tantan.ios",
            @"com.hud.ios",
            @"com.turnup.app"
        ],
        @"bumble": @[
            @"com.bumble.app",
            @"com.bumble.bff"
        ],
        @"badoo": @[
            @"com.badoo.badoo"
        ],
        @"hily": @[
            @"co.hily.app"
        ],
        @"fruitz": @[
            @"com.ftw-and-co.fruitz"
        ],
        @"feels": @[
            @"com.feels.Feels"
        ],
        @"hinge": @[
            @"co.hinge.app"
        ],
        @"happn": @[
            @"com.happn.happn"
        ],
        @"okcupid": @[
            @"com.okcupid.okcupid"
        ],
        @"pof": @[
            @"com.pof.pof"
        ],
        @"match": @[
            @"com.match.Match"
        ],
        @"meetic": @[
            @"com.meetic.iphone"
        ],
        @"once": @[
            @"com.once.once"
        ],
        @"grindr": @[
            @"com.grindrapp.ios"
        ],
        @"her": @[
            @"com.weareher.HER"
        ],
        @"scruff": @[
            @"com.scruff.scruff"
        ],
        @"jackd": @[
            @"com.jackd.ios"
        ],
        @"zoosk": @[
            @"com.zoosk.zoosk"
        ],
        @"innercircle": @[
            @"com.innercircle.ios"
        ],
        @"theleague": @[
            @"com.theleague.ios"
        ],
        @"clover": @[
            @"com.clover.ios"
        ],
        @"hud": @[
            @"com.hud.ios"
        ],
        @"turnup": @[
            @"com.turnup.app"
        ],
        @"boo": @[
            @"com.boo.app"
        ],
        @"iris": @[
            @"com.iris.dating"
        ],
        @"lovoo": @[
            @"com.lovoo.ios"
        ],
        @"adopte": @[
            @"com.adopteunmec.ios"
        ],
        @"jaumo": @[
            @"com.jaumo.ios"
        ],
        @"tantan": @[
            @"com.tantan.ios"
        ]
    };
}

+ (NSDictionary<NSString*,NSArray<NSString*>*>*)socialAppBundleIds {
    return @{
        @"instagram": @[
            @"com.burbn.instagram"
        ],
        @"threads": @[
            @"com.instagram.barcelona",
            @"com.burbn.barcelona"
        ],
        @"facebook": @[
            @"com.facebook.Facebook"
        ],
        @"messenger": @[
            @"com.facebook.Messenger"
        ],
        @"whatsapp": @[
            @"net.whatsapp.WhatsApp"
        ],
        @"snapchat": @[
            @"com.snapchat.Snapchat"
        ],
        @"tiktok": @[
            @"com.zhiliaoapp.musically"
        ],
        @"twitter": @[
            @"com.atebits.Tweetie2"
        ],
        @"bereal": @[
            @"com.bereal.ios"
        ],
        @"telegram": @[
            @"ph.telegra.Telegraph"
        ],
        @"signal": @[
            @"org.whispersystems.signal"
        ],
        @"discord": @[
            @"com.hammerandchisel.discord"
        ],
        @"reddit": @[
            @"com.reddit.Reddit"
        ],
        @"linkedin": @[
            @"com.linkedin.LinkedIn"
        ]
    };
}

+ (NSDictionary<NSString*,NSArray<NSString*>*>*)appSpecificDetectionClasses {
    return [self _mergedDict:@{
        @"co.hily.app": @[
            @"HLYSecurityManager", @"HLYDeviceIntegrity", @"HLYAppIntegrityCheck",
            @"HLYRuntimeSecurity", @"HLYFingerprintManager", @"HLYTrustEvaluator",
            @"IOSSecuritySuite"
        ],
        @"com.cardify.tinder": @[
            @"TNDRSecurityManager", @"TNDRDeviceIntegrity", @"TNDRAppIntegrity",
            @"TNDRUser", @"TNDRDeletionDetector", @"TNDRMetaManager",
            @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.bumble.app": @[
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"BMBLAccountManager", @"IOSSecuritySuite"
        ],
        @"com.bumble.bff": @[
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"BMBLAccountManager", @"IOSSecuritySuite"
        ],
        @"com.badoo.badoo": @[
            @"BDODeviceInfo", @"BDOSecurity", @"BDOIntegrityCheck",
            @"BDORuntimeSecurity", @"BDODeviceFingerprint", @"BDOAccountManager",
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.ftw-and-co.fruitz": @[
            @"FRZSecurityCheck", @"FRZIntegrityValidator", @"FRZRuntimeSecurity",
            @"FRZDeviceFingerprint", @"FRZAppIntegrity", @"FRZSecurityManager",
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.feels.Feels": @[
            @"FLSSecurityManager", @"FLSIntegrityCheck", @"FLSDeviceFingerprint",
            @"FLSRuntimeSecurity", @"FLSAppIntegrity", @"FLSDeviceSecurity",
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.burbn.instagram": @[
            @"IGSecurityManager", @"IGIntegrityCheck", @"IGAnalyticsSession",
            @"IGDeviceChecker", @"FBDeviceInformation", @"FBAppIntegrity",
            @"RCTDeviceInfo", @"IGDirectSecurity", @"IGUserSession",
            @"IGRuntimeSecurity", @"IGDeviceFingerprint", @"FBDeviceIntegrity",
            @"FBBuildEnvironment", @"IGSecurityController", @"BMBLSecurityManager",
            @"BMBLDeviceChecker", @"BMBLIntegrityCheck", @"IOSSecuritySuite",
            @"flutter_jailbreak_detection"
        ],
        @"com.instagram.barcelona": @[
            @"THAppSecurityManager", @"THDeviceIntegrity", @"THSecurityCheck",
            @"BHInstagramAppIntegrity", @"THRuntimeSecurity", @"THDeviceFingerprint",
            @"THIntegrityValidator", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.burbn.barcelona": @[
            @"THAppSecurityManager", @"THDeviceIntegrity", @"THSecurityCheck",
            @"BHInstagramAppIntegrity", @"THRuntimeSecurity", @"THDeviceFingerprint",
            @"THIntegrityValidator", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.happn.happn": @[
            @"HPNDeviceSecurity", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.okcupid.okcupid": @[
            @"OKCDeviceCheck", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.match.Match": @[
            @"MatchSecurityManager", @"MatchIntegrityManager", @"MatchDeviceCheck",
            @"MatchJailbreakDetection", @"MatchRuntimeSecurity", @"MatchTrustEvaluator",
            @"IOSSecuritySuite", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"flutter_jailbreak_detection"
        ],
        @"com.pof.pof": @[
            @"POFSecurityManager", @"POFIntegrityManager", @"POFDeviceCheck",
            @"POFJailbreakDetection", @"POFRuntimeSecurity", @"POFTrustEvaluator",
            @"IOSSecuritySuite", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"flutter_jailbreak_detection"
        ],
        @"com.grindrapp.ios": @[
            @"GRDRSecurityManager", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.meetic.iphone": @[
            @"MTCSecurityManager", @"BMBLSecurityManager", @"BMBLDeviceChecker",
            @"BMBLIntegrityCheck", @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"co.hinge.app": @[
            @"HNGDeviceCheck", @"HNGSecurityIntegration", @"BMBLSecurityManager",
            @"BMBLDeviceChecker", @"BMBLIntegrityCheck", @"IOSSecuritySuite",
            @"flutter_jailbreak_detection"
        ],
        @"com.zhiliaoapp.musically": @[
            @"TTSecurityManager", @"TTDeviceCheck", @"TTIntegrityValidator",
            @"TTRuntimeSecurity", @"TTDeviceFingerprint", @"TTSecurityController",
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"IOSSecuritySuite", @"flutter_jailbreak_detection"
        ],
        @"com.snapchat.Snapchat": @[
            @"SCSecurityManager", @"SCDeviceCheck", @"SCIntegrityValidator",
            @"SCRuntimeSecurity", @"SCDeviceFingerprint"
        ],
        @"com.facebook.Facebook": @[
            @"FBSecurityManager", @"FBDeviceCheck", @"FBDeviceIntegrity",
            @"FBBuildEnvironment", @"FBAppIntegrity"
        ]
    } forKey:@"appSpecificDetectionClasses"];
}

+ (NSArray<NSString*>*)suspiciousEnvVars {
    return [self _mergedArray:@[
        @"DYLD_INSERT_LIBRARIES",
        @"DYLD_FORCE_FLAT_NAMESPACE",
        @"DYLD_SHARED_REGION",
        @"DYLD_SHARED_CACHE_DIR",
        @"DYLD_ROOT_PATH",
        @"DYLD_LIBRARY_PATH",
        @"DYLD_FRAMEWORK_PATH",
        @"DYLD_FALLBACK_LIBRARY_PATH",
        @"DYLD_FALLBACK_FRAMEWORK_PATH",
        @"LD_PRELOAD",
        @"CYDIA",
        @"Substrate",
        @"SileoClient",
        @"ZebraClient",
        @"MSSafeMode",
        @"SafeMode",
        @"Jailbreak",
        @"JB_ROOT",
        @"__XINA",
        @"CHOICY",
        @"PALERA1N",
        @"FRIDA",
        @"FRIDA_SERVER",
        @"FRIDA_VERSION",
        @"_MSSafeMode",
        @"_SubstrateLoader",
        @"LIBSubstitute",
        @"_SubstituteLoader",
        @"_TweakInject",
        @"ELLEKIT",
        @"LIBHOOKER"
    ] forKey:@"suspiciousEnvVars"];
}

+ (NSArray<NSString*>*)suspiciousDyldSymbols {
    return @[
        @"SubstrateLoader",
        @"SubstrateInserter",
        @"substitute-loader",
        @"TweakInject",
        @"MobileSubstrate",
        @"CydiaSubstrate",
        @"libsubstitute",
        @"libsubstrate",
        @"libellekit",
        @"libhooker",
        @"frida",
        @"frida-agent",
        @"gum-js-loop",
        @"gum-js-tmp",
        @"gmain",
        @"gum-js-tmp"
    ];
}

+ (NSArray<NSString*>*)suspiciousProcessNames {
    return @[
        @"frida-server",
        @"frida-helper",
        @"frida-agent",
        @"cycript",
        @"cycript0",
        @"ssh",
        @"sshd",
        @"dropbear",
        @"dpkg",
        @"apt",
        @"apt-get",
        @"cydia",
        @"sileo",
        @"zebra",
        @"filza",
        @"mterminal",
        @"newterm"
    ];
}

+ (NSArray<NSString*>*)suspiciousProcFiles {
    return [self _mergedArray:@[
        @"/proc/cpuinfo",
        @"/proc/meminfo",
        @"/proc/stat",
        @"/proc/uptime",
        @"/proc/version",
        @"/proc/self/exe",
        @"/proc/self/cmdline",
        @"/proc/self/environ"
    ] forKey:@"suspiciousProcFiles"];
}

+ (NSDictionary<NSString*,NSDictionary*>*)appSpecificConfigurations {
    return @{
        @"co.hily.app": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"iohid",
                @"mobilegestalt", @"networkinterface", @"procfiles",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.cardify.tinder": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"co.hinge.app": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.match.Match": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.pof.pof": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.bumble.app": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.bumble.bff": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.badoo.badoo": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.ftw-and-co.fruitz": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.feels.Feels": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.burbn.instagram": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.instagram.barcelona": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.burbn.barcelona": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.snapchat.Snapchat": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.facebook.Facebook": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.zhiliaoapp.musically": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.happn.happn": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.okcupid.okcupid": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.grindrapp.ios": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        },
        @"com.meetic.iphone": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt",
                @"networkinterface", @"procfiles", @"iohid",
                @"processhiding", @"fridabypass", @"dynamichecker"
            ]
        }
    };
}

@end
