INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_LEAN_AND_MEAN = 1
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FacebookCrashFix
FacebookCrashFix_FILES = Tweak.S
FacebookCrashFix_CFLAGS = -fobjc-arc
FacebookCrashFix_LIBRARIES = substrate objc

include $(THEOS_MAKE_PATH)/tweak.mk
