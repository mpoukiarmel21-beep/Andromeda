include $(THEOS)/makefiles/common.mk

THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64
TARGET = iphone:clang:latest:15.0

BUNDLE_NAME = AndromedaSettings
AndromedaSettings_FILES = RootListController.m
AndromedaSettings_FRAMEWORKS = UIKit
AndromedaSettings_INSTALL_PATH = /var/jb/Library/PreferenceBundles
AndromedaSettings_CFLAGS = -fobjc-arc
AndromedaSettings_LDFLAGS = -Wl,-undefined,dynamic_lookup

include $(THEOS_MAKE_PATH)/bundle.mk

