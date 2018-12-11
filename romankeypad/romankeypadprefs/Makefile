include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RomanKeypadPrefs
RomanKeypadPrefs_FILES = RKPRootListController.m
RomanKeypadPrefs_INSTALL_PATH = /Library/PreferenceBundles
RomanKeypadPrefs_FRAMEWORKS = UIKit
RomanKeypadPrefs_PRIVATE_FRAMEWORKS = Preferences
RomanKeypadPrefs_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RomanKeypadPrefs.plist$(ECHO_END)
