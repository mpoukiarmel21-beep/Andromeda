#import "hooks.h"

// ============================================================================
// ANDROMEDA FRIDA BYPASS — Détection et bypass de Frida/Substrate
// Cache Frida, Cycript, et autres outils de reverse engineering
// ============================================================================

// ============================================================================
// getenv — Bypass détection DYLD_INSERT_LIBRARIES
// ============================================================================

static char* (*orig_getenv)(const char*) = NULL;

static char* hooked_getenv(const char* name) {
    if(!isCallerTweak() && name) {
        // Apps vérifient DYLD_INSERT_LIBRARIES pour détecter Frida
        if(strstr(name, "DYLD_INSERT_LIBRARIES")
        || strstr(name, "DYLD_")
        || strstr(name, "_MSSafeMode")) {
            return NULL;
        }
    }
    return orig_getenv(name);
}

// ============================================================================
// setenv — Empêcher injection de variables d'environnement
// ============================================================================

static int (*orig_setenv)(const char*, const char*, int) = NULL;

static int hooked_setenv(const char* name, const char* value, int overwrite) {
    if(!isCallerTweak() && name) {
        if(strstr(name, "DYLD_INSERT_LIBRARIES")
        || strstr(name, "_MSSafeMode")) {
            return 0; // Silently succeed without setting
        }
    }
    return orig_setenv(name, value, overwrite);
}

// ============================================================================
// unsetenv — Empêcher retrait de variables critiques
// ============================================================================

static int (*orig_unsetenv)(const char*) = NULL;

static int hooked_unsetenv(const char* name) {
    if(!isCallerTweak() && name) {
        if(strstr(name, "DYLD_INSERT_LIBRARIES")) {
            return 0;
        }
    }
    return orig_unsetenv(name);
}

// ============================================================================
// dlopen — Bloquer chargement de libraries de détection
// ============================================================================

static int (*orig_dlopen)(const char*, int) = NULL;

static int hooked_dlopen(const char* path, int mode) {
    if(!isCallerTweak() && path) {
        if(strstr(path, "FridaGadget")
        || strstr(path, "frida-agent")
        || strstr(path, "frida")
        || strstr(path, "libcycript")
        || strstr(path, "cycript")
        || strstr(path, "SSLKillSwitch")
        || strstr(path, "sslkillswitch")
        || strstr(path, "SSLKiller")) {
            NSLog(@"[Andromeda] FridaBypass: Blocked dlopen of detection library: %s", path);
            return 0;
        }
    }
    return orig_dlopen(path, mode);
}

// ============================================================================
// dlsym — Bloquer résolution de symboles de détection
// ============================================================================

static void* (*orig_dlsym)(void*, const char*) = NULL;

static void* hooked_dlsym(void* handle, const char* symbol) {
    if(!isCallerTweak() && symbol) {
        // Bloquer symboles liés à Frida/détection
        if(strstr(symbol, "frida")
        || strstr(symbol, "Frida")
        || strstr(symbol, "FRIDA")
        || strstr(symbol, "cycript")
        || strstr(symbol, "Cycript")
        || strstr(symbol, "_frida")
        || strstr(symbol, "frida_agent")
        || strstr(symbol, "frida_gadget")) {
            return NULL;
        }
    }
    return orig_dlsym(handle, symbol);
}

// ============================================================================
// dladdr — Masquer l'adresse des symboles hooked
// ============================================================================

static int (*orig_dladdr)(const void*, Dl_info*) = NULL;

static int hooked_dladdr(const void* addr, Dl_info* info) {
    int result = orig_dladdr(addr, info);
    if(result && !isCallerTweak() && info) {
        // Si le symbole pointe vers une zone hookée, rediriger
        if(info->dli_fname && strstr(info->dli_fname, "FridaGadget")) {
            info->dli_fname = [[NSBundle mainBundle].executablePath fileSystemRepresentation];
            info->dli_sname = NULL;
            info->dli_fbase = (void*)[[NSBundle mainBundle].executablePath hash];
        }
    }
    return result;
}

// ============================================================================
// dlerror — Masquer les erreurs de détection
// ============================================================================

static char* (*orig_dlerror)(void) = NULL;

static char* hooked_dlerror(void) {
    return orig_dlerror();
}

// ============================================================================
// objc_getClass — Détecter Shadow et autres bypass tweaks
// ============================================================================

static Class (*orig_objc_getClass)(const char*) = NULL;

static Class hooked_objc_getClass(const char* name) {
    if(!isCallerTweak() && name) {
        // Bloquer la résolution de classes de bypass tweaks
        if(strstr(name, "ShadowRuleset")
        || strstr(name, "Shadow")
        || strstr(name, "ABypass")
        || strstr(name, "Liberty")
        || strstr(name, "LibertyLite")
        || strstr(name, "FlyJB")
        || strstr(name, "Choicy")
        || strstr(name, "HideJB")
        || strstr(name, "vnodebypass")
        || strstr(name, "kernbypass")
        || strstr(name, "A-Bypass")
        || strstr(name, "NotABypass")
        || strstr(name, "Hestia")
        || strstr(name, "RootlessHide")) {
            return nil;
        }
    }
    return orig_objc_getClass(name);
}

// ============================================================================
// Installation
// ============================================================================

void andromeda_hook_FridaBypass(void) {
    NSLog(@"[Andromeda] FridaBypass: Installing Frida/Substrate detection bypass...");

    // Environment variable hooks
    MSHookFunction((void*)getenv, (void*)hooked_getenv, (void**)&orig_getenv);
    MSHookFunction((void*)setenv, (void*)hooked_setenv, (void**)&orig_setenv);
    MSHookFunction((void*)unsetenv, (void*)hooked_unsetenv, (void**)&orig_unsetenv);
    NSLog(@"[Andromeda] FridaBypass: getenv/setenv/unsetenv hooked");

    // Dynamic linker hooks
    MSHookFunction((void*)dlopen, (void*)hooked_dlopen, (void**)&orig_dlopen);
    MSHookFunction((void*)dlsym, (void*)hooked_dlsym, (void**)&orig_dlsym);
    MSHookFunction((void*)dladdr, (void*)hooked_dladdr, (void**)&orig_dladdr);
    MSHookFunction((void*)dlerror, (void*)hooked_dlerror, (void**)&orig_dlerror);
    NSLog(@"[Andromeda] FridaBypass: dlopen/dlsym/dladdr/dlerror hooked");

    // objc_getClass hook to hide bypass tweaks
    orig_objc_getClass = (Class(*)(const char*))dlsym(RTLD_DEFAULT, "objc_getClass");
    if(orig_objc_getClass) {
        MSHookFunction((void*)orig_objc_getClass, (void*)hooked_objc_getClass, (void**)&orig_objc_getClass);
        NSLog(@"[Andromeda] FridaBypass: objc_getClass hooked");
    }

    NSLog(@"[Andromeda] FridaBypass: Installation complete");
}
