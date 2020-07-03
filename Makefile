export TARGET = iphone:clang:13.0:11.0
export ARCHS = arm64 arm64e
export DEBUG = no
export VERSION = 0.4.0
CC = xcrun -sdk ${THEOS}/sdks/iPhoneOS13.0.sdk clang -arch arm64 -arch arm64e -miphoneos-version-min=11.0
LDID = ldid

.PHONY: all clean

all: clean postinst restoreres autoSetResolution autoRestoreResolution
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mv postinst com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	mv restoreres com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
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
	$(CC) -fobjc-arc restoreres.m -o restoreres
	strip restoreres
	$(LDID) -Sentitlements.xml restoreres

autoSetResolution: clean
	cd autoSetResolution && make

autoRestoreResolution: clean
	cd autoRestoreResolution && make

clean:
	rm -rf com.michael.resolutionautosetter* autoSetResolution/.theos autoRestoreResolution/.theos restoreres
