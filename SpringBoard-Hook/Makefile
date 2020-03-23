TARGET = iphone:clang::13.0
ARCHS = arm64 arm64e
DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AAAAAResSetter

AAAAAResSetter_FILES = Tweak.xm
AAAAAResSetter_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
