include $(THEOS)/makefiles/common.mk
ARCHS = armv7s armv7 arm64

TWEAK_NAME = DockOutline
DockOutline_FILES = Tweak.xm
DockOutline_FRAMEWORKS = UIKit
DockOutline_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += dockoutlineprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
