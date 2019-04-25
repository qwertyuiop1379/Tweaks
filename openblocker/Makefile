include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OpenBlocker
OpenBlocker_FILES = Tweak.xm
OpenBlocker_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += openblockerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
