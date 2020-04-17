int main()
{
    if (getuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }

    NSString *const userIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist";
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:userIOMobileGraphicsFamilyPlist];
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        if (access("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist", F_OK) == 0){
            remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
        }
        if (access("/Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.disabled", F_OK) == 0 && access("/Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.dylib", F_OK) != 0){
            system("mv /Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.disabled /Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.dylib");
        }
    }
    return 0;
}
