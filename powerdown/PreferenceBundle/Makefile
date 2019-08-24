include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PowerDown
PowerDown_FILES = PWRDNRootListController.m
PowerDown_INSTALL_PATH = /Library/PreferenceBundles
PowerDown_FRAMEWORKS = UIKit
PowerDown_PRIVATE_FRAMEWORKS = Preferences
PowerDown_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PowerDown.plist$(ECHO_END)
	