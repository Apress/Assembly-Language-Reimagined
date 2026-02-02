// factorial.cpp
// John Schwartzman, Forte Systems, Inc.
// 02/02/2026

#include <stdio.h>   	// declares printf and scanf
#include <iostream>

#define MAX_INT 20

#if defined(__COMMA__)

	extern "C" int commaSeparate(unsigned long long n, char* buffer);     // declaration of asm function

#endif //__COMMA__ 

// recursive function to compute factorial of n
unsigned long long factorial(int n)
{
	if (n == 1)                         // base case
	{
		return n;
	}
	else
	{
		return (n * factorial(n - 1));  // recursive case
	} 
}  
	
int main()  
{  
	int     n;  

	do                              // ask user to input a legal value for n  
	{
		printf("\nEnter a positive integer less than or equal to %d: ", MAX_INT);  
		scanf("%d", &n); 
	}
	while (n < 1 || n > MAX_INT);   // repeat while n is not legal

    // we now have a legal value of n
	unsigned long long fact = factorial(n);   // compute factioral of n

    // print n and factorial of n 
    // using the c++ overloaded std::cout operator <<
	std::cout << n
			  << "! = " 
              << fact
			  << '.'
              << std::endl;
    
    #if defined(__COMMA__)

        char 	buffer[32];
        int nRetVal = commaSeparate(fact, buffer);

        // print n and comma separated value of fact 
        // using the c++ overloaded std::cout operator <<
        std::cout << n
                  << "! = " 
                  << buffer
                  << '.'
                  << std::endl
                  << std::endl;
    
        return nRetVal;     // return  int returned from commaSeparate

    #else 

        std::cout << std::endl;
        return 0;

    #endif
}
  