#import <notify.h>

static void deviceWillShutDown(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist"];
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
    }
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    NSDictionary *const systemIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist"];
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist"];
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        if (![systemIOMobileGraphicsFamily[@"canvas_height"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_height"]] || ![systemIOMobileGraphicsFamily[@"canvas_width"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_width"]]) {
            system([NSString stringWithFormat:@"res %@ %@ -y", userIOMobileGraphicsFamily[@"canvas_height"], userIOMobileGraphicsFamily[@"canvas_width"]].UTF8String);
        }
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, deviceWillShutDown, CFSTR("com.apple.springboard.deviceWillShutDown"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
%end
