%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    NSString *const systemIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist";
    NSString *const userIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist";
    NSDictionary *const systemIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:systemIOMobileGraphicsFamilyPlist];
    NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:userIOMobileGraphicsFamilyPlist];
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        if (![systemIOMobileGraphicsFamily[@"canvas_height"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_height"]] || ![systemIOMobileGraphicsFamily[@"canvas_width"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_width"]]) {
            system([NSString stringWithFormat:@"res %@ %@ -y", userIOMobileGraphicsFamily[@"canvas_height"], userIOMobileGraphicsFamily[@"canvas_width"]].UTF8String);
        }
    }
}
%end
