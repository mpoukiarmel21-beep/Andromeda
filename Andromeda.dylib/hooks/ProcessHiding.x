#import "hooks.h"

// ============================================================================
// ANDROMEDA PROCESS HIDING — Masquage de processus jailbreak
// Cache les processus frida-server, substrate, etc. de KERN_PROC_ALL
// ============================================================================

static int (*orig_sysctl)(int*, u_int, void*, size_t*, void*, size_t) = NULL;

static BOOL isJBProcess(const char* name) {
    if(!name) return NO;
    if(strstr(name, "frida")
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
        || strstr(name, "sslkillswitch")) {
        return YES;
    }

    NSArray* extraProcs = andromeda_extraList(@"Proc_ExtraProcesses");
    for(NSString* proc in extraProcs) {
        if(strcasestr(name, [proc UTF8String])) {
            return YES;
        }
    }

    NSArray* dbProcs = [DetectionSignatures suspiciousProcessNames];
    for(NSString* proc in dbProcs) {
        if(strcasestr(name, [proc UTF8String])) {
            return YES;
        }
    }
    return NO;
}

static int hooked_sysctl(int* name, u_int namelen, void* oldp, size_t* oldlenp, void* newp, size_t newlen) {
    int result = orig_sysctl(name, namelen, oldp, oldlenp, newp, newlen);

    if(isCallerTweak()) return result;
    if(result != 0) return result;
    if(!oldp || !oldlenp) return result;

    size_t elemSize = sizeof(struct kinfo_proc);
    if(elemSize == 0) return result;

    // KERN_PROC_ALL — filter out jailbreak-related processes
    if(namelen == 2 && name[0] == CTL_KERN && name[1] == KERN_PROC) {
        size_t origCount = *oldlenp / elemSize;
        struct kinfo_proc* procs = (struct kinfo_proc*)oldp;

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
        if(*oldlenp >= elemSize) {
            struct kinfo_proc* kp = (struct kinfo_proc*)oldp;
            if(isJBProcess(kp->kp_proc.p_comm)) {
                memset(oldp, 0, *oldlenp);
                *oldlenp = 0;
                return ENOENT;
            }
        }
    }

    return result;
}

void andromeda_hook_ProcessHiding(void) {
    NSLog(@"[Andromeda] ProcessHiding: Installing process hiding system...");
    MSHookFunction((void*)sysctl, (void*)hooked_sysctl, (void**)&orig_sysctl);
    NSLog(@"[Andromeda] ProcessHiding: sysctl hooked");
}
