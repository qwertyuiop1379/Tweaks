include $(THEOS)/makefiles/common.mk
ARCHS = arm64

APPLICATION_NAME = DesignerXI
DesignerXI_FILES = $(wildcard *.m)
DesignerXI_FRAMEWORKS = UIKit CoreGraphics Foundation
DesignerXI_CFLAGS = -fobjc-arc
# ent.plist: platform-application, com.apple.private.security.container-required, com.apple.private.security.no-container, com.apple.private.security.no-sandbox, com.apple.private.security.system-application, com.apple.private.skip-library-validation
TARGET_CODESIGN_FLAGS = -S/var/mobile/ent.plist

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"DesignerXI\"" || true

include $(THEOS_MAKE_PATH)/aggregate.mk
