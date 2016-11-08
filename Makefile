TARGET = iphone:clang:9.3:9.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Splyce
Splyce_FILES = Tweak.xm
Splyce_LIBRARIES = activator applist
Splyce_FRAMEWORKS = UIKit CoreGraphics
Splyce_PRIVATE_FRAMEWORKS = AssertionServices FrontBoard
Splyce_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
