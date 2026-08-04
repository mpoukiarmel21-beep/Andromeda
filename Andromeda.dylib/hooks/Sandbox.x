#import "hooks.h"

static int (*orig_sandbox_check)(pid_t, const char*, int, ...) = NULL;
static int (*orig_sandbox_check_by_audit_token)(audit_token_t, const char*, int, ...) = NULL;

static int hooked_sandbox_check(pid_t pid, const char* operation, int type, ...) {
    if(operation) {
        NSString* op = @(operation);

        if([op isEqualToString:@"file-read-data"]
        || [op isEqualToString:@"file-read-metadata"]
        || [op isEqualToString:@"file-write-data"]
        || [op isEqualToString:@"file-write-create"]
        || [op isEqualToString:@"file-write-mode"]) {
            va_list args;
            va_start(args, type);
            const char* path = va_arg(args, const char*);
            va_end(args);

            if(path && [_andromeda isPathRestricted:@(path)]) {
                return 0;
            }
            return orig_sandbox_check(pid, operation, type, path);
        }

        if([op isEqualToString:@"mach-lookup"]
        || [op isEqualToString:@"mach-register"]) {
            va_list args;
            va_start(args, type);
            const char* serviceName = va_arg(args, const char*);
            va_end(args);

            if(serviceName) {
                NSString* name = @(serviceName);
                if([name containsString:@"cydia"]
                || [name containsString:@"sileo"]
                || [name containsString:@"substrate"]
                || [name containsString:@"substitute"]
                || [name containsString:@"jailbreak"]
                || [name containsString:@"rocketbootstrap"]
                || [name containsString:@"activator"]) {
                    return 0;
                }
            }
            return orig_sandbox_check(pid, operation, type, serviceName);
        }

        if([op isEqualToString:@"process-exec"]) {
            va_list args;
            va_start(args, type);
            const char* path = va_arg(args, const char*);
            va_end(args);
            if(path && [_andromeda isPathRestricted:@(path)]) {
                return 0;
            }
            return orig_sandbox_check(pid, operation, type, path);
        }
    }

    va_list args;
    va_start(args, type);
    const char* arg1 = va_arg(args, const char*);
    va_end(args);
    return orig_sandbox_check(pid, operation, type, arg1);
}

static int hooked_sandbox_check_by_audit_token(audit_token_t token, const char* operation, int type, ...) {
    if(operation) {
        NSString* op = @(operation);
        if([op isEqualToString:@"file-read-data"]
        || [op isEqualToString:@"file-write-data"]
        || [op isEqualToString:@"file-read-metadata"]) {
            va_list args;
            va_start(args, type);
            const char* path = va_arg(args, const char*);
            va_end(args);
            if(path && [_andromeda isPathRestricted:@(path)]) {
                return 0;
            }
            return orig_sandbox_check_by_audit_token(token, operation, type, path);
        }
    }
    va_list args;
    va_start(args, type);
    const char* arg1 = va_arg(args, const char*);
    va_end(args);
    return orig_sandbox_check_by_audit_token(token, operation, type, arg1);
}

void andromeda_hook_Sandbox(void) {
    MSHookFunction((void*)sandbox_check, (void*)hooked_sandbox_check, (void**)&orig_sandbox_check);
    MSHookFunction((void*)sandbox_check_by_audit_token, (void*)hooked_sandbox_check_by_audit_token, (void**)&orig_sandbox_check_by_audit_token);
}
