// uname.c
// John Schwartzman, Forte Systems, Inc.
// 04/15/2023

#include <stdio.h>	        // declaration of printf, perror
#include <stdlib.h>         // defines EXIT_SUCCESS
#include <sys/utsname.h>    // declaration of uname, utsname

int main(void)
{
    struct utsname buffer;
    
    int retValue = uname(&buffer);
 
    if (retValue != 0)
    {
        perror("uname");
        return retValue;
    }
    
    printf("   OS name:     %s\n", buffer.sysname);
    printf("   node name:   %s\n", buffer.nodename);
    printf("   release:     %s\n", buffer.release);
    printf("   version:     %s\n", buffer.version);
    printf("   machine:     %s\n", buffer.machine);
    return EXIT_SUCCESS;
}
   