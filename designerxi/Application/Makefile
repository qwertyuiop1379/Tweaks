include $(THEOS)/makefiles/common.mk
ARCHS = arm64

APPLICATION_NAME = DesignerXI
DesignerXI_FILES = main.m DXIAppDelegate.m DXIRootViewController.x
DesignerXI_FRAMEWORKS = UIKit CoreGraphics
DesignerXI_CFLAGS = -fobjc-arc
TARGET_CODESIGN_FLAGS = -S/var/mobile/ent.plist

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"DesignerXI\"" || true

include $(THEOS_MAKE_PATH)/aggregate.mk
