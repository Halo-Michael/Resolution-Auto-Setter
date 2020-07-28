#import <notify.h>

static void deviceWillShutDown(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    CFArrayRef userIOMobileGraphicsFamily = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if ([(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_height"] && [(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_width"]) {
        remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
    }
}

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    CFArrayRef systemIOMobileGraphicsFamily = CFPreferencesCopyKeyList(CFSTR("com.apple.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    CFArrayRef userIOMobileGraphicsFamily = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if ([(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_height"] && [(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_width"]) {
        NSDictionary *systemSettings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(systemIOMobileGraphicsFamily, CFSTR("com.apple.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost));
        NSDictionary *userSettings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(userIOMobileGraphicsFamily, CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost));
        if (![systemSettings[@"canvas_height"] isEqualToNumber:userSettings[@"canvas_height"]] || ![systemSettings[@"canvas_width"] isEqualToNumber:userSettings[@"canvas_width"]]) {
            system([[NSString stringWithFormat:@"res %@ %@ -y", userSettings[@"canvas_height"], userSettings[@"canvas_width"]] UTF8String]);
        }
    }
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, deviceWillShutDown, CFSTR("com.apple.springboard.deviceWillShutDown"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
%end
