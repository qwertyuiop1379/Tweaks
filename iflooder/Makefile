TARGET = iphone:clang:11.2:12.0
INSTALL_TARGET_PROCESSES = MobileSMS
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iFlooder

iFlooder_FILES = Tweak.x
iFlooder_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
