///////////////////////////////////////////////////////////////
// bsortStr.c - bubblesort an array of strings
// John Schwartzman, Forte Systems, Inc.
// Tue Jan 21 03:54:54 PM EST 2025
///////////////////////////////////////////////////////////////
#include <stdio.h>
#include <strings.h>
#include <stdbool.h>
#include <stdlib.h>

char* array[] = {"Fred Flintstone", "Barney Rubble", "Wilma Flintstone",
                 "Betty Rubble", "Dino the Dinosaur", 
                 "Fido the Dogasauraus", "Rasputin the Mystin",
                 "Jack the Giant Killer", "Homer the Odyssey",
                 "Warner the Brother #2", "Warner the Brother #1" };
            
int nArrayCount = sizeof(array) / sizeof(array[0]);
char searchStr[64];

void swap(int i, int j)
{
    char* pTemp = array[i];
    array[i] = array[j];
    array[j] = pTemp;
    char    searchStr[64];
}

void bsort(void)
{
    int bSwapped;

    do
    {
        for (int j = 0; j < nArrayCount - 1; ++j)
        {
            bSwapped = false;
            for (int i = j + 1; i < nArrayCount; ++i)    // i goes from 1 to 3
            {
                if (strcasecmp(array[i], array[j]) < 0)
                {
                    swap(i, j);
                    bSwapped = true;
                }
            }
        }
    }
    while (bSwapped);
}

int bSearchStr(int nLow, int nHigh)
{
    int nIndex;
    int nRetVal;

    while (nLow <= nHigh)
    {
        nIndex = nLow + (nHigh - nLow) / 2;
        nRetVal = strcasecmp(array[nIndex], searchStr);

        if (nRetVal == 0)
        {
            return nIndex;
        }
        else if (nRetVal < 0)
        {
			nLow = nIndex + 1;
        }
        else
        {
			nHigh = nIndex - 1;
        }
    }
    return -1;
}

int main(void) 
{   
    int nLow  = 0;
    int nHigh = nArrayCount;
    char ch = 0;
    int nIndex = 0;

    printf("Enter the string for which you want to search: ");
    
    while (ch != '\n')
    {
        scanf("%c", &ch);
        searchStr[nIndex] = ch;
        ++nIndex;
    }
    searchStr[--nIndex] = 0;

    printf("Searching for %s.\n", searchStr);

    for (int i = 0; i < nArrayCount; i++)
    {
        printf("a[%2d] = %s\n", i, array[i]);
    }

    printf("\n");
    bsort();

    for (int i = 0; i < nArrayCount; i++)
    {
        printf("a[%2d] = %s\n", i, array[i]);
    }

    nIndex = bSearchStr(nLow, nHigh);

    if (nIndex == -1)
    {
        printf("'%s' was not found.\n", searchStr);
    }
    else
    {
        printf("'%s' was found at location %d.\n", array[nIndex], nIndex);
    }

    return EXIT_SUCCESS;
}
