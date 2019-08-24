export THEOS_INSTALL_USING_SSH=1
export ARCHS = arm64
export TARGET = iphone:clang:11.2:10.3.3
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Tweak PreferenceBundle Subprocess

include $(THEOS_MAKE_PATH)/aggregate.mk
