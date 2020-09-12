#include <notify.h>
#include <removefile.h>

static void deviceWillShutDown(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if (keyList != NULL) {
        if (CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_height")) && CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_width"))) {
            removefile("/private/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist", NULL, REMOVEFILE_RECURSIVE);
            CFPreferencesSynchronize(CFSTR("com.apple.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
        }
        CFRelease(keyList);
    }
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if (keyList != NULL) {
        if (CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_height")) && CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_width"))) {
            CFTypeRef system_height = CFPreferencesCopyValue(CFSTR("canvas_height"), CFSTR("com.apple.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost), system_width = CFPreferencesCopyValue(CFSTR("canvas_width"), CFSTR("com.apple.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost), user_height = CFPreferencesCopyValue(CFSTR("canvas_height"), CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost), user_width = CFPreferencesCopyValue(CFSTR("canvas_width"), CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
            if (user_height != NULL && user_width != NULL) {
                if (system_height == NULL || system_width == NULL || !CFEqual(system_height, user_height) || !CFEqual(system_width, user_width)) {
                    system([[NSString stringWithFormat:@"res %@ %@ -y", user_height, user_width] UTF8String]);
                }
            } else {
                removefile("/private/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist", NULL, REMOVEFILE_RECURSIVE);
                CFPreferencesSynchronize(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
            }
            if (system_height != NULL) {
                CFRelease(system_height);
            }
            if (system_width != NULL) {
                CFRelease(system_width);
            }
            if (user_height != NULL) {
                CFRelease(user_height);
            }
            if (user_width != NULL) {
                CFRelease(user_width);
            }
        }
        CFRelease(keyList);
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, deviceWillShutDown, CFSTR("com.apple.springboard.deviceWillShutDown"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
%end
