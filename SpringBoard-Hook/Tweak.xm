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

%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    if (access("/.firstboot", F_OK) == 0) {
        run_cmd("sudo rm -f /.firstboot");
        if (access("/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist", F_OK) == 0) {
            run_cmd("cp -a /var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist /var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
            run_cmd("sudo killall -9 cfprefsd");
            if (access("/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist", F_OK) == 0) {
                run_cmd("sbreload");
            } else {
                run_cmd("killall -9 backboardd");
            }
        }
    }
}
%end
