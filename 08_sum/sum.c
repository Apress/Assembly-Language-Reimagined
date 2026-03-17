// sum.c - retrieve floats from cmdline
// John Schwartzman, Forte Systems, Inc.
// 06/06/2023

#include <stdio.h>		// declares printf
#include <stdlib.h>		// defines EXIT_SUCCESS - declaration of atof

int main(int argc, char* argv[])
{
	double sum = 0.0;
	double val;
	
	printf("\nargc    = %d\n", argc);	// print argc
	for (int i = 1; i < argc; i++)
	{
		val = atof(argv[i]);
		printf("argv[%d] = %s = %.2f\n", i, argv[i], val);	// print argv[i]
		sum += val;
		
	}
	printf("\nsum     = %.2f\n\n", sum);		// print sum
	return EXIT_SUCCESS;
}
