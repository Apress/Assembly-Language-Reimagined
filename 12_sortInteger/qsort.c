/////////////////////////////////////////////////////////////////////////////
// qsort.c
// John Schwartzman, Forte Systems, Inc.
// 12/05/2023
////////////////////////////////////////////////////////////////////////////
#include<stdio.h>

int array[11] = { 19, 2, 3, 9, 1, 4, 7, 6, 5, 11, 10 };

void quicksort(int nLow, int nHigh)
{
    int i, j, nPivot, nTemp;

    if (nLow < nHigh)
    {
        nPivot = nLow;
        i = nLow;
        j = nHigh;

        while (i < j)
        {
            while (array[i] <= array[nPivot] && i < nHigh)
            {
                ++i;
            }
            while (array[j] > array[nPivot])
            {
                --j;
            }
            if (i < j)
            {
                nTemp = array[i];
                array[i] = array[j];
                array[j] = nTemp;
            }
        }
    }
    
    nTemp = array[nPivot];          // swap array[nPivot] with array[j]
    array[nPivot] = array[j];
    array[j] = nTemp;

    quicksort(nLow, j - 1);
    quicksort(j + 1, nHigh);
}

// Function to print an array
void printArray(int nSize)
{
    int i;
    for (i = 0; i < nSize; i++)
    {
        printf("\t%2d\n", array[i]);
    }
}
int main(void)
{
    int n = sizeof(array) / sizeof(array[0]);
    printf("\nInsertion Sorted Array:\n");
    printArray(n);
    quicksort(0, n);
    printf("\nQuicksorted Array:\n");
    printArray(n);
    printf("\n");
    return 0;
}