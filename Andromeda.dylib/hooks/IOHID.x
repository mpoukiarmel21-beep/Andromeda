#import "hooks.h"

%hook UIKeyboardImpl
- (BOOL)isAutoFillMode {
    return NO;
}
%end

%hook UIPasteboard
- (BOOL)hasStrings {
    return %orig;
}
- (NSInteger)changeCount {
    return %orig;
}
%end

%ctor {
    @try { %init; } @catch(NSException *e) {}
}

void andromeda_hook_IOHID(void) {}
