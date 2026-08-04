include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = Andromeda
Andromeda_INSTALL_PATH = /Library/Frameworks

Andromeda_FILES = \
    Core.m \
    DetectionSignatures.m \
    DeviceFingerprintSpoofer.m

Andromeda_FRAMEWORKS = Foundation UIKit Security IOKit CoreTelephony SystemConfiguration
Andromeda_PRIVATE_FRAMEWORKS = MobileGestalt MobileCoreServices
Andromeda_CFLAGS = -fobjc-arc
Andromeda_LDFLAGS = -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk
