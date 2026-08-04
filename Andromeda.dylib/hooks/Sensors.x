#import "hooks.h"

%hook CMMotionManager

- (BOOL)isDeviceMotionAvailable {
    return YES;
}

- (BOOL)isAccelerometerAvailable {
    return YES;
}

- (BOOL)isGyroAvailable {
    return YES;
}

- (BOOL)isMagnetometerAvailable {
    return YES;
}

%end

%hook AVCaptureDevice

- (BOOL)hasFlash {
    return YES;
}

- (BOOL)hasTorch {
    return YES;
}

- (BOOL)isFlashAvailable {
    return YES;
}

%end

%hook CLLocationManager

+ (BOOL)locationServicesEnabled {
    return YES;
}

+ (CLAuthorizationStatus)authorizationStatus {
    return kCLAuthorizationStatusAuthorizedWhenInUse;
}

%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_Sensors(void) {}
