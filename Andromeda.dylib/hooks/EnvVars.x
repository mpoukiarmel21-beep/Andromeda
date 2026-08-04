#import "hooks.h"

void andromeda_hook_EnvVars(void) {
    for(NSString* envvar in [DetectionSignatures suspiciousEnvVars]) {
        unsetenv([envvar UTF8String]);
    }

    setenv("DYLD_INSERT_LIBRARIES", "", 1);
    setenv("DYLD_FORCE_FLAT_NAMESPACE", "0", 1);
    setenv("SHELL", "/bin/sh", 1);
    setenv("HOME", "/var/mobile", 1);
    setenv("USER", "mobile", 1);

    DLog(@"Cleaned environment variables");
}
