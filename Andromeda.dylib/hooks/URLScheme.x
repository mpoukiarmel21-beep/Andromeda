#import "hooks.h"

%hook UIApplication

- (BOOL)canOpenURL:(NSURL*)url {
    if(url) {
        NSString* urlString = [url absoluteString];
        NSString* scheme = [[url scheme] lowercaseString];

        for(NSString* banned in [DetectionSignatures bannedURLSchemes]) {
            if([urlString hasPrefix:banned]) {
                DLog(@"Blocked URL scheme: %@", urlString);
                return NO;
            }
        }

        if(scheme) {
            for(NSString* banned in [DetectionSignatures bannedURLSchemes]) {
                NSString* bannedScheme = [banned stringByReplacingOccurrencesOfString:@"://" withString:@""];
                if([scheme isEqualToString:bannedScheme]) {
                    DLog(@"Blocked URL scheme: %@", scheme);
                    return NO;
                }
            }
        }
    }
    return %orig;
}

- (BOOL)openURL:(NSURL*)url {
    if(url) {
        NSString* urlString = [url absoluteString];
        for(NSString* banned in [DetectionSignatures bannedURLSchemes]) {
            if([urlString hasPrefix:banned]) {
                return NO;
            }
        }
    }
    return %orig;
}

- (void)openURL:(NSURL*)url options:(NSDictionary*)options completionHandler:(void (^)(BOOL))completion {
    if(url) {
        NSString* urlString = [url absoluteString];
        for(NSString* banned in [DetectionSignatures bannedURLSchemes]) {
            if([urlString hasPrefix:banned]) {
                if(completion) completion(NO);
                return;
            }
        }
    }
    %orig;
}

%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_URLScheme(void) {}
