include $(THEOS)/makefiles/common.mk

TOOL_NAME = _ldrestart

_ldrestart_FILES = main.m
_ldrestart_CFLAGS = -fobjc-arc
_ldrestart_CODESIGN_FLAGS = -S../../platform.plist

include $(THEOS_MAKE_PATH)/tool.mk

internal-stage::
	$(ECHO_NOTHING)chmod +s $(THEOS_STAGING_DIR)/usr/bin/_ldrestart$(ECHO_END)
