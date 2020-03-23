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
    if (access("/etc/sudoers", F_OK) != 0) {
        printf("What?\n");
        return 1;
    }
    run_cmd("sed -i '/# %wheel ALL=(ALL) NOPASSWD: ALL/a\\mobile ALL=(ALL) NOPASSWD: ALL' /etc/sudoers");
    return 0;
}
