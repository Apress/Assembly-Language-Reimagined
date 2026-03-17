// minmax.c
// John Schwartzman, Forte Systems, Inc.
// 05/15/2023
// x64

#include <stdlib.h>     // dec of atol; def of EXIT_SUCCESS, EXIT_FAILURE
#include <stdio.h>      // declaration of printf

#ifdef C_VERSION    // if C_VERSION is defined we implement these macros and functions in c

    #define max(a, b) ((a) > (b) ? (a) : (b))   // C macro
    #define min(a, b) ((a) < (b) ? (a) : (b))   // C macro
    
    long printMax(long a, long b)       // implement c function printMax
    {
        printf("\nmax(%ld, %ld) = %ld\n", a, b, max(a, b));
    }

    long printMin(long a, long b)       // implement c function printMin
    {
        printf("\nmin(%ld, %ld) = %ld\n\n", a, b, min(a, b));
    }

#else   // if c_version is not defined we declare these external functions

    extern long printMax(long a, long b);      // declare external function printMax
    extern long printMin(long a, long b);      // declare external function printMin

#endif    

int main(int argc, char* argv[])
{
    if (argc == 3)  // get arguments from command line and make them longs
    {
        long a = atol(argv[1]); // values on the command line are char*
        long b = atol(argv[2]); // values on the command line are char*
        printMax(a, b);
        printMin(a, b);
        return EXIT_SUCCESS;
    }
    else
    {
        printf("\nUSAGE: Please enter 2 long integers on the command line"
               " following the program name.\n\n");
        return EXIT_FAILURE;
    }
}
   