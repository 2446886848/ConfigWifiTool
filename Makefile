THEOS_DEVICE_IP = 192.168.2.2

TARGET = iphone:latest:7.0
ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ConfigWifiTool
ConfigWifiTool_FILES = Tweak.xm WifiPwdViewController.m WifiManager.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Zeus"
