#import "Headers/DetectionSignatures.h"

@implementation DetectionSignatures

+ (NSArray<NSString*>*)jailbreakPaths_fs {
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
        @"/.bootstrapped",
        @"/.installed_unc0ver",
        @"/.installed_taurine",
        @"/.installed_xina",
        @"/.installed_palera1n",
        @"/.procursus_strapped",
        @"/.jbroot",
        @"/cores/binpack"
    ];
}

+ (NSArray<NSString*>*)jailbreakPaths_containing {
    return @[
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
    ];
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
    ];
}

+ (NSArray<NSString*>*)bannedURLSchemes {
    return @[
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
    ];
}

+ (NSArray<NSString*>*)knownDetectionClasses {
    return @[
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
    ];
}

+ (NSArray<NSString*>*)knownDetectionSelectors {
    return @[
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
    ];
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
            @"com.meetic.meetic"
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
            @"com.instagram.barcelona"
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
    return @{
        @"co.hily.app": @[
            @"HLYSecurityManager", @"HLYDeviceIntegrity", @"HLYAppIntegrityCheck",
            @"HLYRuntimeSecurity", @"HLYFingerprintManager", @"HLYTrustEvaluator"
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
        @"com.badoo.badoo": @[
            @"BDODeviceInfo", @"BDOSecurity", @"BDOIntegrityCheck",
            @"IOSSecuritySuite"
        ],
        @"com.ftw-and-co.fruitz": @[
            @"FRZSecurityCheck", @"FRZIntegrityValidator",
            @"IOSSecuritySuite"
        ],
        @"com.feels.Feels": @[
            @"FLSSecurityManager", @"FLSIntegrityCheck", @"FLSDeviceFingerprint",
            @"IOSSecuritySuite"
        ],
        @"com.burbn.instagram": @[
            @"IGSecurityManager", @"IGIntegrityCheck", @"IGAnalyticsSession",
            @"IGDeviceChecker", @"FBDeviceInformation", @"FBAppIntegrity",
            @"RCTDeviceInfo", @"IGDirectSecurity", @"IGUserSession",
            @"IGRuntimeSecurity", @"IGDeviceFingerprint", @"FBDeviceIntegrity",
            @"FBBuildEnvironment", @"IGSecurityController"
        ],
        @"com.instagram.barcelona": @[
            @"THAppSecurityManager", @"THDeviceIntegrity", @"THSecurityCheck",
            @"BHInstagramAppIntegrity", @"THRuntimeSecurity", @"THDeviceFingerprint",
            @"THIntegrityValidator"
        ],
        @"com.happn.happn": @[
            @"HPNDeviceSecurity"
        ],
        @"com.okcupid.okcupid": @[
            @"OKCDeviceCheck"
        ],
        @"com.match.Match": @[
            @"MatchSecurityManager"
        ],
        @"com.pof.pof": @[
            @"POFSecurityManager"
        ],
        @"com.grindrapp.ios": @[
            @"GRDRSecurityManager"
        ],
        @"com.meetic.meetic": @[
            @"MTCSecurityManager"
        ],
        @"co.hinge.app": @[
            @"HNGDeviceCheck", @"HNGSecurityIntegration"
        ],
        @"com.zhiliaoapp.musically": @[
            @"TTSecurityManager", @"TTDeviceCheck", @"TTIntegrityValidator",
            @"TTRuntimeSecurity", @"TTDeviceFingerprint", @"TTSecurityController"
        ],
        @"com.snapchat.Snapchat": @[
            @"SCSecurityManager", @"SCDeviceCheck", @"SCIntegrityValidator",
            @"SCRuntimeSecurity", @"SCDeviceFingerprint"
        ],
        @"com.facebook.Facebook": @[
            @"FBSecurityManager", @"FBDeviceCheck", @"FBDeviceIntegrity",
            @"FBBuildEnvironment", @"FBAppIntegrity"
        ]
    };
}

+ (NSArray<NSString*>*)suspiciousEnvVars {
    return @[
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
    ];
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
    return @[
        @"/proc/cpuinfo",
        @"/proc/meminfo",
        @"/proc/stat",
        @"/proc/uptime",
        @"/proc/version",
        @"/proc/self/exe",
        @"/proc/self/cmdline",
        @"/proc/self/environ"
    ];
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
                @"mobilegestalt", @"networkinterface"
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
                @"processhiding", @"fridabypass"
            ]
        },
        @"com.bumble.app": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"mobilegestalt",
                @"processhiding", @"fridabypass"
            ]
        },
        @"com.badoo.badoo": @{
            @"level": @"high",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"sandbox",
                @"urlscheme", @"envvars", @"tweakclasses",
                @"behavioral", @"vnodebypass", @"uiimage",
                @"processhiding", @"fridabypass"
            ]
        },
        @"com.ftw-and-co.fruitz": @{
            @"level": @"high",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"hardwarefprint", @"sandbox", @"urlscheme",
                @"envvars", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"processhiding"
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
                @"processhiding", @"fridabypass"
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
                @"networkinterface", @"procfiles", @"processhiding",
                @"fridabypass", @"dynamichecker"
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
                @"networkinterface", @"procfiles", @"processhiding",
                @"fridabypass"
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
                @"networkinterface", @"procfiles", @"processhiding",
                @"fridabypass", @"dynamichecker"
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
                @"networkinterface", @"procfiles", @"processhiding",
                @"fridabypass"
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
                @"networkinterface", @"procfiles", @"processhiding",
                @"fridabypass", @"dynamichecker"
            ]
        }
    };
}

@end
