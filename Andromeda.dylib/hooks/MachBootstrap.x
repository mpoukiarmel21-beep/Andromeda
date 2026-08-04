#import "hooks.h"

#ifndef BOOTSTRAP_SERVICE_NOT_ACTIVE
#define BOOTSTRAP_SERVICE_NOT_ACTIVE 1
#endif

static kern_return_t (*orig_bootstrap_look_up)(mach_port_t, const char*, mach_port_t*) = NULL;

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

void andromeda_hook_MachBootstrap(void) {
    MSHookFunction((void*)bootstrap_look_up, (void*)hooked_bootstrap_look_up, (void**)&orig_bootstrap_look_up);
}
