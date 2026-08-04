#import "hooks.h"

// ============================================================================
// ANDROMEDA PROCESS HIDING — Masquage de processus jailbreak
// Cache les processus frida-server, substrate, etc. de KERN_PROC_ALL
// ============================================================================

// ============================================================================
// sysctl KERN_PROCALL — Filtrage des processus
// ============================================================================

static int (*orig_sysctl)(int*, u_int, void*, size_t*, void*, size_t) = NULL;

static BOOL isJBProcess(const char* name) {
    if(!name) return NO;
    return strstr(name, "frida")
        || strstr(name, "Frida")
        || strstr(name, "substrate")
        || strstr(name, "Substrate")
        || strstr(name, "cycript")
        || strstr(name, "Cycript")
        || strstr(name, "ssh")
        || strstr(name, "sshd")
        || strstr(name, "dropbear")
        || strstr(name, "sftp")
        || strstr(name, "scp")
        || strstr(name, "dpkg")
        || strstr(name, "apt-get")
        || strstr(name, "Cydia")
        || strstr(name, "cydia")
        || strstr(name, "Sileo")
        || strstr(name, "sileo")
        || strstr(name, "Zebra")
        || strstr(name, "zebra")
        || strstr(name, "filza")
        || strstr(name, "Filza")
        || strstr(name, "newterm")
        || strstr(name, "mterminal")
        || strstr(name, "androguard")
        || strstr(name, "SSLKillSwitch")
        || strstr(name, "sslkillswitch");
}

// struct kinfo_proc layout for filtering
struct andromeda_kinfo_proc {
    struct proc {
        int p_flag;
        int p_stat;
        pid_t p_pid;
        char p_comm[17];
    } kp_proc;
};

static int hooked_sysctl(int* name, u_int namelen, void* oldp, size_t* oldlenp, void* newp, size_t newlen) {
    int result = orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);

    if(isCallerTweak()) return result;
    if(result != 0) return result;

    // KERN_PROC_ALL
    if(namelen == 2 && name[0] == CTL_KERN && name[1] == KERN_PROC) {
        if(!oldp || !oldlenp) return result;

        size_t elemSize = sizeof(struct andromeda_kinfo_proc);
        size_t origCount = *oldlenp / elemSize;
        struct andromeda_kinfo_proc* procs = (struct andromeda_kinfo_proc*)oldp;

        size_t writeIdx = 0;
        for(size_t i = 0; i < origCount; i++) {
            if(!isJBProcess(procs[i].kp_proc.p_comm)) {
                if(writeIdx != i) {
                    procs[writeIdx] = procs[i];
                }
                writeIdx++;
            }
        }

        *oldlenp = writeIdx * elemSize;
    }

    // KERN_PROC_PID — individual process query
    if(namelen == 3 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
        if(!oldp || !oldlenp) return result;
        if(*oldlenp >= sizeof(struct andromeda_kinfo_proc)) {
            struct andromeda_kinfo_proc* kp = (struct andromeda_kinfo_proc*)oldp;
            if(isJBProcess(kp->kp_proc.p_comm)) {
                memset(oldp, 0, *oldlenp);
                *oldlenp = 0;
                return ENOENT;
            }
        }
    }

    return result;
}

// ============================================================================
// task_info — Masquage dyld info (cachent les images chargées)
// ============================================================================

static kern_return_t (*orig_task_info)(task_name_t, task_flavor_t, task_info_t, mach_msg_type_number_t*) = NULL;

// Minimal layout de dyld_all_image_infos pour le spoof
struct andromeda_dyld_all_image_infos {
    uint32_t version;
    uint32_t infoArrayCount;
    uint64_t infoArray;
    uint64_t notification;
    bool processDetachedFromSharedRegion;
    bool libSystemInitialized;
    const struct mach_header* dyldImageLoadAddress;
    uint64_t dyldVersion;
    uint64_t errorMessage;
    uint64_t terminationFlags;
    uint64_t coreSymbolicationShmPage;
    uint64_t systemOrderFlag;
    uint64_t uuidArrayCount;
    uint64_t uuidArray;
};

static kern_return_t hooked_task_info(task_name_t target_task, task_flavor_t flavor,
                                       task_info_t task_info_out,
                                       mach_msg_type_number_t* task_info_outCnt) {
    kern_return_t result = orig_task_info(target_task, flavor, task_info_out, task_info_outCnt);

    if(isCallerTweak()) return result;

    if(flavor == TASK_DYLD_INFO && result == KERN_SUCCESS && target_task == mach_task_self()) {
        struct task_dyld_info* info = (struct task_dyld_info*)task_info_out;
        struct andromeda_dyld_all_image_infos* dyldInfo =
            (struct andromeda_dyld_all_image_infos*)(uintptr_t)info->all_image_info_addr;
        if(dyldInfo) {
            // Réduire le nombre d'images visibles
            dyldInfo->infoArrayCount = 1;
            dyldInfo->uuidArrayCount = 1;
        }
    }

    return result;
}

// ============================================================================
// Installation
// ============================================================================

void andromeda_hook_ProcessHiding(void) {
    NSLog(@"[Andromeda] ProcessHiding: Installing process hiding system...");

    // sysctl KERN_PROC_ALL filtering
    MSHookFunction((void*)sysctl, (void*)hooked_sysctl, (void**)&orig_sysctl);
    NSLog(@"[Andromeda] ProcessHiding: sysctl hooked");

    // task_info dyld info spoof
    MSHookFunction((void*)task_info, (void*)hooked_task_info, (void**)&orig_task_info);
    NSLog(@"[Andromeda] ProcessHiding: task_info hooked");

    NSLog(@"[Andromeda] ProcessHiding: Installation complete");
}
