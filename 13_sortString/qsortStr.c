///////////////////////////////////////////////////////////////
// qsortStr.c - quicksort an array of strings
// John Schwartzman, Forte Systems, Inc.
// Tue Jan 21 03:54:54 PM EST 2025
///////////////////////////////////////////////////////////////


#include <stdio.h>		// for printf
#include <stdlib.h>		// for EXIT_SUCCESS		
#include <string.h>		// for strcpy()

char* array[] =
{
	"Fred Flintstone",
	"Barney Rubble",
	"Wilma Flintstone",
	"Betty Rubble",
	"Dino the Dinosaur",
	"Fido the Dogasauraus",
	"Rasputin the Mystic",
	"Jack the Giant Killer",
	"Homer the Odyssey", 
	"Warner the Brother #2",
	"Warner the Brother #1"
};

int nArraySize = sizeof(array) / sizeof(array[0]);

void swap(int i, int j)
{
	char* pTemp = array[i];

	array[i] = array[j];
	array[j] = array[i];
	array[j] = pTemp;
 }

int partition(int nLow, int nHigh)
{
	char* pPivot = array[nHigh];
	int i = nLow - 1;
   
	for(int j = nLow; j <= nHigh; j++)
	{
		//If current element is smaller than the nPivot
		if(strcmp(array[j], pPivot) < 0)
		{
			//Increment index of smaller element
			i++;
			swap(i, j);
		}
	}

	swap(i + 1, nHigh);
	return i + 1;
}
 
void quickSort(int nLow, int nHigh)
{
	// when nLow is less than nHigh
	if(nLow < nHigh)
	{
		// nPivot is the partition return index of nPivot
		int nPivot = partition(nLow, nHigh);
		
		//Recursive Call
		//smaller element than nPivot goes left and
		//higher element goes right
		quickSort(nLow, nPivot - 1);
		quickSort(nPivot + 1, nHigh);
	}
}
			  
int main(void) 
{
	printf("\nInsertion Sorted Array:\n");
	for(int i = 0; i < nArraySize; i++)
	{
		printf("\t%s\n", array[i]);
  	}

	quickSort(0, nArraySize - 1);

	printf("\nQuicksorted Array:\n");
	for(int i = 0; i < nArraySize; i++)
	{
		printf("\t%s\n", array[i]);
  	}

	puts("");	// print blank line
	return EXIT_SUCCESS;
}
