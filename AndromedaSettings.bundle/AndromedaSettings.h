#ifndef ANDROMEDA_SETTINGS_HELPER_H
#define ANDROMEDA_SETTINGS_HELPER_H

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#import "../common.h"

#define ANDROMEDA_FILTER_FILE "/var/mobile/Library/Preferences/com.andromeda.bypass.Filter.plist"

static inline NSDictionary* AndromedaSettingsLoadPrefs(void) {
    NSDictionary* prefs = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_PREFS];
    return [prefs isKindOfClass:[NSDictionary class]] ? prefs : @{};
}

static inline NSDictionary* AndromedaSettingsAppConfig(NSString* bundleId) {
    NSDictionary* perApp = AndromedaSettingsLoadPrefs()[@"PerApp"];
    if(![perApp isKindOfClass:[NSDictionary class]]) return @{};
    NSDictionary* cfg = perApp[bundleId];
    return [cfg isKindOfClass:[NSDictionary class]] ? cfg : @{};
}

static inline NSSet* AndromedaSettingsBaseBundleIds(void) {
    static NSSet* base = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        base = [NSSet setWithArray:@[
            @"com.cardify.tinder", @"co.hinge.app", @"com.moxco.bumble", @"com.bumble.bff",
            @"com.hily.ios", @"com.badoo.Badoo", @"com.flashgap.fruits", @"com.feels-app.feels",
            @"com.happn.happn", @"com.match.Match", @"com.pof.pof", @"com.eharmony.eharmony",
            @"com.okcupid.okcupid", @"com.zoosk.zoosk", @"com.lex.lex", @"com.grindrapp.ios",
            @"com.jackd.ios", @"com.scruff.scruff", @"com.weareher.HER", @"com.meetic.iphone",
            @"com.adopteunmec.ios", @"com.jaumo.ios", @"com.tantan.ios", @"com.lovoo.ios",
            @"com.hud.ios", @"com.turnup.app", @"com.boo.app", @"com.iris.dating",
            @"com.once.once", @"com.innercircle.ios", @"com.theleague.ios", @"com.clover.ios",
            @"com.burbn.instagram", @"com.instagram.barcelona", @"com.facebook.Facebook",
            @"com.facebook.Messenger", @"net.whatsapp.WhatsApp", @"com.snapchat.Snapchat",
            @"com.zhiliaoapp.musically", @"com.atebits.Tweetie2", @"com.bereal.ios",
            @"ph.telegra.Telegraph", @"org.whispersystems.signal", @"com.hammerandchisel.discord",
            @"com.reddit.Reddit", @"com.linkedin.LinkedIn"
        ]];
    });
    return base;
}

static inline NSDictionary* AndromedaSettingsReadFilter(void) {
    NSDictionary* filter = [NSDictionary dictionaryWithContentsOfFile:@ANDROMEDA_FILTER_FILE];
    if(!filter) {
        filter = [NSDictionary dictionaryWithContentsOfFile:[@(SUBSTRATE_PATH) stringByAppendingString:@"Andromeda.plist"]];
    }
    return [filter isKindOfClass:[NSDictionary class]] ? filter : @{};
}

static inline NSSet* AndromedaSettingsFilterBundleIds(void) {
    NSMutableSet* bids = [NSMutableSet set];
    NSArray* bundles = AndromedaSettingsReadFilter()[@"Filter"][@"Bundles"];
    if([bundles isKindOfClass:[NSArray class]]) {
        for(id bid in bundles) {
            if([bid isKindOfClass:[NSString class]] && ((NSString*)bid).length) [bids addObject:bid];
        }
    }
    return bids;
}

static inline BOOL AndromedaSettingsSyncFilter(void) {
    NSMutableSet* bids = [NSMutableSet setWithSet:AndromedaSettingsBaseBundleIds()];
    NSDictionary* perApp = AndromedaSettingsLoadPrefs()[@"PerApp"];
    if([perApp isKindOfClass:[NSDictionary class]]) {
        for(NSString* bid in perApp) {
            NSDictionary* cfg = perApp[bid];
            if(![cfg isKindOfClass:[NSDictionary class]]) continue;
            BOOL enabled = [cfg[@"enabled"] boolValue];
            if(enabled) {
                [bids addObject:bid];
            } else {
                [bids removeObject:bid];
            }
        }
    }
    NSDictionary* filter = @{
        @"Filter": @{
            @"Bundles": [[bids allObjects] sortedArrayUsingSelector:@selector(compare:)]
        }
    };
    BOOL ok = [filter writeToFile:@ANDROMEDA_FILTER_FILE atomically:YES];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.andromeda.bypass/filterChanged"), NULL, NULL, YES);
    return ok;
}

#endif
