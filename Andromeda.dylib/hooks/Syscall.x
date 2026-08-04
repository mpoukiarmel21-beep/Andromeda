#import "hooks.h"

// Syscall-level hooks were removed for stability.
// Hooking syscall() and blocking fork/vfork/execve/posix_spawn
// for the whole process caused crashes in target applications.
// ptrace/csops anti-debug is handled by the AntiDebug hook.

void andromeda_hook_Syscall(void) {}
