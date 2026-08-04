include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0

FRAMEWORK_NAME = Andromeda
Andromeda_INSTALL_PATH = /Library/Frameworks

Andromeda_FILES = \
    Core.m \
    DetectionSignatures.m \
    DeviceFingerprintSpoofer.m

Andromeda_FRAMEWORKS = Foundation UIKit Security IOKit CoreTelephony SystemConfiguration
Andromeda_LDFLAGS = -rpath /Library/Frameworks -rpath /var/jb/Library/Frameworks

include $(THEOS_MAKE_PATH)/framework.mk
