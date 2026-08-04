#import "hooks.h"

static int (*orig_stat)(const char *, struct stat *) = NULL;
static int (*orig_lstat)(const char *, struct stat *) = NULL;
static int (*orig_fstat)(int, struct stat *) = NULL;
static int (*orig_statfs)(const char *, struct statfs *) = NULL;
static int (*orig_getfsstat)(struct statfs *, int, int) = NULL;
static int (*orig_getmntinfo)(struct statfs **, int) = NULL;
static int (*orig_access)(const char *, int) = NULL;
static int (*orig_open)(const char *, int, ...) = NULL;
static int (*orig_openat)(int, const char *, int, ...) = NULL;
static int (*orig_faccessat)(int, const char *, int, int) = NULL;
static int (*orig_fstatat)(int, const char *, struct stat *, int) = NULL;
static int (*orig_statvfs)(const char *, struct statvfs *) = NULL;
static int (*orig_fstatvfs)(int, struct statvfs *) = NULL;
static int (*orig_getattrlist)(const char *, struct attrlist *, void *, size_t, unsigned long) = NULL;
static int (*orig_mkdir)(const char *, mode_t) = NULL;
static int (*orig_rmdir)(const char *) = NULL;
static int (*orig_unlink)(const char *) = NULL;
static int (*orig_unlinkat)(int, const char *, int) = NULL;
static int (*orig_rename)(const char *, const char *) = NULL;
static int (*orig_chmod)(const char *, mode_t) = NULL;
static int (*orig_chown)(const char *, uid_t, gid_t) = NULL;
static int (*orig_link)(const char *, const char *) = NULL;
static int (*orig_symlink)(const char *, const char *) = NULL;
static int (*orig_readlink)(const char *, char *, size_t) = NULL;
static int (*orig_readlinkat)(int, const char *, char *, size_t) = NULL;
static int (*orig_truncate)(const char *, off_t) = NULL;
static int (*orig_ftruncate)(int, off_t) = NULL;
static int (*orig_creat)(const char *, mode_t) = NULL;
static int (*orig_chdir)(const char *) = NULL;
static int (*orig_fchdir)(int) = NULL;
static int (*orig_pathconf)(const char *, int) = NULL;
static int (*orig_fpathconf)(int, int) = NULL;
static int (*orig_utimes)(const char *, const struct timeval [2]) = NULL;
static int (*orig_futimes)(int, const struct timeval [2]) = NULL;
static int (*orig_fcntl)(int, int, ...) = NULL;
static int (*orig_mount)(const char *, const char *, int, void *) = NULL;
static int (*orig_fopen)(const char *, const char *) = NULL;
static int (*orig_freopen)(const char *, const char *, FILE *) = NULL;
static FILE *(*orig___opendir2)(const char *, size_t) = NULL;
static struct dirent *(*orig_readdir)(DIR*) = NULL;
static int (*orig_readdir_r)(DIR *dirp, struct dirent *entry, struct dirent **oresult) = NULL;
static char *(*orig_realpath)(const char *, char *) = NULL;

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
    if(isCallerTweak()) return orig_stat(path, buf);
    if(path && should_block(path)) {
        if(buf) memset(buf, 0, sizeof(struct stat));
        errno = ENOENT;
        return -1;
    }
    return orig_stat(path, buf);
}

static int hooked_lstat(const char* path, struct stat* buf) {
    if(isCallerTweak()) return orig_lstat(path, buf);
    if(path && should_block(path)) {
        if(buf) memset(buf, 0, sizeof(struct stat));
        errno = ENOENT;
        return -1;
    }
    return orig_lstat(path, buf);
}

static int hooked_fstat(int fd, struct stat* buf) {
    if(isCallerTweak()) return orig_fstat(fd, buf);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            if(buf) memset(buf, 0, sizeof(struct stat));
            errno = EBADF;
            return -1;
        }
    }
    return orig_fstat(fd, buf);
}

