// environment.c
// John Schwartzman, Forte Systems, Inc.
// 01/11/2026

#include <time.h>       // declaration of time; definition of time_t

int printenv(const char* sDateTime);   // declaration of asm function

int main(void)
{
    time_t  now;
    char*   sDateTime;

    time(&now);
    sDateTime = ctime(&now);
    return printenv(sDateTime);       // call printenv function with strTime arg
}
   