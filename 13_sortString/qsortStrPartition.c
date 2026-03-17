#include <stdio.h>
#include <stdlib.h>
#include <string.h>


char* array[] =
{
	"Fred Flintstone",
	"Barney Rubble",
	"Wilma Flintstone",
	"Betty Rubble",
	"Dino the Dinosaur",
	"Fido the Dogasauraus",
	"Rasputin",
	"Jack the Giant",
	"Homer the Odyssey", 
	"Warner the Brother #2",
	"Warner the Brother #1"
};

int nArraySize = sizeof(array) / sizeof(array[0]);

void swapij(int i, int j)
{
	char* pTemp = array[i];
	array[i] = array[j];
	array[j] = pTemp;
 }

int main(void)
{
	puts("\nInsertion Sorted Array:");
	for (int i = 0; i < nArraySize; i++)
	{
		printf("\t%s\n", array[i]);
	}

	quickSort(0, nArraySize - 1);
	
	puts("\nQuicksorted Array:");
	for (int i = 0; i < nArraySize; i++)
	{
		printf("\t%s\n", array[i]);
	}

	puts("");
	return EXIT_SUCCESS;
}
 