#include <CoreFoundation/CoreFoundation.h>
#include <removefile.h>

int main() {
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if (keyList != NULL) {
        if (CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_height")) && CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_width"))) {
            removefile("/private/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist", NULL, REMOVEFILE_RECURSIVE);
            CFPreferencesSynchronize(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
        }
        CFRelease(keyList);
    }
    return 0;
}
