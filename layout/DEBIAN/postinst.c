#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    if (getuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }
    
    system("chown root:wheel /etc/rc.d/restoreres");
    system("chmod 6755 /etc/rc.d/restoreres");
    return 0;
}
