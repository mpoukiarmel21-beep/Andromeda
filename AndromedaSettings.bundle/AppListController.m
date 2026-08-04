#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

@interface AndromedaAppListController : PSListController
@end

@implementation AndromedaAppListController

- (NSArray*)specifiers {
    if(!_specifiers) {
        _specifiers = [NSMutableArray array];
        
        [_specifiers addObject:[self createGroupSpecifier:@"DATING_APPS" label:@"Dating Apps - Per-App Toggle"]];
        
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
        
        for(NSArray* app in datingApps) {
            [_specifiers addObject:[self createToggleSpecifier:app[0] bundleId:app[1]]];
        }
        
        [_specifiers addObject:[self createGroupSpecifier:@"SOCIAL_APPS" label:@"Social Apps - Per-App Toggle"]];
        
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
        
        for(NSArray* app in socialApps) {
            [_specifiers addObject:[self createToggleSpecifier:app[0] bundleId:app[1]]];
        }
        
        [_specifiers addObject:[self createGroupSpecifier:@"LAUNCH" label:@"Patch & Launch Apps"]];
        
        for(NSArray* app in datingApps) {
            PSSpecifier* specifier = [self createButtonSpecifier:app[0] action:@selector(patchApp:) associatedObject:app[1]];
            [_specifiers addObject:specifier];
        }
        
        for(NSArray* app in socialApps) {
            PSSpecifier* specifier = [self createButtonSpecifier:app[0] action:@selector(patchApp:) associatedObject:app[1]];
            [_specifiers addObject:specifier];
        }
    }
    return _specifiers;
}

- (PSSpecifier*)createToggleSpecifier:(NSString*)title bundleId:(NSString*)bundleId {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:title target:self set:nil get:nil detail:nil cell:PSSwitchCell edit:nil];
    [specifier setProperty:@"com.andromeda.bypass" forKey:@"defaults"];
    [specifier setProperty:[@"App_" stringByAppendingString:bundleId] forKey:@"key"];
    [specifier setProperty:@YES forKey:@"default"];
    [specifier setProperty:@"com.andromeda.bypass/settingsChanged" forKey:@"PostNotification"];
    return specifier;
}

- (PSSpecifier*)createGroupSpecifier:(NSString*)key label:(NSString*)label {
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:label target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    [specifier setProperty:key forKey:@"id"];
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
    
    BOOL installed = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://", bundleId]]];
    
    if(!installed) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"App Not Found"
            message:[NSString stringWithFormat:@"%@ is not installed on this device.", [specifier name]]
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Patch & Launch"
        message:[NSString stringWithFormat:@"Launch %@ with Andromeda bypass patches active?", [specifier name]]
        preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Patch & Launch" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", bundleId]];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
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
