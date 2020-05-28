#import <notify.h>

static void deviceWillShutDown(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, deviceWillShutDown, CFSTR("com.apple.springboard.deviceWillShutDown"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
%end
