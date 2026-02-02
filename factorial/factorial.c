// factorial.c
// John Schwartzman, Forte Systems, Inc.
// 02/02/2026

#include<stdio.h>   // for printf and scanf

#define MAX_INT 20

#if defined(__COMMA__)

    extern int commaSeparate(unsigned long long n, char* buffer);     // declaration of asm function

#endif //__COMMA__ 

// recursive function to compute factorial of n
long factorial(int n)
{
	if (n == 1)                         // base case
	{
		return 1;
	}
	else
	{
		return (n * factorial(n - 1));  // recursive case
	} 
}  
	
int main()  
{   
	int                 n;  
	unsigned long long  fact;

    // prompt user to input a legal value for n 
	do                   
	{
        printf("\nEnter a positive integer less than or equal to %d: ", MAX_INT);  
        scanf("%d", &n); 
    }
    while (n < 1 || n > MAX_INT);       // repeat while n is not legal

    // we have a legal value for n
	fact = factorial(n);                                // compute factorial
	printf("%d! = %lld.\n", n, fact);                   // print n and factorial(n)
  
	#if defined(__COMMA__)

		char	buffer[32];
		int     nRetVal = commaSeparate(fact, buffer);  // compute comma separated string
                                                        // and return comma separated string in buffer
		printf("%d! = %s.\n\n", n, buffer);             // print n and comma separated string
        return nRetVal;
    #else

        printf("\n");
        return 0;

	#endif  //__COMMA__
} 
