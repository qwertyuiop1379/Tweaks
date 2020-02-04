INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64
TARGET = iphone:clang:11.2:11.0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Garfield
Garfield_FILES = Tweak.x
Garfield_CFLAGS = -fobjc-arc
Garfield_FRAMEWORKS = AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk
