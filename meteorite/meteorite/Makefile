include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Meteorite
Meteorite_FILES = MTRRootListController.m
Meteorite_INSTALL_PATH = /Library/PreferenceBundles
Meteorite_FRAMEWORKS = UIKit
Meteorite_PRIVATE_FRAMEWORKS = Preferences
Meteorite_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Meteorite.plist$(ECHO_END)
