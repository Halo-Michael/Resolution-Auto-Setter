#import <Foundation/Foundation.h>

int main()
{
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist"];
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
    }
    return 0;
}
