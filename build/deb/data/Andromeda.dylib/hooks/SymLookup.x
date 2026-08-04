#import "hooks.h"

static void* (*orig_dlsym)(void*, const char*) = NULL;

static void* hooked_dlsym_filter(void* handle, const char* symbol) {
    if(isCallerTweak()) return orig_dlsym(handle, symbol);

    if(symbol) {
        if(strncmp(symbol, "MSHook", 6) == 0
        || strncmp(symbol, "SubHook", 7) == 0
        || strncmp(symbol, "fishhook_", 9) == 0
        || strncmp(symbol, "rebind_symbols", 14) == 0
        || strncmp(symbol, "LHHook", 6) == 0
        || strncmp(symbol, "substitute_", 11) == 0
        || strcmp(symbol, "objc_setHook_getClass") == 0
        || strcmp(symbol, "MSHookFunction") == 0
        || strcmp(symbol, "MSHookMessageEx") == 0
        || strcmp(symbol, "MSFindSymbol") == 0
        || strcmp(symbol, "MSGetImageByName") == 0) {
            return NULL;
        }
    }
    return orig_dlsym(handle, symbol);
}

void andromeda_hook_SymLookup(void) {
    MSHookFunction((void*)dlsym, (void*)hooked_dlsym_filter, (void**)&orig_dlsym);
}
