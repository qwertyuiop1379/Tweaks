INSTALL_TARGET_PROCESSES = MobilePhone
TARGET = iphone:clang::13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PhoneRedesign

PhoneRedesign_FILES = Tweak.x
PhoneRedesign_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
