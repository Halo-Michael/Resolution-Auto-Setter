#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
extern char **environ;

int run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
    return status;
}

int main()
{
    if (geteuid() != 0) {
        printf("Run this as root!\n");
        exit(1);
    }
    
    if (access("/.cydia_no_stash", F_OK) != 0) {
        FILE *fp = fopen("/.firstboot","a+");
        fclose(fp);
        if (access("/var/mobile/Library/Preferences/com.michael.iokit.IOMobileGraphicsFamily.plist", F_OK) == 0) {
            remove("/var/mobile/Library/Preferences/com.apple.iokit.IOMobileGraphicsFamily.plist");
        }
    }
    return 0;
}