static int hooked_statvfs(const char* path, struct statvfs* buf) {
    if(isCallerTweak()) return orig_statvfs(path, buf);
    if(path && should_block(path)) {
        if(buf) memset(buf, 0, sizeof(struct statvfs));
        errno = ENOENT;
        return -1;
    }
    return orig_statvfs(path, buf);
}

static int hooked_fstatvfs(int fd, struct statvfs* buf) {
    if(isCallerTweak()) return orig_fstatvfs(fd, buf);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            if(buf) memset(buf, 0, sizeof(struct statvfs));
            errno = EBADF;
            return -1;
        }
    }
    return orig_fstatvfs(fd, buf);
}
static int hooked_statfs(const char* path, struct statfs* buf) {
    if(isCallerTweak()) return orig_statfs(path, buf);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    int result = orig_statfs(path, buf);
    if(result == 0 && buf) {
        if(should_block(buf->f_mntfromname)) {
            strcpy(buf->f_mntfromname, "/dev/disk1s1");
        }
        if(should_block(buf->f_mntonname)) {
            strcpy(buf->f_mntonname, "/");
        }
        if(strcmp(buf->f_mntonname, "/") == 0) {
            buf->f_flags |= MNT_RDONLY | MNT_ROOTFS | MNT_SNAPSHOT;
        }
    }
    return result;
}

static int hooked_getfsstat(struct statfs* buf, int bufsize, int flags) {
    if(isCallerTweak()) return orig_getfsstat(buf, bufsize, flags);
    int result = orig_getfsstat(buf, bufsize, flags);
    if(result != -1 && buf) {
        struct statfs* ptr = buf;
        struct statfs* end = buf + result;
        while(ptr < end) {
            if(should_block(ptr->f_mntonname)) {
                strcpy(ptr->f_mntonname, "/");
            }
            if(strcmp(ptr->f_mntonname, "/") == 0) {
                ptr->f_flags |= MNT_RDONLY | MNT_ROOTFS | MNT_SNAPSHOT;
                break;
            }
            ptr++;
        }
    }
    return result;
}

static int hooked_getmntinfo(struct statfs** mntbufp, int flags) {
    if(isCallerTweak()) return orig_getmntinfo(mntbufp, flags);
    int result = orig_getmntinfo(mntbufp, flags);
    if(result > 0) {
        struct statfs** ptr = mntbufp;
        struct statfs** end = mntbufp + result;
        while(ptr < end) {
            if(should_block((*ptr)->f_mntonname)) {
                strcpy((*ptr)->f_mntonname, "/");
            }
            if(strcmp((*ptr)->f_mntonname, "/") == 0) {
                (*ptr)->f_flags |= MNT_RDONLY | MNT_ROOTFS | MNT_SNAPSHOT;
                break;
            }
            ptr++;
        }
    }
    return result;
}

