include $(THEOS)/makefiles/common.mk
ARCHS = arm64

BUNDLE_NAME = StatusColorPrefs
StatusColorPrefs_FILES = SCRootListController.m
StatusColorPrefs_INSTALL_PATH = /Library/PreferenceBundles
StatusColorPrefs_FRAMEWORKS = UIKit
StatusColorPrefs_PRIVATE_FRAMEWORKS = Preferences
StatusColorPrefs_CFLAGS += -fobjc-arc
StatusColorPrefs_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/StatusColorPrefs.plist$(ECHO_END)
