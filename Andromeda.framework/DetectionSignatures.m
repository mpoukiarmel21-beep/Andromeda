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
        @"Signifyd"
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
            @"com.tinder.tinder"
        ],
        @"bumble": @[
            @"com.bumble.bumble",
            @"com.bumblecorp.bumble"
        ],
        @"badoo": @[
            @"com.badoo.iphone",
            @"com.badoo.enterprise"
        ],
        @"hily": @[
            @"com.hily.app",
            @"com.hily.corp"
        ],
        @"fruitz": @[
            @"com.fruitz.app",
            @"com.getfruitz.Fruitz"
        ],
        @"feels": @[
            @"com.feels.frn",
            @"com.feels.app"
        ],
        @"hinge": @[
            @"com.hinge.co",
            @"com.hinge.Hinge"
        ],
        @"happn": @[
            @"com.happn.ios",
            @"com.ftw_and_co.happn"
        ],
        @"okcupid": @[
            @"com.okcupid.OKCupid",
            @"com.okcupid.app"
        ],
        @"pof": @[
            @"com.plentyoffish.app",
            @"com.plentyoffish.PlentyOfFish"
        ],
        @"match": @[
            @"com.match.ios.matchapp",
            @"com.match.Match"
        ],
        @"meetic": @[
            @"com.meetic.iphone",
            @"com.meetic.Meetic"
        ],
        @"once": @[
            @"com.once.once",
            @"com.onceapp.Once"
        ],
        @"bumble_bff": @[
            @"com.bumble.bff",
            @"com.bumble.bizz"
        ],
        @"grindr": @[
            @"com.grindrguy.grindrx",
            @"com.grindr.inc"
        ],
        @"her": @[
            @"com.weareher.HER",
            @"com.hersocial.app"
        ],
        @"scruff": @[
            @"com.scruff.scruff",
            @"com.appspot.scruffapp"
        ],
        @"jackd": @[
            @"com.jackd.ios",
            @"com.jackd.mobi"
        ],
        @"zoosk": @[
            @"com.zoosk.Zoosk",
            @"com.zoosk.iphone"
        ],
        @"innercircle": @[
            @"com.innercircle.ios",
            @"com.circleit.innercircle"
        ],
        @"theleague": @[
            @"com.theleague.ios",
            @"com.theleague.TheLeague"
        ],
        @"clover": @[
            @"com.clover.ios",
            @"com.clover.Clover"
        ],
        @"hud": @[
            @"com.hud.ios",
            @"com.hudapp.HUDApp"
        ],
        @"turnup": @[
            @"com.turnup.app",
            @"com.turnup.TurnUp"
        ],
        @"boo": @[
            @"com.boo.app",
            @"com.boo.Boo"
        ],
        @"iris": @[
            @"com.iris.dating",
            @"com.irisdating.Iris"
        ],
        @"lovoo": @[
            @"com.lovoo.ios",
            @"com.lovoo.LOVOO"
        ],
        @"adopte": @[
            @"com.adopteunmec.ios",
            @"com.adopteunmec.AdopteUnMec"
        ],
        @"jaumo": @[
            @"com.jaumo.ios",
            @"com.jaumo.Jaumo"
        ],
        @"tantan": @[
            @"com.tantan.ios",
            @"com.tantan.Tantan"
        ],
        @"bumble_date": @[
            @"com.bumble.date"
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
            @"com.toyopagroup.picaboo",
            @"com.snapchat.Snapchat"
        ],
        @"tiktok": @[
            @"com.zhiliaoapp.musically",
            @"com.ss.iphone.ugc.Aweme"
        ],
        @"twitter": @[
            @"com.atebits.Tweetie2",
            @"com.twitter.twitter"
        ],
        @"bereal": @[
            @"com.bereal.ios",
            @"com.bereal.Bereal"
        ],
        @"telegram": @[
            @"ph.telegra.Telegraph",
            @"org.telegram.Telegram"
        ],
        @"signal": @[
            @"org.whispersystems.signal",
            @"org.thoughtcrime.securesms"
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
        @"com.hily.app": @[
            @"HLYSecurityManager", @"HLYDeviceIntegrity", @"HLYAppIntegrityCheck",
            @"HLYRuntimeSecurity", @"HLYFingerprintManager", @"HLYTrustEvaluator"
        ],
        @"com.cardify.tinder": @[
            @"TNDRSecurityManager", @"TNDRDeviceIntegrity", @"TNDRAppIntegrity",
            @"TNDRUser", @"TNDRDeletionDetector", @"TNDRMetaManager"
        ],
        @"com.bumble.bumble": @[
            @"BMBLSecurityManager", @"BMBLDeviceChecker", @"BMBLIntegrityCheck",
            @"BMBLAccountManager"
        ],
        @"com.badoo.iphone": @[
            @"BDODeviceInfo", @"BDOSecurity", @"BDOIntegrityCheck"
        ],
        @"com.fruitz.app": @[
            @"FRZSecurityCheck", @"FRZIntegrityValidator"
        ],
        @"com.feels.frn": @[
            @"FLSSecurityManager", @"FLSIntegrityCheck", @"FLSDeviceFingerprint"
        ],
        @"com.burbn.instagram": @[
            @"IGSecurityManager", @"IGIntegrityCheck", @"IGAnalyticsSession",
            @"IGDeviceChecker", @"FBDeviceInformation", @"FBAppIntegrity",
            @"RCTDeviceInfo", @"IGDirectSecurity", @"IGUserSession",
            @"IGRuntimeSecurity", @"IGDeviceFingerprint"
        ],
        @"com.instagram.barcelona": @[
            @"THAppSecurityManager", @"THDeviceIntegrity", @"THSecurityCheck",
            @"BHInstagramAppIntegrity", @"THRuntimeSecurity"
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
        @"PALERA1N"
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
        @"com.hily.app": @{
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
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt"
            ]
        },
        @"com.bumble.bumble": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"mobilegestalt"
            ]
        },
        @"com.badoo.iphone": @{
            @"level": @"high",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"sandbox",
                @"urlscheme", @"envvars", @"tweakclasses",
                @"behavioral", @"vnodebypass", @"uiimage"
            ]
        },
        @"com.fruitz.app": @{
            @"level": @"high",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"hardwarefprint", @"sandbox", @"urlscheme",
                @"envvars", @"tweakclasses", @"behavioral",
                @"vnodebypass"
            ]
        },
        @"com.feels.frn": @{
            @"level": @"maximum",
            @"hooks": @[
                @"filesystem", @"dyld", @"antidebug", @"devicecheck",
                @"appattest", @"hardwarefprint", @"iokit", @"sandbox",
                @"symlookup", @"urlscheme", @"envvars", @"machbootstrap",
                @"objcruntime", @"syscall", @"tweakclasses", @"behavioral",
                @"vnodebypass", @"uiimage", @"sensors", @"mobilegestalt"
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
                @"networkinterface", @"procfiles"
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
                @"networkinterface", @"procfiles"
            ]
        }
    };
}

@end
