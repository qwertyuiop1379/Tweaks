include $(THEOS)/makefiles/common.mk

export GO_EASY_ON_ME = 1
export ARCHS = arm64

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += Tweak Preferences

include $(THEOS_MAKE_PATH)/aggregate.mk
