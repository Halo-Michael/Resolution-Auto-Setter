#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    if (getuid() != 0) {
        setuid(0);
    }
    
    if (getuid() != 0) {
        printf("Can't set uid as 0.\n");
        return 1;
    }

    NSString *const userIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist";
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:userIOMobileGraphicsFamilyPlist];
    
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
    }
    return 0;
}
