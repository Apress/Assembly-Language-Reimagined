//===========================================================================
// execl.c
// John Schwartzman, Forte Systems, Inc.
// 09/11/2024
//===========================================================================

#include <unistd.h>
#include <stdio.h>

int main()
{
	char* buffer0 = "./myll";
	char* buffer1 = "../files/*.*";
	int nResult = execl("/home/js/Development/asm_x86_64/directory/myll/myll", 
						buffer0, NULL);
	printf("result = %d\n", nResult);
}
