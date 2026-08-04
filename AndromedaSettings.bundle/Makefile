include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:12.0

BUNDLE_NAME = AndromedaSettings
AndromedaSettings_FILES = RootListController.m
AndromedaSettings_FRAMEWORKS = UIKit
AndromedaSettings_INSTALL_PATH = /Library/PreferenceBundles
AndromedaSettings_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
