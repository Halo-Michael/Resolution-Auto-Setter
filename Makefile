export TARGET = iphone:clang:13.0:11.0
export ARCHS = arm64 arm64e
export DEBUG = no
export VERSION = 0.4.3
CC = xcrun -sdk ${THEOS}/sdks/iPhoneOS13.0.sdk clang -arch arm64 -arch arm64e -miphoneos-version-min=11.0 -framework CoreFoundation
LDID = ldid

.PHONY: all clean

all: clean restoreres autoSetResolution
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	cp control com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	mv restoreres com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	chmod 0755 com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d/restoreres
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	cp autoSetResolution/AAAAAsetRes.plist com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	mv autoSetResolution/.theos/obj/AAAAAsetRes.dylib com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	dpkg -b com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm

restoreres: clean
	$(CC) restoreres.c -o restoreres
	strip restoreres
	$(LDID) -Sentitlements.xml restoreres

autoSetResolution: clean
	cd autoSetResolution && make

clean:
	rm -rf com.michael.resolutionautosetter* autoSetResolution/.theos restoreres
