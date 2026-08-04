#import "hooks.h"

static int (*orig_stat)(const char *, struct stat *) = NULL;
static int (*orig_lstat)(const char *, struct stat *) = NULL;
static int (*orig_statfs)(const char *, struct statfs *) = NULL;
static int (*orig_access)(const char *, int) = NULL;
static int (*orig_open)(const char *, int, ...) = NULL;
static FILE* (*orig_fopen)(const char *, const char *) = NULL;
static struct dirent* (*orig_readdir)(DIR*) = NULL;
static int (*orig_fcntl)(int, int, ...) = NULL;
static int (*orig_mount)(const char *, const char *, int, void *) = NULL;
static int (*orig_truncate)(const char *, off_t) = NULL;
static int (*orig_unlink)(const char *) = NULL;
static int (*orig_rename)(const char *, const char *) = NULL;
static int (*orig_chmod)(const char *, mode_t) = NULL;
static int (*orig_chown)(const char *, uid_t, gid_t) = NULL;
static int (*orig_link)(const char *, const char *) = NULL;
static int (*orig_symlink)(const char *, const char *) = NULL;
static int (*orig_readlink)(const char *, char *, size_t) = NULL;
static int (*orig_mkdir)(const char *, mode_t) = NULL;
static int (*orig_rmdir)(const char *) = NULL;

static BOOL is_path_restricted(const char* path) {
    if(!path) return NO;
    NSString* nsPath = @(path);
    return [_andromeda isPathRestricted:nsPath];
}

static BOOL should_block(const char* path) {
    if(!path) return NO;
    if(path[0] != '/') return NO;
    if(strstr(path, "..") != NULL) return NO;
    return is_path_restricted(path);
}

static int hooked_stat(const char* path, struct stat* buf) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_stat(path, buf);
}

static int hooked_lstat(const char* path, struct stat* buf) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_lstat(path, buf);
}

static int hooked_statfs(const char* path, struct statfs* buf) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_statfs(path, buf);
}

static int hooked_access(const char* path, int mode) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_access(path, mode);
}

static int hooked_open(const char* path, int flags, ...) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    mode_t mode = 0;
    if(flags & O_CREAT) {
        va_list args;
        va_start(args, flags);
        mode = (mode_t)va_arg(args, int);
        va_end(args);
    }
    return orig_open(path, flags, mode);
}

static FILE* hooked_fopen(const char* path, const char* mode) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return NULL;
    }
    return orig_fopen(path, mode);
}

static struct dirent* hooked_readdir(DIR* dirp) {
    struct dirent* entry;
    while((entry = orig_readdir(dirp)) != NULL) {
        if(entry->d_name[0] == '.') {
            if(entry->d_name[1] == '\0') return entry;
            if(entry->d_name[1] == '.' && entry->d_name[2] == '\0') return entry;
        }
        NSString* name = @(entry->d_name);
        if([_andromeda isPathJailbreakRelated:name]) {
            continue;
        }
        return entry;
    }
    return NULL;
}

static int hooked_fcntl(int fd, int cmd, ...) {
    va_list args;
    va_start(args, cmd);
    void* arg = va_arg(args, void*);
    va_end(args);

    if(cmd == F_GETPATH && arg) {
        char* pathBuf = (char*)arg;
        int result = orig_fcntl(fd, cmd, arg);
        if(result == 0 && should_block(pathBuf)) {
            memset(pathBuf, 0, PATH_MAX);
            strncpy(pathBuf, "/private/var/mobile", PATH_MAX - 1);
        }
        return result;
    }
    return orig_fcntl(fd, cmd, arg);
}

static int hooked_mount(const char* type, const char* dir, int flags, void* data) {
    if(dir && should_block(dir)) {
        errno = EPERM;
        return -1;
    }
    return orig_mount(type, dir, flags, data);
}

static int hooked_truncate(const char* path, off_t length) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_truncate(path, length);
}

static int hooked_unlink(const char* path) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_unlink(path);
}

static int hooked_rename(const char* oldpath, const char* newpath) {
    if((oldpath && should_block(oldpath)) || (newpath && should_block(newpath))) {
        errno = ENOENT;
        return -1;
    }
    return orig_rename(oldpath, newpath);
}

static int hooked_chmod(const char* path, mode_t mode) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_chmod(path, mode);
}

static int hooked_chown(const char* path, uid_t uid, gid_t gid) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_chown(path, uid, gid);
}

static int hooked_link(const char* path1, const char* path2) {
    if((path1 && should_block(path1)) || (path2 && should_block(path2))) {
        errno = ENOENT;
        return -1;
    }
    return orig_link(path1, path2);
}

static int hooked_symlink(const char* path1, const char* path2) {
    if((path1 && should_block(path1)) || (path2 && should_block(path2))) {
        errno = ENOENT;
        return -1;
    }
    return orig_symlink(path1, path2);
}

static int hooked_readlink(const char* path, char* buf, size_t bufsize) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    int result = orig_readlink(path, buf, bufsize);
    if(result > 0 && buf) {
        buf[result] = '\0';
        if(should_block(buf)) {
            errno = ENOENT;
            return -1;
        }
    }
    return result;
}

static int hooked_mkdir(const char* path, mode_t mode) {
    if(path && should_block(path)) {
        errno = EPERM;
        return -1;
    }
    return orig_mkdir(path, mode);
}

static int hooked_rmdir(const char* path) {
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_rmdir(path);
}

