#import <Foundation/Foundation.h>

int main()
{
    CFArrayRef userIOMobileGraphicsFamily = CFPreferencesCopyKeyList(CFSTR("com.michael.iokit.IOMobileGraphicsFamily"), CFSTR("mobile"), kCFPreferencesAnyHost);
    if ([(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_height"] && [(__bridge NSArray *)userIOMobileGraphicsFamily containsObject:@"canvas_width"]) {
        remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
    }
    return 0;
}
