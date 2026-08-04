ARCHS ?= arm64
TARGET ?= iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Andromeda.dylib
SUBPROJECTS += AndromedaSettings.bundle

include $(THEOS_MAKE_PATH)/aggregate.mk
