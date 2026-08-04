#import "hooks.h"

static FILE* (*orig_fopen)(const char*, const char*) = NULL;

static FILE* hooked_proc_fopen(const char* path, const char* mode) {
    if(path) {
        NSString* p = @(path);
        if([p hasPrefix:@"/proc"]) {
            for(NSString* suspicious in [DetectionSignatures suspiciousProcFiles]) {
                if([p isEqualToString:suspicious]) {
                    errno = ENOENT;
                    return NULL;
                }
            }
        }
    }
    return orig_fopen(path, mode);
}

void andromeda_hook_ProcFiles(void) {
    MSHookFunction((void*)fopen, (void*)hooked_proc_fopen, (void**)&orig_fopen);
}
