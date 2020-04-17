#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    if (getuid() != 0) {
        printf("Run this as root!\n");
        return 1;
    }
    remove("/Library/MobileSubstrate/DynamicLibraries/AAAAAResSetter.disabled");
    return 0;
}
