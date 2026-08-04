INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64
TARGET = iphone:clang:latest:15.0

TWEAK_NAME = Andromeda

Andromeda_FILES = $(wildcard hooks/*.x) dylib.x ../Andromeda.framework/Core.m ../Andromeda.framework/DetectionSignatures.m ../Andromeda.framework/DeviceFingerprintSpoofer.m ../Andromeda.framework/AdaptiveScanner.m
Andromeda_FRAMEWORKS = Foundation UIKit Security IOKit CoreTelephony SystemConfiguration CoreMotion CoreLocation
Andromeda_CFLAGS = -fobjc-arc -I.. -I../Andromeda.framework/Headers -Wno-unguarded-availability -Wno-deprecated-declarations
Andromeda_GO_EASY_ON_ME = 1
Andromeda_LDFLAGS = -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks -rpath /usr/lib -rpath /var/jb/usr/lib
Andromeda_FILTER_BUNDLES = com.apple.springboard com.cardify.tinder co.hinge.app com.bumble.app co.hily.app com.badoo.badoo com.ftw-and-co.fruitz com.feels.Feels com.happn.happn com.match.Match com.pof.pof com.eharmony.eharmony com.okcupid.okcupid com.zoosk.zoosk com.lex.lex com.grindrapp.ios com.burbn.instagram com.instagram.barcelona com.facebook.Facebook com.facebook.Messenger net.whatsapp.WhatsApp com.snapchat.Snapchat com.zhiliaoapp.musically com.atebits.Tweetie2 com.bereal.ios com.hammerandchisel.discord com.reddit.Reddit com.linkedin.LinkedIn com.meetic.meetic com.adopteunmec.ios com.jaumo.ios com.tantan.ios com.lovoo.ios com.hud.ios com.turnup.app com.boo.app com.iris.dating com.once.once com.innercircle.ios com.theleague.ios com.clover.ios

include $(THEOS_MAKE_PATH)/tweak.mk