static int hooked_access(const char* path, int mode) {
    if(isCallerTweak()) return orig_access(path, mode);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_access(path, mode);
}
static int hooked_open(const char* path, int flags, ...) {
    if(isCallerTweak()) {
        mode_t mode = 0;
        if(flags & O_CREAT) {
            va_list args;
            va_start(args, flags);
            mode = (mode_t)va_arg(args, int);
            va_end(args);
        }
        return orig_open(path, flags, mode);
    }
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

static int hooked_openat(int dirfd, const char* path, int flags, ...) {
    if(isCallerTweak()) {
        mode_t mode = 0;
        if(flags & O_CREAT) {
            va_list args;
            va_start(args, flags);
            mode = (mode_t)va_arg(args, int);
            va_end(args);
        }
        return orig_openat(dirfd, path, flags, mode);
    }
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
    return orig_openat(dirfd, path, flags, mode);
}

static int hooked_faccessat(int dirfd, const char* path, int mode, int flags) {
    if(isCallerTweak()) return orig_faccessat(dirfd, path, mode, flags);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_faccessat(dirfd, path, mode, flags);
}

static int hooked_fstatat(int dirfd, const char* path, struct stat* buf, int flags) {
    if(isCallerTweak()) return orig_fstatat(dirfd, path, buf, flags);
    if(path && should_block(path)) {
        if(buf) memset(buf, 0, sizeof(struct stat));
        errno = ENOENT;
        return -1;
    }
    return orig_fstatat(dirfd, path, buf, flags);
}
static int hooked_getattrlist(const char* path, struct attrlist* attrList, void* attrBuf, size_t attrBufSize, unsigned long options) {
    if(isCallerTweak()) return orig_getattrlist(path, attrList, attrBuf, attrBufSize, options);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_getattrlist(path, attrList, attrBuf, attrBufSize, options);
}

static FILE* hooked_fopen(const char* path, const char* mode) {
    if(isCallerTweak()) return orig_fopen(path, mode);
    if(path && should_block(path)) {
        errno = ENOENT;
        return NULL;
    }
    return orig_fopen(path, mode);
}

static FILE* hooked_freopen(const char* path, const char* mode, FILE* stream) {
    if(isCallerTweak()) return orig_freopen(path, mode, stream);
    if(path && should_block(path)) {
        errno = ENOENT;
        return NULL;
    }
    return orig_freopen(path, mode, stream);
}

static FILE* hooked___opendir2(const char* path, size_t bufsize) {
    if(isCallerTweak() || !path || !should_block(path)) {
        return orig___opendir2(path, bufsize);
    }
    errno = ENOENT;
    return NULL;
}

static struct dirent* hooked_readdir(DIR* dirp) {
    if(isCallerTweak()) return orig_readdir(dirp);
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
static int hooked_readdir_r(DIR* dirp, struct dirent* entry, struct dirent** oresult) {
    if(isCallerTweak()) return orig_readdir_r(dirp, entry, oresult);
    int result = orig_readdir_r(dirp, entry, oresult);
    if(result == 0 && *oresult) {
        if((*oresult)->d_name[0] == '.') {
            if((*oresult)->d_name[1] == '\0') return result;
            if((*oresult)->d_name[1] == '.' && (*oresult)->d_name[2] == '\0') return result;
        }
        NSString* name = @((*oresult)->d_name);
        if([_andromeda isPathJailbreakRelated:name]) {
            return orig_readdir_r(dirp, entry, oresult);
        }
    }
    return result;
}

static char* hooked_realpath(const char* path, char* resolved_path) {
    char* result = orig_realpath(path, resolved_path);
    if(result && !isCallerTweak() && should_block(path)) {
        errno = ENOENT;
        return NULL;
    }
    return result;
}

static int hooked_fcntl(int fd, int cmd, ...) {
    va_list args;
    va_start(args, cmd);
    void* arg = va_arg(args, void*);
    va_end(args);

    if(isCallerTweak()) return orig_fcntl(fd, cmd, arg);

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
    if(isCallerTweak()) return orig_mount(type, dir, flags, data);
    if(dir && should_block(dir)) {
        errno = EPERM;
        return -1;
    }
    return orig_mount(type, dir, flags, data);
}

static int hooked_truncate(const char* path, off_t length) {
    if(isCallerTweak()) return orig_truncate(path, length);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_truncate(path, length);
}

static int hooked_ftruncate(int fd, off_t length) {
    if(isCallerTweak()) return orig_ftruncate(fd, length);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            errno = EBADF;
            return -1;
        }
    }
    return orig_ftruncate(fd, length);
}
static int hooked_unlink(const char* path) {
    if(isCallerTweak()) return orig_unlink(path);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_unlink(path);
}

static int hooked_unlinkat(int dirfd, const char* path, int flags) {
    if(isCallerTweak()) return orig_unlinkat(dirfd, path, flags);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_unlinkat(dirfd, path, flags);
}

