INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Andromeda

Andromeda_FILES = $(wildcard hooks/*.x) dylib.x
Andromeda_FRAMEWORKS = Foundation UIKit Security IOKit CoreTelephony SystemConfiguration CoreMotion CoreLocation
Andromeda_EXTRA_FRAMEWORKS = Andromeda
Andromeda_PRIVATE_FRAMEWORKS = MobileCoreServices MobileGestalt
Andromeda_CFLAGS = -fobjc-arc -I../Andromeda.framework/Headers
Andromeda_LDFLAGS = -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks -rpath /usr/lib -rpath /var/jb/usr/lib
Andromeda_LDFLAGS += -F../

include $(THEOS_MAKE_PATH)/tweak.mk
