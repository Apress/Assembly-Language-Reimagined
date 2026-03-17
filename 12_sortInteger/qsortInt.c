// qsortInt.c

#include <stdio.h>		// for printf
#include <stdlib.h>		// for EXIT_SUCCESS

int array[] = { 25, 24, 23, 22, 21, 19, 2, 3, 9, 1, 4, 7, 6, 5, 11, 10, -4, -2 };
int nArraySize = sizeof(array) / sizeof(array[0]);

void swap(int i, int j)
{
	int nTemp = array[i];
	array[i] = array[j];
	array[j] = nTemp;
 }

int partition(int nLow, int nHigh)
{
	int nPivot = array[nHigh];
	int i = nLow - 1;
   
	for(int j = nLow; j < nHigh; j++)
	{
		//If current element is smaller than the nPivot
		if(array[j] < nPivot)
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
		printf("\t%3d\n", array[i]);
  	}

	quickSort(0, nArraySize - 1);

	printf("\nQuicksorted Array:\n");
	for(int i = 0; i < nArraySize; i++)
	{
		printf("\t%2d\n", array[i]);
  	}

	puts("");	// print blank line
	return EXIT_SUCCESS;
}
