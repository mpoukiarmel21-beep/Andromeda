#import "hooks.h"

%hook UIImage

+ (UIImage*)imageWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (id)initWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

%end

%hook NSData

+ (id)dataWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)dataWithContentsOfFile:(NSString*)path options:(NSDataReadingOptions)mask error:(NSError**)errorPtr {
    if(path && [_andromeda isPathRestricted:path]) {
        if(errorPtr) *errorPtr = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

+ (id)dataWithContentsOfURL:(NSURL*)url {
    if(url.path && [_andromeda isPathRestricted:url.path]) return nil;
    return %orig;
}

- (id)initWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (id)initWithContentsOfURL:(NSURL*)url {
    if(url.path && [_andromeda isPathRestricted:url.path]) return nil;
    return %orig;
}

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)atomically {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)writeToURL:(NSURL*)url atomically:(BOOL)atomically {
    if(url.path && [_andromeda isPathRestricted:url.path]) return NO;
    return %orig;
}

%end

%hook NSDictionary

+ (id)dictionaryWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (id)initWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)atomically {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

%end

%hook NSArray

+ (id)arrayWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (id)initWithContentsOfFile:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)atomically {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

%end

%hook NSString

+ (id)stringWithContentsOfFile:(NSString*)path encoding:(NSStringEncoding)enc error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

- (id)initWithContentsOfFile:(NSString*)path encoding:(NSStringEncoding)enc error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

- (BOOL)writeToFile:(NSString*)path atomically:(BOOL)atomically encoding:(NSStringEncoding)enc error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

%end

%hook NSURL

- (id)initFileURLWithPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileURLWithPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

%end

%hook NSThread

+ (NSArray*)callStackReturnAddresses {
    NSArray* stack = %orig;
    if(isCallerTweak() || !stack) return stack;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:stack.count];
    for(NSNumber* addr in stack) {
        if(![_andromeda isAddrExternal:(void*)[addr unsignedLongLongValue]]) {
            [filtered addObject:addr];
        }
    }
    return [filtered copy];
}

+ (NSArray*)callStackSymbols {
    NSArray* symbols = %orig;
    if(isCallerTweak() || !symbols) return symbols;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:symbols.count];
    for(NSString* sym in symbols) {
        BOOL suspicious = NO;
        for(NSString* s in [DetectionSignatures suspiciousDylibNames]) {
            if([sym rangeOfString:s options:NSCaseInsensitiveSearch].location != NSNotFound) {
                suspicious = YES;
                break;
            }
        }
        if(!suspicious) {
            [filtered addObject:sym];
        }
    }
    return [filtered copy];
}

%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}

void andromeda_hook_UIImage(void) {}
