TARGET = Resolution-Auto-Setter
VERSION = 0.3.0
CC = xcrun -sdk iphoneos clang -arch arm64 -arch arm64e -miphoneos-version-min=11.0
LDID = ldid

.PHONY: all clean

all: clean restoreres springboard-hook
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	cp etc/rc.d/.theos/obj/restoreres com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	chmod 0755 com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d/restoreres
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	cp SpringBoard-Hook/.theos/obj/AAAAAResSetter.dylib SpringBoard-Hook/AAAAAResSetter.plist com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	dpkg -b com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm

restoreres: clean
	bash make-restoreres.sh

springboard-hook: clean
	bash make-springboard-hook.sh

clean:
	rm -rf com.michael.resolutionautosetter* SpringBoard-Hook/.theos etc/rc.d/.theos