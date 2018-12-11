include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RomanKeypad
RomanKeypad_FILES = Tweak.xm
RomanKeypad_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += romankeypadprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
