#ifndef ANDROMEDA_COMMON_H
#define ANDROMEDA_COMMON_H

#define BUNDLE_ID           "com.andromeda.bypass"
#define MACH_SERVICE_NAME   BUNDLE_ID ".service"
#define ANDROMEDA_PREFS     "/var/mobile/Library/Preferences/" BUNDLE_ID ".plist"
#define ANDROMEDA_CACHE     "/var/mobile/Library/Caches/" BUNDLE_ID

#ifdef DEBUG
#define DLog(...) NSLog(@"[Andromeda] " __VA_ARGS__)
#else
#define DLog(...) (void)0
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_14_0
#define kCFCoreFoundationVersionNumber_iOS_14_0 1740.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_15_0
#define kCFCoreFoundationVersionNumber_iOS_15_0 1854.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_12_0
#define kCFCoreFoundationVersionNumber_iOS_12_0 1534.00
#endif

#define SUBSTRATE_PATH          "/Library/MobileSubstrate/DynamicLibraries/"
#define SUBSTRATE_PATH_JB       "/var/jb/Library/MobileSubstrate/DynamicLibraries/"
#define PREFBUNDLE_PATH         "/Library/PreferenceBundles/"
#define PREFBUNDLE_PATH_JB      "/var/jb/Library/PreferenceBundles/"
#define PREFLOADER_PATH         "/Library/PreferenceLoader/"
#define PREFLOADER_PATH_JB      "/var/jb/Library/PreferenceLoader/"
#define TWEAKINJECT_PATH        "/usr/lib/TweakInject/"
#define TWEAKINJECT_PATH_JB     "/var/jb/usr/lib/TweakInject/"

#endif
