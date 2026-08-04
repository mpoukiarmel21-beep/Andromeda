#import "hooks.h"

static int (*orig_syscall)(int, ...) = NULL;
static int (*orig_execve)(const char*, char* const[], char* const[]) = NULL;
static int (*orig_posix_spawn)(pid_t* restrict, const char* restrict, const posix_spawn_file_actions_t* restrict, const posix_spawnattr_t* restrict, char* const argv[restrict], char* const envp[restrict]) = NULL;
static int (*orig_vfork)(void) = NULL;

static int hooked_syscall(int number, ...) {
    if(number == SYS_ptrace || number == SYS_fork || number == SYS_vfork) {
        DLog(@"Blocked syscall: %d", number);
        errno = EPERM;
        return -1;
    }
    if(number == SYS_csops) {
        DLog(@"Blocked syscall SYS_csops");
        errno = EINVAL;
        return -1;
    }

    va_list args;
    va_start(args, number);
    long a1 = va_arg(args, long);
    long a2 = va_arg(args, long);
    long a3 = va_arg(args, long);
    long a4 = va_arg(args, long);
    long a5 = va_arg(args, long);
    long a6 = va_arg(args, long);
    va_end(args);

    return orig_syscall(number, a1, a2, a3, a4, a5, a6);
}

static int hooked_execve(const char* path, char* const argv[], char* const envp[]) {
    if(isCallerTweak()) return orig_execve(path, argv, envp);
    DLog(@"Blocked execve: %s", path ? path : "(null)");
    errno = ENOENT;
    return -1;
}

static int hooked_posix_spawn(pid_t* restrict pid, const char* restrict path,
                              const posix_spawn_file_actions_t* restrict file_actions,
                              const posix_spawnattr_t* restrict attrp,
                              char* const argv[restrict], char* const envp[restrict]) {
    if(isCallerTweak()) return orig_posix_spawn(pid, path, file_actions, attrp, argv, envp);
    if(path) {
        DLog(@"Blocked posix_spawn: %s", path);
    }
    errno = ENOENT;
    return -1;
}

static int hooked_vfork(void) {
    if(isCallerTweak()) return orig_vfork();
    DLog(@"Blocked vfork");
    errno = EPERM;
    return -1;
}

void andromeda_hook_Syscall(void) {
    @try {
    MSHookFunction((void*)syscall, (void*)hooked_syscall, (void**)&orig_syscall);
    MSHookFunction((void*)execve, (void*)hooked_execve, (void**)&orig_execve);
    MSHookFunction((void*)posix_spawn, (void*)hooked_posix_spawn, (void**)&orig_posix_spawn);
    MSHookFunction((void*)vfork, (void*)hooked_vfork, (void**)&orig_vfork);
    } @catch(NSException *e) { DLog(@"Syscall hooks failed: %@", e); }
}
