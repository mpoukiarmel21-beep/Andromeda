#import "hooks.h"

static char* (*orig_getenv)(const char* name) = NULL;

static char* hooked_getenv(const char* name) {
    if(isCallerTweak()) return orig_getenv(name);
    if(name) {
        if(strcmp(name, "DYLD_INSERT_LIBRARIES") == 0
        || strcmp(name, "DYLD_FORCE_FLAT_NAMESPACE") == 0
        || strcmp(name, "DYLD_SHARED_REGION") == 0
        || strcmp(name, "DYLD_SHARED_CACHE_DIR") == 0
        || strcmp(name, "DYLD_ROOT_PATH") == 0
        || strcmp(name, "DYLD_LIBRARY_PATH") == 0
        || strcmp(name, "DYLD_FRAMEWORK_PATH") == 0
        || strcmp(name, "DYLD_FALLBACK_LIBRARY_PATH") == 0
        || strcmp(name, "DYLD_FALLBACK_FRAMEWORK_PATH") == 0
        || strcmp(name, "LD_PRELOAD") == 0
        || strcmp(name, "CYDIA") == 0
        || strcmp(name, "Substrate") == 0
        || strcmp(name, "SileoClient") == 0
        || strcmp(name, "ZebraClient") == 0
        || strcmp(name, "_MSSafeMode") == 0
        || strcmp(name, "_SafeMode") == 0
        || strcmp(name, "_SubstituteSafeMode") == 0
        || strcmp(name, "Jailbreak") == 0
        || strcmp(name, "JB_ROOT") == 0
        || strcmp(name, "__XINA") == 0
        || strcmp(name, "CHOICY") == 0
        || strcmp(name, "PALERA1N") == 0) {
            return NULL;
        }
    }
    return orig_getenv(name);
}

void andromeda_hook_EnvVars(void) {
    for(NSString* envvar in [DetectionSignatures suspiciousEnvVars]) {
        unsetenv([envvar UTF8String]);
    }

    setenv("DYLD_INSERT_LIBRARIES", "", 1);
    setenv("DYLD_FORCE_FLAT_NAMESPACE", "0", 1);
    setenv("SHELL", "/bin/sh", 1);
    setenv("HOME", "/var/mobile", 1);
    setenv("USER", "mobile", 1);

    MSHookFunction((void*)getenv, (void*)hooked_getenv, (void**)&orig_getenv);

    DLog(@"Cleaned environment variables");
}
