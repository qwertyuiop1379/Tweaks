include $(THEOS)/makefiles/common.mk
ARCHS = armv7 armv7s arm64

BUNDLE_NAME = zeppelicator
zeppelicator_FILES = ZEPRootListController.m
zeppelicator_INSTALL_PATH = /Library/PreferenceBundles
zeppelicator_FRAMEWORKS = UIKit
zeppelicator_PRIVATE_FRAMEWORKS = Preferences
zeppelicator_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/zeppelicator.plist$(ECHO_END)
