include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RememberMe
RememberMe_FILES = RememberMeRootListController.m
RememberMe_INSTALL_PATH = /Library/PreferenceBundles
RememberMe_FRAMEWORKS = UIKit
RememberMe_PRIVATE_FRAMEWORKS = Preferences
RememberMe_CFLAGS += -fobjc-arc
TARGET_CODESIGN_FLAGS = -S../../designerxi/Application/ent.plist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RememberMe.plist$(ECHO_END)
