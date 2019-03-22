include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ThinnerPrefs
ThinnerPrefs_FILES = THNRootListController.m
ThinnerPrefs_INSTALL_PATH = /Library/PreferenceBundles
ThinnerPrefs_FRAMEWORKS = UIKit
ThinnerPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ThinnerPrefs.plist$(ECHO_END)
