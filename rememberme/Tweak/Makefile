include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RememberMe
RememberMe_FILES = Tweak.xm
RememberMe_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
