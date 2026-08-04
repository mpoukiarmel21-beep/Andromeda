#import "hooks.h"

static int (*orig_syscall)(int, ...) = NULL;

static int hooked_syscall(int number, ...) {
    if(number == SYS_ptrace || number == SYS_fork
    || number == SYS_vfork || number == SYS_rfork) {
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

void andromeda_hook_Syscall(void) {
    MSHookFunction((void*)syscall, (void*)hooked_syscall, (void**)&orig_syscall);
}
