INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64
TARGET = iphone:clang:latest:15.0

TWEAK_NAME = Andromeda

Andromeda_FILES = $(wildcard hooks/*.x) dylib.x ../Andromeda.framework/Core.m ../Andromeda.framework/DetectionSignatures.m ../Andromeda.framework/DeviceFingerprintSpoofer.m
Andromeda_FRAMEWORKS = Foundation UIKit Security IOKit CoreTelephony SystemConfiguration CoreMotion CoreLocation
Andromeda_CFLAGS = -fobjc-arc -I.. -I../Andromeda.framework/Headers -Wno-unguarded-availability -Wno-deprecated-declarations
Andromeda_GO_EASY_ON_ME = 1
Andromeda_LDFLAGS = -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks -rpath /usr/lib -rpath /var/jb/usr/lib

include $(THEOS_MAKE_PATH)/tweak.mk
