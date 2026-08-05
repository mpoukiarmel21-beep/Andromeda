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

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Andromeda/Tweaks$(ECHO_END)
	$(ECHO_NOTHING)install -m 755 ExtraTweaks/TinderAdvancedSpoofer.dylib ExtraTweaks/bhook.dylib ExtraTweaks/jbbypass.dylib $(THEOS_STAGING_DIR)/Library/Andromeda/Tweaks/$(ECHO_END)
