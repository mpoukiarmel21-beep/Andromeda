#import "hooks.h"
#import <Andromeda.h>

void andromeda_hook_Adaptive(void) {
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleID) return;

    NSLog(@"[Andromeda Adaptive] Starting adaptive scan for %@", bundleID);

    [[AdaptiveScanner sharedInstance] scanAndHookTargetAppWithCompletion:^(NSArray<NSString *> *selectors, NSArray<NSString *> *classes) {
        NSLog(@"[Andromeda Adaptive] Completed for %@: %lu selectors, %lu classes",
              bundleID,
              (unsigned long)selectors.count,
              (unsigned long)classes.count);
    }];
}