static int hooked_rename(const char* oldpath, const char* newpath) {
    if(isCallerTweak()) return orig_rename(oldpath, newpath);
    if((oldpath && should_block(oldpath)) || (newpath && should_block(newpath))) {
        errno = ENOENT;
        return -1;
    }
    return orig_rename(oldpath, newpath);
}

static int hooked_chmod(const char* path, mode_t mode) {
    if(isCallerTweak()) return orig_chmod(path, mode);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_chmod(path, mode);
}

static int hooked_chown(const char* path, uid_t uid, gid_t gid) {
    if(isCallerTweak()) return orig_chown(path, uid, gid);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_chown(path, uid, gid);
}

static int hooked_link(const char* path1, const char* path2) {
    if(isCallerTweak()) return orig_link(path1, path2);
    if((path1 && should_block(path1)) || (path2 && should_block(path2))) {
        errno = ENOENT;
        return -1;
    }
    return orig_link(path1, path2);
}

static int hooked_symlink(const char* path1, const char* path2) {
    if(isCallerTweak()) return orig_symlink(path1, path2);
    if((path1 && should_block(path1)) || (path2 && should_block(path2))) {
        errno = ENOENT;
        return -1;
    }
    return orig_symlink(path1, path2);
}
static int hooked_readlink(const char* path, char* buf, size_t bufsize) {
    if(isCallerTweak()) return orig_readlink(path, buf, bufsize);
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

static int hooked_readlinkat(int dirfd, const char* path, char* buf, size_t bufsize) {
    if(isCallerTweak()) return orig_readlinkat(dirfd, path, buf, bufsize);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    int result = orig_readlinkat(dirfd, path, buf, bufsize);
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
    if(isCallerTweak()) return orig_mkdir(path, mode);
    if(path && should_block(path)) {
        errno = EPERM;
        return -1;
    }
    return orig_mkdir(path, mode);
}

static int hooked_rmdir(const char* path) {
    if(isCallerTweak()) return orig_rmdir(path);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_rmdir(path);
}

static int hooked_creat(const char* path, mode_t mode) {
    if(isCallerTweak()) return orig_creat(path, mode);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_creat(path, mode);
}

static int hooked_chdir(const char* path) {
    if(isCallerTweak()) return orig_chdir(path);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_chdir(path);
}

static int hooked_fchdir(int fd) {
    if(isCallerTweak()) return orig_fchdir(fd);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            errno = EBADF;
            return -1;
        }
    }
    return orig_fchdir(fd);
}
static long hooked_pathconf(const char* path, int name) {
    if(isCallerTweak()) return orig_pathconf(path, name);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_pathconf(path, name);
}

static long hooked_fpathconf(int fd, int name) {
    if(isCallerTweak()) return orig_fpathconf(fd, name);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            errno = EBADF;
            return -1;
        }
    }
    return orig_fpathconf(fd, name);
}

static int hooked_utimes(const char* path, const struct timeval times[2]) {
    if(isCallerTweak()) return orig_utimes(path, times);
    if(path && should_block(path)) {
        errno = ENOENT;
        return -1;
    }
    return orig_utimes(path, times);
}

static int hooked_futimes(int fd, const struct timeval times[2]) {
    if(isCallerTweak()) return orig_futimes(fd, times);
    if(fd != fileno(stderr) && fd != fileno(stdout) && fd != fileno(stdin)) {
        char pathname[PATH_MAX];
        if(fcntl(fd, F_GETPATH, pathname) != -1 && should_block(pathname)) {
            errno = EBADF;
            return -1;
        }
    }
    return orig_futimes(fd, times);
}

