#ifndef CODESIGN_H
#define CODESIGN_H

#include <sys/cdefs.h>

#define CS_OPS_STATUS       0
#define CS_OPS_MARKINVALID  1
#define CS_OPS_MARKHARD     2
#define CS_OPS_MARKKILL     3
#define CS_OPS_CDHASH       4
#define CS_OPS_PIDOFFSET    5
#define CS_OPS_ENTITLEMENTS_BLOB 7
#define CS_OPS_IDENTITY     8
#define CS_OPS_BLOB         9
#define CS_OPS_TEAMID       10

#define CS_KILL     0x00000200
#define CS_HARD     0x00000100
#define CS_VALID    0x00000002
#define CS_DEBUGGED 0x10000000
#define CS_GET_TASK_ALLOW   0x00000004
#define CS_INSTALLER        0x00000008
#define CS_PLATFORM_BINARY  0x04000000
#define CS_PLATFORM_PATH    0x00008000

__BEGIN_DECLS
int csops(pid_t pid, unsigned int ops, void *useraddr, size_t usersize);
int csops_audit_token(pid_t pid, unsigned int ops, void *useraddr, size_t usersize, audit_token_t *token);
__END_DECLS

#endif
