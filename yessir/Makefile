export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Yessir
Yessir_FILES = Tweak.xm
Yessir_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
	
SUBPROJECTS += yessir
include $(THEOS_MAKE_PATH)/aggregate.mk
