#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>

#import "../common.h"

@interface AndromedaAppListController : PSListController
@end

@implementation AndromedaAppListController

static id LSWorkspace(void) {
    static id ws = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dlopen("/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices", RTLD_LAZY);
        Class cls = NSClassFromString(@"LSApplicationWorkspace");
        if (cls) ws = [cls valueForKey:@"defaultWorkspace"];
    });
    return ws;
}

static UIImage* IconForProxy(id proxy) {
    SEL sel = NSSelectorFromString(@"iconDataForVariant:");
    if(![proxy respondsToSelector:sel]) return nil;
    id (*fn)(id, SEL, long) = (id (*)(id, SEL, long))[proxy methodForSelector:sel];
    for(long v = 1; v <= 4; v++) {
        NSData* data = fn(proxy, sel, v);
        if([data isKindOfClass:[NSData class]] && data.length) {
            UIImage* img = [UIImage imageWithData:data];
            if(img) return img;
        }
    }
    return nil;
}

static BOOL IsExcludedBundleId(NSString* bid) {
    static NSSet* prefixes = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        prefixes = [NSSet setWithArray:@[
            @"com.apple.", @"com.andromeda.", @"org.coolstar", @"me.jjolano", @"com.saurik"
        ]];
    });
    for(NSString* prefix in prefixes) {
        if([bid hasPrefix:prefix]) return YES;
    }
    return NO;
}

static NSArray* AppEntries(void) {
    id ws = LSWorkspace();
    if(!ws) return @[];
    NSArray* apps = [ws performSelector:@selector(allInstalledApplications)];
    NSMutableArray* entries = [NSMutableArray array];
    for(id proxy in apps) {
        if(![proxy respondsToSelector:@selector(bundleIdentifier)]) continue;
        NSString* bid = [proxy performSelector:@selector(bundleIdentifier)];
        if(!bid.length) continue;
        if(IsExcludedBundleId(bid)) continue;
        NSString* name = [proxy respondsToSelector:@selector(localizedName)] ? [proxy performSelector:@selector(localizedName)] : nil;
        if(!name.length) name = bid;
        UIImage* icon = IconForProxy(proxy);
        [entries addObject:@{
            @"name": name,
            @"bundleId": bid,
            @"icon": (icon ?: (id)[NSNull null])
        }];
    }
    [entries sortUsingComparator:^NSComparisonResult(NSDictionary* a, NSDictionary* b) {
        return [a[@"name"] localizedStandardCompare:b[@"name"]];
    }];
    return entries;
}

static NSDictionary* ConfigStatusByBid(void) {
    NSDictionary* prefs = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    NSDictionary* perApp = [prefs isKindOfClass:[NSDictionary class]] ? prefs[@"PerApp"] : nil;
    if(![perApp isKindOfClass:[NSDictionary class]]) return @{};
    NSMutableDictionary* status = [NSMutableDictionary dictionary];
    for(NSString* bid in perApp) {
        NSDictionary* cfg = perApp[bid];
        if([cfg isKindOfClass:[NSDictionary class]]) {
            id enabled = cfg[@"enabled"];
            status[bid] = (enabled && [enabled isKindOfClass:[NSNumber class]]) ? enabled : @NO;
        }
    }
    return status;
}

- (NSArray*)specifiers {
    if(!_specifiers) {
        NSMutableArray* arr = [NSMutableArray array];

        PSSpecifier* mainGroup = [PSSpecifier preferenceSpecifierNamed:@"Andromeda" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [arr addObject:mainGroup];

        PSSpecifier* globalLink = [PSSpecifier preferenceSpecifierNamed:@"Global Settings" target:self set:nil get:nil detail:NSClassFromString(@"AndromedaRootListController") cell:PSLinkCell edit:nil];
        [globalLink setProperty:@"Master switch, debug mode, log level." forKey:@"footerText"];
        [arr addObject:globalLink];

        NSArray* entries = AppEntries();
        NSDictionary* status = ConfigStatusByBid();

        PSSpecifier* appGroup = [PSSpecifier preferenceSpecifierNamed:@"Applications" target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
        [appGroup setProperty:@"All apps installed on this device. Tap an app to enable protection for it only and choose its bypass tools. A ✓ means protection is enabled for that app." forKey:@"footerText"];
        [arr addObject:appGroup];

        if(entries.count == 0) {
            [arr addObject:[PSSpecifier preferenceSpecifierNamed:@"No apps found." target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil]];
        } else {
            for(NSDictionary* entry in entries) {
                NSString* name = entry[@"name"];
                if([status[entry[@"bundleId"]] boolValue]) {
                    name = [name stringByAppendingString:@" ✓"];
                }
                PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:name target:self set:nil get:nil detail:NSClassFromString(@"AndromedaAppConfigController") cell:PSLinkCell edit:nil];
                [spec setProperty:entry[@"bundleId"] forKey:@"appBundleId"];
                [spec setProperty:entry[@"name"] forKey:@"appName"];
                UIImage* icon = entry[@"icon"];
                if([icon isKindOfClass:[UIImage class]]) {
                    [spec setProperty:icon forKey:@"iconImage"];
                }
                [arr addObject:spec];
            }
        }

        _specifiers = arr;
    }
    return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Andromeda";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _specifiers = nil;
    [self reloadSpecifiers];
}

@end
