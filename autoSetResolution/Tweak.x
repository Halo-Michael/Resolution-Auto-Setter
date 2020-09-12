#include <notify.h>
#include <removefile.h>

static void deviceWillShutDown(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if (keyList != NULL) {
        if (CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_height")) && CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), CFSTR("canvas_width"))) {
            removefile("/private/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist", NULL, REMOVEFILE_RECURSIVE);
            CFPreferencesSynchronize(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
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
            if (!CFEqual(system_height, user_height) || !CFEqual(system_width, user_width)) {
                system([[NSString stringWithFormat:@"res %@ %@ -y", user_height, user_width] UTF8String]);
            }
            CFRelease(system_height);
            CFRelease(system_width);
            CFRelease(user_height);
            CFRelease(user_width);
        }
        CFRelease(keyList);
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, deviceWillShutDown, CFSTR("com.apple.springboard.deviceWillShutDown"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
%end
