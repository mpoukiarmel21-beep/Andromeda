#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

%group hook_springboard

%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"[Andromeda] SpringBoard loaded OK");
    });
}
%end

%end

%ctor {
    NSLog(@"[Andromeda] ctor called");

    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if(!bundleIdentifier) return;

    if([bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        NSLog(@"[Andromeda] SpringBoard detected");
        %init(hook_springboard);
        return;
    }

    NSString* executablePath = [[NSBundle mainBundle] executablePath];
    if(!executablePath) return;

    if([executablePath hasPrefix:@"/Applications"]
    || [executablePath hasPrefix:@"/System"]
    || [executablePath hasPrefix:@"/private"]
    || [executablePath hasPrefix:@"/usr"]) {
        return;
    }

    if([bundleIdentifier hasPrefix:@"com.apple"]) return;

    NSLog(@"[Andromeda] Loaded in app: %@", bundleIdentifier);
}
