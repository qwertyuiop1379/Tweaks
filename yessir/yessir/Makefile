include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Yessir

Yessir_FILES = YESRootListController.m
Yessir_INSTALL_PATH = /Library/PreferenceBundles
Yessir_FRAMEWORKS = UIKit
Yessir_PRIVATE_FRAMEWORKS = Preferences
Yessir_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Yessir.plist$(ECHO_END)
