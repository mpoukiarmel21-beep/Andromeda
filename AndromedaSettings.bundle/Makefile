include $(THEOS)/makefiles/common.mk

THEOS_PACKAGE_SCHEME = rootless
ARCHS = arm64
TARGET = iphone:clang:latest:15.0

BUNDLE_NAME = AndromedaSettings
AndromedaSettings_FILES = RootListController.m
AndromedaSettings_FRAMEWORKS = UIKit Foundation
AndromedaSettings_INSTALL_PATH = /var/jb/Library/PreferenceBundles
AndromedaSettings_CFLAGS = -fobjc-arc
AndromedaSettings_LDFLAGS = -Wl,-undefined,dynamic_lookup

include $(THEOS_MAKE_PATH)/bundle.mk

after-bundle-stage::
	@mkdir -p $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle
	@cp -f $(THEOS_PROJECT_DIR)/Resources/icon.png \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/icon.png 2>/dev/null || true
	@cp -f $(THEOS_PROJECT_DIR)/Resources/icon@2x.png \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/icon@2x.png 2>/dev/null || true
	@cp -f $(THEOS_PROJECT_DIR)/Resources/logo.png \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/logo.png 2>/dev/null || true
	@cp -rf $(THEOS_PROJECT_DIR)/Resources/Icons \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/ 2>/dev/null || true
	@mkdir -p $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/fr.lproj
	@cp -f $(THEOS_PROJECT_DIR)/fr.lproj/Localizable.strings \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/fr.lproj/ 2>/dev/null || true
	@mkdir -p $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/en.lproj
	@cp -f $(THEOS_PROJECT_DIR)/en.lproj/Localizable.strings \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/en.lproj/ 2>/dev/null || true
	@mkdir -p $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/es.lproj
	@cp -f $(THEOS_PROJECT_DIR)/es.lproj/Localizable.strings \
	      $(THEOS_STAGING_DIR)/var/jb/Library/PreferenceBundles/AndromedaSettings.bundle/es.lproj/ 2>/dev/null || true