void andromeda_hook_Filesystem(void) {
    @try {
    MSHookFunction((void*)stat, (void*)hooked_stat, (void**)&orig_stat);
    MSHookFunction((void*)lstat, (void*)hooked_lstat, (void**)&orig_lstat);
    MSHookFunction((void*)fstat, (void*)hooked_fstat, (void**)&orig_fstat);
    MSHookFunction((void*)statvfs, (void*)hooked_statvfs, (void**)&orig_statvfs);
    MSHookFunction((void*)fstatvfs, (void*)hooked_fstatvfs, (void**)&orig_fstatvfs);
    MSHookFunction((void*)statfs, (void*)hooked_statfs, (void**)&orig_statfs);
    MSHookFunction((void*)access, (void*)hooked_access, (void**)&orig_access);
    MSHookFunction((void*)open, (void*)hooked_open, (void**)&orig_open);
    MSHookFunction((void*)openat, (void*)hooked_openat, (void**)&orig_openat);
    MSHookFunction((void*)faccessat, (void*)hooked_faccessat, (void**)&orig_faccessat);
    MSHookFunction((void*)fstatat, (void*)hooked_fstatat, (void**)&orig_fstatat);
    MSHookFunction((void*)getattrlist, (void*)hooked_getattrlist, (void**)&orig_getattrlist);
    MSHookFunction((void*)fopen, (void*)hooked_fopen, (void**)&orig_fopen);
    MSHookFunction((void*)freopen, (void*)hooked_freopen, (void**)&orig_freopen);
    MSHookFunction((void*)readdir, (void*)hooked_readdir, (void**)&orig_readdir);
    MSHookFunction((void*)readdir_r, (void*)hooked_readdir_r, (void**)&orig_readdir_r);
    MSHookFunction((void*)fcntl, (void*)hooked_fcntl, (void**)&orig_fcntl);
    MSHookFunction((void*)mount, (void*)hooked_mount, (void**)&orig_mount);
    MSHookFunction((void*)truncate, (void*)hooked_truncate, (void**)&orig_truncate);
    MSHookFunction((void*)ftruncate, (void*)hooked_ftruncate, (void**)&orig_ftruncate);
    MSHookFunction((void*)unlink, (void*)hooked_unlink, (void**)&orig_unlink);
    MSHookFunction((void*)unlinkat, (void*)hooked_unlinkat, (void**)&orig_unlinkat);
    MSHookFunction((void*)rename, (void*)hooked_rename, (void**)&orig_rename);
    MSHookFunction((void*)chmod, (void*)hooked_chmod, (void**)&orig_chmod);
    MSHookFunction((void*)chown, (void*)hooked_chown, (void**)&orig_chown);
    MSHookFunction((void*)link, (void*)hooked_link, (void**)&orig_link);
    MSHookFunction((void*)symlink, (void*)hooked_symlink, (void**)&orig_symlink);
    MSHookFunction((void*)readlink, (void*)hooked_readlink, (void**)&orig_readlink);
    MSHookFunction((void*)readlinkat, (void*)hooked_readlinkat, (void**)&orig_readlinkat);
    MSHookFunction((void*)mkdir, (void*)hooked_mkdir, (void**)&orig_mkdir);
    MSHookFunction((void*)rmdir, (void*)hooked_rmdir, (void**)&orig_rmdir);
    MSHookFunction((void*)creat, (void*)hooked_creat, (void**)&orig_creat);
    MSHookFunction((void*)chdir, (void*)hooked_chdir, (void**)&orig_chdir);
    MSHookFunction((void*)fchdir, (void*)hooked_fchdir, (void**)&orig_fchdir);
    MSHookFunction((void*)pathconf, (void*)hooked_pathconf, (void**)&orig_pathconf);
    MSHookFunction((void*)fpathconf, (void*)hooked_fpathconf, (void**)&orig_fpathconf);
    MSHookFunction((void*)utimes, (void*)hooked_utimes, (void**)&orig_utimes);
    MSHookFunction((void*)futimes, (void*)hooked_futimes, (void**)&orig_futimes);
    void* sym_getfsstat = dlsym(RTLD_DEFAULT, "getfsstat");
    if(sym_getfsstat && !orig_getfsstat) {
        MSHookFunction(sym_getfsstat, (void*)hooked_getfsstat, (void**)&orig_getfsstat);
    }
    void* sym_getmntinfo = dlsym(RTLD_DEFAULT, "getmntinfo");
    if(sym_getmntinfo && !orig_getmntinfo) {
        MSHookFunction(sym_getmntinfo, (void*)hooked_getmntinfo, (void**)&orig_getmntinfo);
    }
    void* sym_realpath = dlsym(RTLD_DEFAULT, "realpath");
    if(sym_realpath && !orig_realpath) {
        MSHookFunction(sym_realpath, (void*)hooked_realpath, (void**)&orig_realpath);
    }
    void* sym_opendir2 = dlsym(RTLD_DEFAULT, "__opendir2");
    if(sym_opendir2 && !orig___opendir2) {
        MSHookFunction(sym_opendir2, (void*)hooked___opendir2, (void**)&orig___opendir2);
    }
    } @catch(NSException *e) { DLog(@"Filesystem hooks failed: %@", e); }
}
%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL*)isDirectory {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        if(isDirectory) *isDirectory = NO;
        return NO;
    }
    return %orig;
}

