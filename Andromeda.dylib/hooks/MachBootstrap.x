#import "hooks.h"

#ifndef BOOTSTRAP_SERVICE_NOT_ACTIVE
#define BOOTSTRAP_SERVICE_NOT_ACTIVE 1
#endif

static kern_return_t (*orig_bootstrap_look_up)(mach_port_t, const char*, mach_port_t*) = NULL;
static kern_return_t (*orig_bootstrap_check_in)(mach_port_t, const char*, mach_port_t*) = NULL;

static BOOL is_blocked_service(const char* service_name) {
    if(!service_name) return NO;
    NSString* name = @(service_name);
    if([name hasPrefix:@"cy:"]
    || [name hasPrefix:@"lh:"]
    || [name hasPrefix:@"rbs:"]
    || [name hasPrefix:@"org.coolstar"]
    || [name hasPrefix:@"com.saurik"]
    || [name hasPrefix:@"com.opa334"]
    || [name containsString:@"sileo"]
    || [name containsString:@"substrate"]
    || [name containsString:@"substitute"]
    || [name containsString:@"jailbreak"]
    || [name containsString:@"rocketbootstrap"]
    || [name containsString:@"activator"]
    || [name containsString:@"ellekit"]
    || [name containsString:@"libhooker"]
    || [name containsString:@"cydia"]) {
        return YES;
    }
    return NO;
}

static kern_return_t hooked_bootstrap_look_up(mach_port_t bp, const char* service_name, mach_port_t* sp) {
    if(!isCallerTweak() && is_blocked_service(service_name)) {
        return BOOTSTRAP_SERVICE_NOT_ACTIVE;
    }
    return orig_bootstrap_look_up(bp, service_name, sp);
}

static kern_return_t hooked_bootstrap_check_in(mach_port_t bp, const char* service_name, mach_port_t* sp) {
    if(!isCallerTweak() && is_blocked_service(service_name)) {
        return BOOTSTRAP_SERVICE_NOT_ACTIVE;
    }
    return orig_bootstrap_check_in(bp, service_name, sp);
}

void andromeda_hook_MachBootstrap(void) {
    MSHookFunction((void*)bootstrap_look_up, (void*)hooked_bootstrap_look_up, (void**)&orig_bootstrap_look_up);
    MSHookFunction((void*)bootstrap_check_in, (void*)hooked_bootstrap_check_in, (void**)&orig_bootstrap_check_in);
}
