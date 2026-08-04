ARCHS ?= arm64 arm64e
TARGET ?= iphone:clang:latest:12.0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Andromeda.framework
SUBPROJECTS += Andromeda.dylib
SUBPROJECTS += AndromedaSettings.bundle

include $(THEOS_MAKE_PATH)/aggregate.mk
