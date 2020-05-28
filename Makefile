TARGET = Resolution-Auto-Setter
VERSION = 0.4.0
CC = xcrun -sdk iphoneos clang -arch arm64 -arch arm64e -miphoneos-version-min=11.0
LDID = ldid

.PHONY: all clean

all: clean postinst restoreres autoSetResolution autoRestoreResolution
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mv postinst com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	cp etc/rc.d/.theos/obj/restoreres com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	chmod 0755 com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d/restoreres
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	cp autoSetResolution/.theos/obj/AAAAAsetRes.dylib autoSetResolution/AAAAAsetRes.plist autoRestoreResolution/.theos/obj/restoreRes.dylib autoRestoreResolution/restoreRes.plist com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	touch com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.disabled
	dpkg -b com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm

postinst: clean
	$(CC) postinst.c -o postinst
	strip postinst
	$(LDID) -Sentitlements.xml postinst

restoreres: clean
	bash make-restoreres.sh

autoSetResolution: clean
	bash make-autoSetResolution.sh

autoRestoreResolution: clean
	bash make-autoRestoreResolution.sh

clean:
	rm -rf com.michael.resolutionautosetter* autoSetResolution/.theos autoRestoreResolution/.theos etc/rc.d/.theos