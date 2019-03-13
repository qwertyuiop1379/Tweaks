include $(THEOS)/makefiles/common.mk
ARCHS = arm64

TWEAK_NAME = StatusColor
StatusColor_FILES = Tweak.xm
StatusColor_CLFAGS += -fobjc-arc
StatusColor_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += statuscolorprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