- (NSArray*)contentsOfDirectoryAtPath:(NSString*)path error:(NSError**)error {
    if(isCallerTweak()) return %orig;
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
    if(isCallerTweak()) return %orig;
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
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return @[];
    }
    return %orig;
}

- (NSDictionary*)attributesOfItemAtPath:(NSString*)path error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

- (NSDictionary*)attributesOfFileSystemForPath:(NSString*)path error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        return [self attributesOfFileSystemForPath:@"/var/mobile" error:error];
    }
    return %orig;
}

- (BOOL)isReadableFileAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isWritableFileAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isExecutableFileAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)isDeletableFileAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return NO;
    return %orig;
}

- (BOOL)createDirectoryAtPath:(NSString*)path withIntermediateDirectories:(BOOL)intDir attributes:(NSDictionary*)attrs error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)copyItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)moveItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)removeItemAtPath:(NSString*)path error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)createSymbolicLinkAtPath:(NSString*)path withDestinationPath:(NSString*)destPath error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if((path && [_andromeda isPathRestricted:path]) || (destPath && [_andromeda isPathRestricted:destPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (BOOL)linkItemAtPath:(NSString*)srcPath toPath:(NSString*)dstPath error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if((srcPath && [_andromeda isPathRestricted:srcPath]) || (dstPath && [_andromeda isPathRestricted:dstPath])) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return NO;
    }
    return %orig;
}

- (NSDirectoryEnumerator*)enumeratorAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

- (NSDirectoryEnumerator*)enumeratorAtURL:(NSURL*)url includingPropertiesForKeys:(NSArray*)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL*, NSError*))handler {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) return nil;
    return %orig;
}

%end
%hook NSFileHandle

+ (id)fileHandleForReadingAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForWritingAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForUpdatingAtPath:(NSString*)path {
    if(isCallerTweak()) return %orig;
    if(path && [_andromeda isPathRestricted:path]) return nil;
    return %orig;
}

+ (id)fileHandleForReadingFromURL:(NSURL*)url error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

+ (id)fileHandleForWritingToURL:(NSURL*)url error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

+ (id)fileHandleForUpdatingURL:(NSURL*)url error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}

%end

%hook NSFileVersion
+ (NSArray*)otherVersionsOfItemAtURL:(NSURL*)url {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) return @[];
    return %orig;
}
+ (NSArray*)unresolvedConflictVersionsOfItemAtURL:(NSURL*)url {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) return @[];
    return %orig;
}
%end

%hook NSFileWrapper
- (instancetype)initWithURL:(NSURL*)url options:(NSFileWrapperReadingOptions)options error:(NSError**)error {
    if(isCallerTweak()) return %orig;
    if(url.path && [_andromeda isPathRestricted:url.path]) {
        if(error) *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadNoPermissionError userInfo:nil];
        return nil;
    }
    return %orig;
}
%end

%ctor {
    @try {
        if(andromeda_isProtectedProcess()) {
            %init;
        }
    } @catch(NSException *e) {}
}
