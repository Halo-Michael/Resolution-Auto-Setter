#import <spawn.h>

extern char **environ;

int run_cmd(const char *cmd)
{
    pid_t pid;
    const char *argv[] = {"sh", "-c", cmd, NULL};
    int status = posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
    return status;
}

bool modifyPlist(NSString *filename, void (^function)(id)) {
    NSData *data = [NSData dataWithContentsOfFile:filename];
    if (data == nil) {
        return false;
    }
    NSPropertyListFormat format = 0;
    NSError *error = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
    if (plist == nil) {
        return false;
    }
    if (function) {
        function(plist);
    }
    NSData *newData = [NSPropertyListSerialization dataWithPropertyList:plist format:format options:0 error:&error];
    if (newData == nil) {
        return false;
    }
    if (![data isEqual:newData]) {
        if (![newData writeToFile:filename atomically:YES]) {
            return false;
        }
    }
    return true;
}

NSString *const systemIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist";
NSString *const userIOMobileGraphicsFamilyPlist = @"/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist";
NSDictionary *const systemIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:systemIOMobileGraphicsFamilyPlist];
NSDictionary *const userIOMobileGraphicsFamily = [NSDictionary dictionaryWithContentsOfFile:userIOMobileGraphicsFamilyPlist];

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    if (userIOMobileGraphicsFamily[@"canvas_height"] && userIOMobileGraphicsFamily[@"canvas_width"]) {
        if (![systemIOMobileGraphicsFamily[@"canvas_height"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_height"]] || ![systemIOMobileGraphicsFamily[@"canvas_width"] isEqualToNumber:userIOMobileGraphicsFamily[@"canvas_width"]]) {
            modifyPlist(systemIOMobileGraphicsFamilyPlist, ^(id plist) {
            plist[@"canvas_height"] = [NSNumber numberWithInteger:[userIOMobileGraphicsFamily[@"canvas_height"] integerValue]];});
            modifyPlist(systemIOMobileGraphicsFamilyPlist, ^(id plist) {
            plist[@"canvas_width"] = [NSNumber numberWithInteger:[userIOMobileGraphicsFamily[@"canvas_width"] integerValue]];});
            run_cmd("sudo killall -9 cfprefsd");
            if (access("/usr/bin/sbreload", F_OK) == 0) {
                run_cmd("sbreload");
            } else {
                run_cmd("killall -9 backboardd");
            }
        }
    }
}
%end