void andromeda_hook_Filesystem(void) {
    @try {
    MSHookFunction((void*)stat, (void*)hooked_stat, (void**)&orig_stat);
    MSHookFunction((void*)lstat, (void*)hooked_lstat, (void**)&orig_lstat);
    MSHookFunction((void*)statfs, (void*)hooked_statfs, (void**)&orig_statfs);
    MSHookFunction((void*)access, (void*)hooked_access, (void**)&orig_access);
    MSHookFunction((void*)open, (void*)hooked_open, (void**)&orig_open);
    MSHookFunction((void*)fopen, (void*)hooked_fopen, (void**)&orig_fopen);
    MSHookFunction((void*)readdir, (void*)hooked_readdir, (void**)&orig_readdir);
    MSHookFunction((void*)fcntl, (void*)hooked_fcntl, (void**)&orig_fcntl);
    MSHookFunction((void*)mount, (void*)hooked_mount, (void**)&orig_mount);
    MSHookFunction((void*)truncate, (void*)hooked_truncate, (void**)&orig_truncate);
    MSHookFunction((void*)unlink, (void*)hooked_unlink, (void**)&orig_unlink);
    MSHookFunction((void*)rename, (void*)hooked_rename, (void**)&orig_rename);
    MSHookFunction((void*)chmod, (void*)hooked_chmod, (void**)&orig_chmod);
    MSHookFunction((void*)chown, (void*)hooked_chown, (void**)&orig_chown);
    MSHookFunction((void*)link, (void*)hooked_link, (void**)&orig_link);
    MSHookFunction((void*)symlink, (void*)hooked_symlink, (void**)&orig_symlink);
    MSHookFunction((void*)readlink, (void*)hooked_readlink, (void**)&orig_readlink);
    MSHookFunction((void*)mkdir, (void*)hooked_mkdir, (void**)&orig_mkdir);
    MSHookFunction((void*)rmdir, (void*)hooked_rmdir, (void**)&orig_rmdir);
    } @catch(NSException *e) { DLog(@"Filesystem hooks failed: %@", e); }
}

%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL*)isDirectory {
    if(path && [_andromeda isPathRestricted:path]) {
        if(isDirectory) *isDirectory = NO;
        return NO;
    }
    return %orig;
}

- (NSArray*)contentsOfDirectoryAtPath:(NSString*)path error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return @[];
    }
    NSArray* contents = %orig;
    if(!contents) return contents;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:contents.count];
    for(NSString* item in contents) {
        if(![_andromeda isPathJailbreakRelated:item]) {
            [filtered addObject:item];
        }
    }
    return [filtered copy];
}

- (NSArray*)subpathsOfDirectoryAtPath:(NSString*)path error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return @[];
    }
    NSArray* contents = %orig;
    if(!contents) return contents;
    NSMutableArray* filtered = [NSMutableArray arrayWithCapacity:contents.count];
    for(NSString* item in contents) {
        if(![_andromeda isPathJailbreakRelated:item]) {
            [filtered addObject:item];
        }
    }
    return [filtered copy];
}

- (NSArray*)contentsOfDirectoryAtURL:(NSURL*)url includingPropertiesForKeys:(NSArray*)keys options:(NSDirectoryEnumerationOptions)mask error:(NSError**)error {
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return @[];
    }
    return %orig;
}

- (NSDictionary*)attributesOfItemAtPath:(NSString*)path error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

- (NSDictionary*)attributesOfFileSystemForPath:(NSString*)path error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        return [self attributesOfFileSystemForPath:@"/var/mobile" error:error];
    }
    return %orig;
}

- (BOOL)isReadableFileAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isWritableFileAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isExecutableFileAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isDeletableFileAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)createDirectoryAtPath:(NSString*)path withIntermediateDirectories:(BOOL)intDir attributes:(NSDictionary*)attrs error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)copyItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)moveItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)removeItemAtPath:(NSString*)path error:(NSError**)error {
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)createSymbolicLinkAtPath:(NSString*)path withDestinationPath:(NSString*)destPath error:(NSError**)error {
    if((path && [_andromeda isPathRestricted:path]) || (destPath && [_andromeda isPathRestricted:destPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)linkItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (NSDirectoryEnumerator*)enumeratorAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (NSDirectoryEnumerator*)enumeratorAtURL:(NSURL*)url includingPropertiesForKeys:(NSArray*)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL*, NSError*))handler {
    if(url.path && [_andromeda isPathRestricted:url.path]) return nil;
    return %orig;
}

%end

%hook NSFileHandle

+ (id)fileHandleForReadingAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForWritingAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForUpdatingAtPath:(NSString*)path {
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForReadingFromURL:(NSURL*)url error:(NSError**)error {
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

+ (id)fileHandleForWritingToURL:(NSURL*)url error:(NSError**)error {
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

+ (id)fileHandleForUpdatingURL:(NSURL*)url error:(NSError**)error {
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

%end

%hook NSFileVersion
+ (NSArray*)otherVersionsOfItemAtURL:(NSURL*)url {
    if(url.path && [_andromeda isPathRestricted:url.path]) return @[];
    return %orig;
}
+ (NSArray*)unresolvedConflictVersionsOfItemAtURL:(NSURL*)url {
    if(url.path && [_andromeda isPathRestricted:url.path]) return @[];
    return %orig;
}
%end

%hook NSFileWrapper
- (instancetype)initWithURL:(NSURL*)url options:(NSFileWrapperReadingOptions)options error:(NSError**)error {
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}
%end

%ctor {
    @try { %init; } @catch(NSException *e) {}
}
