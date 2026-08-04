#import "hooks.h"

static int (*orig_ptrace)(int, pid_t, caddr_t, int) = NULL;
static int (*orig_csops)(pid_t, unsigned int, void*, size_t) = NULL;
static int (*orig_sysctl)(int*, u_int, void*, size_t*, void*, size_t) = NULL;
static int (*orig_sysctlbyname)(const char*, void*, size_t*, void*, size_t) = NULL;
static pid_t (*orig_getppid)(void) = NULL;
static int (*orig_fork)(void) = NULL;
static int (*orig_kill)(pid_t, int) = NULL;
static kern_return_t (*orig_task_get_exception_ports)(task_t, exception_mask_t, exception_mask_array_t, mach_msg_type_number_t*, exception_handler_array_t, exception_behavior_array_t, exception_flavor_array_t) = NULL;
static kern_return_t (*orig_task_info)(task_t, task_flavor_t, task_info_t, mach_msg_type_number_t*) = NULL;

static int hooked_ptrace(int request, pid_t pid, caddr_t addr, int data) {
    if(request == PT_DENY_ATTACH || request == 31) {
        DLog(@"Blocked PT_DENY_ATTACH");
        return 0;
    }
    if(request == PT_ATTACH || request == 10) {
        DLog(@"Blocked PT_ATTACH");
        errno = EPERM;
        return -1;
    }
    return orig_ptrace(request, pid, addr, data);
}

static int hooked_csops(pid_t pid, unsigned int ops, void* useraddr, size_t usersize) {
    if(isCallerTweak()) return orig_csops(pid, ops, useraddr, usersize);
    int result = orig_csops(pid, ops, useraddr, usersize);
    if(result == 0 && pid == getpid() && ops == CS_OPS_STATUS && useraddr && usersize >= sizeof(uint32_t)) {
        uint32_t* flags = (uint32_t*)useraddr;
        *flags &= ~CS_DEBUGGED;
        *flags &= ~CS_KILL;
        *flags &= ~CS_HARD;
        *flags &= ~CS_GET_TASK_ALLOW;
        *flags |= CS_VALID;
        *flags |= CS_PLATFORM_BINARY;
    }
    return result;
}

static int hooked_sysctl(int* name, u_int namelen, void* oldp, size_t* oldlenp, void* newp, size_t newlen) {
    if(isCallerTweak()) return orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);
    int result = orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);
    if(result == 0 && oldp && oldlenp && namelen >= 4 && name[0] == CTL_KERN) {
        if(name[1] == KERN_PROC && name[2] == KERN_PROC_PID && name[3] == getpid()) {
            struct kinfo_proc* kp = (struct kinfo_proc*)oldp;
            kp->kp_proc.p_flag &= ~P_TRACED;
        }
    }
    return result;
}

static int hooked_sysctlbyname(const char* name, void* oldp, size_t* oldlenp, void* newp, size_t newlen) {
    if(isCallerTweak()) return orig_sysctlbyname(name, oldp, oldlenp, newp, newlen);
    if(name && strcmp(name, "kern.bootargs") == 0) {
        if(oldp && oldlenp) {
            const char* clean = "vm_compressor=2";
            size_t cleanLen = strlen(clean) + 1;
            if(*oldlenp >= cleanLen) {
                strcpy((char*)oldp, clean);
                *oldlenp = cleanLen;
            }
        }
        return 0;
    }
    int result = orig_sysctlbyname(name, oldp, oldlenp, newp, newlen);
    if(result == 0 && name && oldp && oldlenp) {
        if(strcmp(name, "hw.machine") == 0 || strcmp(name, "hw.model") == 0) {
            const char* spoofed = [_spoofer spoofedDeviceModel].UTF8String;
            size_t spoofedLen = strlen(spoofed) + 1;
            if(*oldlenp >= spoofedLen) {
                strcpy((char*)oldp, spoofed);
                *oldlenp = spoofedLen;
            }
        }
        else if(strcmp(name, "kern.osversion") == 0) {
            const char* spoofed = [_spoofer spoofedBuildVersion].UTF8String;
            size_t spoofedLen = strlen(spoofed) + 1;
            if(*oldlenp >= spoofedLen) {
                strcpy((char*)oldp, spoofed);
                *oldlenp = spoofedLen;
            }
        }
    }
    return result;
}

static pid_t hooked_getppid(void) {
    if(isCallerTweak()) return orig_getppid();
    return 1;
}

static int hooked_fork(void) {
    if(isCallerTweak()) return orig_fork();
    DLog(@"fork() blocked");
    errno = EPERM;
    return -1;
}

static int hooked_kill(pid_t pid, int sig) {
    return orig_kill(pid, sig);
}

static kern_return_t hooked_task_get_exception_ports(task_t task, exception_mask_t exception_mask, exception_mask_array_t masks, mach_msg_type_number_t* masksCnt, exception_handler_array_t old_handlers, exception_behavior_array_t old_behaviors, exception_flavor_array_t old_flavors) {
    if(!isCallerTweak()) {
        return KERN_FAILURE;
    }
    return orig_task_get_exception_ports(task, exception_mask, masks, masksCnt, old_handlers, old_behaviors, old_flavors);
}

static kern_return_t hooked_task_info(task_t task, task_flavor_t flavor, task_info_t info, mach_msg_type_number_t* count) {
    return orig_task_info(task, flavor, info, count);
}

void andromeda_hook_AntiDebug(void) {
    MSHookFunction((void*)ptrace, (void*)hooked_ptrace, (void**)&orig_ptrace);
    MSHookFunction((void*)csops, (void*)hooked_csops, (void**)&orig_csops);
    MSHookFunction((void*)sysctl, (void*)hooked_sysctl, (void**)&orig_sysctl);
    MSHookFunction((void*)sysctlbyname, (void*)hooked_sysctlbyname, (void**)&orig_sysctlbyname);
    MSHookFunction((void*)getppid, (void*)hooked_getppid, (void**)&orig_getppid);
    MSHookFunction((void*)fork, (void*)hooked_fork, (void**)&orig_fork);
    MSHookFunction((void*)kill, (void*)hooked_kill, (void**)&orig_kill);
    MSHookFunction((void*)task_get_exception_ports, (void*)hooked_task_get_exception_ports, (void**)&orig_task_get_exception_ports);
    MSHookFunction((void*)task_info, (void*)hooked_task_info, (void**)&orig_task_info);
}
