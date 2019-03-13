include $(THEOS)/makefiles/common.mk
ARCHS = armv7s armv7 arm64

BUNDLE_NAME = DockOutlinePrefs
DockOutlinePrefs_FILES = DORootListController.m
DockOutlinePrefs_INSTALL_PATH = /Library/PreferenceBundles
DockOutlinePrefs_FRAMEWORKS = UIKit
DockOutlinePrefs_PRIVATE_FRAMEWORKS = Preferences
DockOutlinePrefs_CFLAS = -fobjc-arc
DockOutlinePrefs_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DockOutlinePrefs.plist$(ECHO_END)
