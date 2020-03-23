TARGET = Resolution-Auto-Setter
VERSION = 0.1.0
CC = xcrun -sdk iphoneos clang -arch arm64 -arch arm64e -miphoneos-version-min=13.0
LDID = ldid

.PHONY: all clean

all: clean restoreres springboard-hook postinst prerm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	cp control layout/DEBIAN/postinst layout/DEBIAN/prerm com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/DEBIAN
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	cp etc/rc.d/restoreres com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d
	chmod 0755 com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/etc/rc.d/restoreres
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate
	mkdir com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	cp SpringBoard-Hook/.theos/obj/AAAAAResSetter.dylib SpringBoard-Hook/AAAAAResSetter.plist com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm/Library/MobileSubstrate/DynamicLibraries
	dpkg -b com.michael.resolutionautosetter_$(VERSION)_iphoneos-arm

restoreres: clean
	$(CC) etc/rc.d/restoreres.c -o etc/rc.d/restoreres
	strip etc/rc.d/restoreres
	$(LDID) -Sentitlements.xml etc/rc.d/restoreres

springboard-hook: clean
	bash make-springboard-hook.sh

postinst: clean
	$(CC) layout/DEBIAN/postinst.c -o layout/DEBIAN/postinst
	strip layout/DEBIAN/postinst
	$(LDID) -Sentitlements.xml layout/DEBIAN/postinst

prerm: clean
	$(CC) layout/DEBIAN/prerm.c -o layout/DEBIAN/prerm
	strip layout/DEBIAN/prerm
	$(LDID) -Sentitlements.xml layout/DEBIAN/prerm

clean:
	rm -rf com.michael.resolutionautosetter*
	rm -rf SpringBoard-Hook/.theos
	rm -f etc/rc.d/restoreres layout/DEBIAN/postinst layout/DEBIAN/prerm