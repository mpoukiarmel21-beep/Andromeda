#import "hooks.h"

%hook UITouch

- (CGPoint)locationInView:(UIView*)view {
    CGPoint point = %orig;
    double randomOffsetX = ((double)(arc4random() % 100) - 50.0) / 10000.0;
    double randomOffsetY = ((double)(arc4random() % 100) - 50.0) / 10000.0;
    point.x += randomOffsetX;
    point.y += randomOffsetY;
    return point;
}

- (CGPoint)previousLocationInView:(UIView*)view {
    CGPoint point = %orig;
    double randomOffsetX = ((double)(arc4random() % 80) - 40.0) / 10000.0;
    double randomOffsetY = ((double)(arc4random() % 80) - 40.0) / 10000.0;
    point.x += randomOffsetX;
    point.y += randomOffsetY;
    return point;
}

- (NSTimeInterval)timestamp {
    NSTimeInterval ts = %orig;
    double jitter = ((double)(arc4random() % 50) - 25.0) / 1000000.0;
    return ts + jitter;
}

- (CGFloat)force {
    CGFloat f = %orig;
    if(f == 0) {
        f = 1.0 + ((double)(arc4random() % 200) / 1000.0);
    } else {
        f += ((double)(arc4random() % 100) - 50.0) / 10000.0;
    }
    return f;
}

- (CGFloat)maximumPossibleForce {
    return %orig;
}

%end

%hook UIEvent

- (NSTimeInterval)timestamp {
    NSTimeInterval ts = %orig;
    double jitter = ((double)(arc4random() % 100) - 50.0) / 1000000.0;
    return ts + jitter;
}

%end

%hook UIApplication

- (void)sendEvent:(UIEvent*)event {
    %orig;
}

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent*)event {
    return %orig;
}

%end

%hook UIGestureRecognizer

- (CGPoint)locationInView:(UIView*)view {
    CGPoint point = %orig;
    double randomOffsetX = ((double)(arc4random() % 60) - 30.0) / 10000.0;
    double randomOffsetY = ((double)(arc4random() % 60) - 30.0) / 10000.0;
    point.x += randomOffsetX;
    point.y += randomOffsetY;
    return point;
}

- (CGPoint)translationInView:(UIView*)view {
    CGPoint point = %orig;
    double randomOffsetX = ((double)(arc4random() % 40) - 20.0) / 10000.0;
    double randomOffsetY = ((double)(arc4random() % 40) - 20.0) / 10000.0;
    point.x += randomOffsetX;
    point.y += randomOffsetY;
    return point;
}

- (CGFloat)scale {
    CGFloat s = %orig;
    s += ((double)(arc4random() % 20) - 10.0) / 10000.0;
    return s;
}

- (CGFloat)rotation {
    CGFloat r = %orig;
    r += ((double)(arc4random() % 10) - 5.0) / 10000.0;
    return r;
}

%end

%hook UIPanGestureRecognizer

- (CGPoint)velocityInView:(UIView*)view {
    CGPoint velocity = %orig;
    velocity.x += ((double)(arc4random() % 100) - 50.0) / 100.0;
    velocity.y += ((double)(arc4random() % 100) - 50.0) / 100.0;
    return velocity;
}

%end

%hook UISwipeGestureRecognizer
- (CGPoint)locationInView:(UIView*)view {
    CGPoint point = %orig;
    point.x += ((double)(arc4random() % 40) - 20.0) / 10000.0;
    point.y += ((double)(arc4random() % 40) - 20.0) / 10000.0;
    return point;
}
%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_Behavioral(void) {}
