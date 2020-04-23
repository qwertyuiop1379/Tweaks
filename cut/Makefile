INSTALL_TARGET_PROCESSES = MobileSMS
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cut
Cut_FILES = Tweak.x
Cut_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += cut
include $(THEOS_MAKE_PATH)/aggregate.mk
