#import "hooks.h"

static kern_return_t (*orig_bootstrap_look_up)(mach_port_t, const char*, mach_port_t*) = NULL;
static kern_return_t (*orig_bootstrap_look_up2)(mach_port_t, const char*, mach_port_t*, pid_t, uint64_t) = NULL;

static kern_return_t hooked_bootstrap_look_up(mach_port_t bp, const char* service_name, mach_port_t* sp) {
    if(service_name) {
        NSString* name = @(service_name);
        if([name containsString:@"cydia"]
        || [name containsString:@"sileo"]
        || [name containsString:@"substrate"]
        || [name containsString:@"substitute"]
        || [name containsString:@"jailbreak"]
        || [name containsString:@"rocketbootstrap"]
        || [name containsString:@"activator"]
        || [name containsString:@"ellekit"]
        || [name containsString:@"libhooker"]) {
            return BOOTSTRAP_SERVICE_NOT_ACTIVE;
        }
    }
    return orig_bootstrap_look_up(bp, service_name, sp);
}

static kern_return_t hooked_bootstrap_look_up2(mach_port_t bp, const char* service_name, mach_port_t* sp, pid_t target_pid, uint64_t flags) {
    if(service_name) {
        NSString* name = @(service_name);
        if([name containsString:@"cydia"]
        || [name containsString:@"sileo"]
        || [name containsString:@"substrate"]
        || [name containsString:@"substitute"]
        || [name containsString:@"jailbreak"]
        || [name containsString:@"rocketbootstrap"]
        || [name containsString:@"activator"]) {
            return BOOTSTRAP_SERVICE_NOT_ACTIVE;
        }
    }
    return orig_bootstrap_look_up2(bp, service_name, sp, target_pid, flags);
}

void andromeda_hook_MachBootstrap(void) {
    MSHookFunction((void*)bootstrap_look_up, (void*)hooked_bootstrap_look_up, (void**)&orig_bootstrap_look_up);
    MSHookFunction((void*)bootstrap_look_up2, (void*)hooked_bootstrap_look_up2, (void**)&orig_bootstrap_look_up2);
}
