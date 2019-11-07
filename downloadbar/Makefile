INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64
TARGET = iphone:clang:11.2:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DownloadBar
DownloadBar_FILES = Tweak.x
DownloadBar_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
