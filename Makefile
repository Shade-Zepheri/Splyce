TARGET = iphone:9.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Splyce
Splyce_FILES = Tweak.xm
Splyce_LIBRARIES = activator
Splyce_FRAMEWORKS = UIKit
Splyce_CFLAGS = -fobjc-arc -O2

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
