#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

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

static NSSet* InstalledBundleIds(void) {
    id ws = LSWorkspace();
    if (!ws) return [NSSet set];
    NSMutableSet* set = [NSMutableSet set];
    NSArray* apps = [ws performSelector:@selector(allInstalledApplications)];
    for (id proxy in apps) {
        if ([proxy respondsToSelector:@selector(bundleIdentifier)]) {
            NSString* bid = [proxy performSelector:@selector(bundleIdentifier)];
            if (bid.length) [set addObject:bid];
        }
    }
    return set;
}

static void LaunchApp(NSString* bundleId) {
    void* handle = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    if (handle) {
        int (*SBSLaunchApplicationWithIdentifier)(NSString*, BOOL) =
            (int(*)(NSString*, BOOL))dlsym(handle, "SBSLaunchApplicationWithIdentifier");
        if (SBSLaunchApplicationWithIdentifier) {
            SBSLaunchApplicationWithIdentifier(bundleId, NO);
        }
    }
}

static NSMutableDictionary* LoadPrefs(void) {
    NSMutableDictionary* prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    if (!prefs) prefs = [NSMutableDictionary dictionary];
    return prefs;
}

static void SavePrefs(NSMutableDictionary* prefs) {
    [prefs writeToFile:@ANDROMEDA_PREFS atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.andromeda.bypass/settingsChanged"), NULL, NULL, YES);
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    id value = LoadPrefs()[key];
    if (!value) return @YES;
    return value;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString* key = [specifier propertyForKey:@"key"];
    if (!key) return;
    NSMutableDictionary* prefs = LoadPrefs();
    prefs[key] = value;
    SavePrefs(prefs);
}

- (NSArray*)specifiers {
    if(!_specifiers) {
        _specifiers = [NSMutableArray array];

        NSArray* datingApps = @[
            @[@"Tinder", @"com.cardify.tinder"],
            @[@"Bumble", @"com.bumble.app"],
            @[@"Hinge", @"co.hinge.app"],
            @[@"Hily", @"co.hily.app"],
            @[@"Badoo", @"com.badoo.badoo"],
            @[@"Fruitz", @"com.ftw-and-co.fruitz"],
            @[@"Feels", @"com.feels.Feels"],
            @[@"Happn", @"com.happn.happn"],
            @[@"Match", @"com.match.Match"],
            @[@"OkCupid", @"com.okcupid.okcupid"],
            @[@"POF", @"com.pof.pof"],
            @[@"Grindr", @"com.grindrapp.ios"],
            @[@"HER", @"com.weareher.HER"],
            @[@"Meetic", @"com.meetic.meetic"],
            @[@"AdopteUnMec", @"com.adopteunmec.ios"],
            @[@"Jaumo", @"com.jaumo.ios"],
            @[@"Tantan", @"com.tantan.ios"],
            @[@"Lovoo", @"com.lovoo.ios"],
            @[@"Boo", @"com.boo.app"],
            @[@"The League", @"com.theleague.ios"],
            @[@"Inner Circle", @"com.innercircle.ios"],
            @[@"Once", @"com.once.once"],
            @[@"Clover", @"com.clover.ios"]
        ];

        NSArray* socialApps = @[
            @[@"Instagram", @"com.burbn.instagram"],
            @[@"Threads", @"com.instagram.barcelona"],
            @[@"Facebook", @"com.facebook.Facebook"],
            @[@"Messenger", @"com.facebook.Messenger"],
            @[@"Snapchat", @"com.snapchat.Snapchat"],
            @[@"TikTok", @"com.zhiliaoapp.musically"],
            @[@"Twitter/X", @"com.atebits.Tweetie2"],
            @[@"Discord", @"com.hammerandchisel.discord"],
            @[@"Reddit", @"com.reddit.Reddit"],
            @[@"WhatsApp", @"net.whatsapp.WhatsApp"],
            @[@"Telegram", @"ph.telegra.Telegraph"],
            @[@"BeReal", @"com.bereal.ios"],
            @[@"LinkedIn", @"com.linkedin.LinkedIn"]
        ];

        NSSet* installed = InstalledBundleIds();

        NSMutableArray* detected = [NSMutableArray array];
        for(NSArray* app in datingApps) {
            if([installed containsObject:app[1]]) {
                [detected addObject:@{ @"name": app[0], @"bundleId": app[1] }];
            }
        }
        for(NSArray* app in socialApps) {
            if([installed containsObject:app[1]]) {
                [detected addObject:@{ @"name": app[0], @"bundleId": app[1] }];
            }
        }

        [_specifiers addObject:[self createGroupSpecifier:@"DETECTED" label:@"Detected Apps"]];
        if(detected.count == 0) {
            [_specifiers addObject:[self createNoteSpecifier:@"No supported apps detected on this device."]];
        } else {
            for(NSDictionary* app in detected) {
                [_specifiers addObject:[self createToggleSpecifier:app[@"name"] bundleId:app[@"bundleId"] installed:YES]];
            }
        }

        [_specifiers addObject:[self createGroupSpecifier:@"DATING_APPS" label:@"Dating Apps - All"]];
        for(NSArray* app in datingApps) {
            [_specifiers addObject:[self createToggleSpecifier:app[0] bundleId:app[1] installed:[installed containsObject:app[1]]]];
        }

        [_specifiers addObject:[self createGroupSpecifier:@"SOCIAL_APPS" label:@"Social Apps - All"]];
        for(NSArray* app in socialApps) {
            [_specifiers addObject:[self createToggleSpecifier:app[0] bundleId:app[1] installed:[installed containsObject:app[1]]]];
        }

        [_specifiers addObject:[self createGroupSpecifier:@"LAUNCH" label:@"Patch & Launch Detected Apps"]];
        if(detected.count == 0) {
            [_specifiers addObject:[self createNoteSpecifier:@"No installed apps to launch."]];
        } else {
            for(NSDictionary* app in detected) {
                PSSpecifier* specifier = [self createButtonSpecifier:app[@"name"] action:@selector(patchApp:) associatedObject:app[@"bundleId"]];
                [_specifiers addObject:specifier];
            }
        }
    }
    return _specifiers;
}

- (PSSpecifier*)createToggleSpecifier:(NSString*)title bundleId:(NSString*)bundleId installed:(BOOL)installed {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:title target:self
        set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:)
        detail:nil cell:PSSwitchCell edit:nil];
    [specifier setProperty:[@"App_" stringByAppendingString:bundleId] forKey:@"key"];
    if(!installed) {
        [specifier setProperty:@"Not installed" forKey:@"footerText"];
    }
    return specifier;
}

- (PSSpecifier*)createGroupSpecifier:(NSString*)key label:(NSString*)label {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:label target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    [specifier setProperty:key forKey:@"id"];
    return specifier;
}

- (PSSpecifier*)createNoteSpecifier:(NSString*)text {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:text target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
    return specifier;
}

- (PSSpecifier*)createButtonSpecifier:(NSString*)title action:(SEL)action associatedObject:(NSString*)bundleId {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:title target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
    [specifier setProperty:bundleId forKey:@"bundleId"];
    [specifier setButtonAction:action];
    return specifier;
}

- (void)patchApp:(PSSpecifier*)specifier {
    NSString* bundleId = [specifier propertyForKey:@"bundleId"];
    if(!bundleId) return;

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Patch & Launch"
        message:[NSString stringWithFormat:@"Launch %@ with Andromeda bypass patches active?", [specifier name]]
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Patch & Launch" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        LaunchApp(bundleId);
        NSLog(@"[Andromeda] Patched launch for %@", bundleId);
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Andromeda";
}

@end
