//============================================================================
// test.c   Example of retrieving a multi-word string.   
// John Schwartzman, Forte Systems, Inc.
// Tue Feb 11 01:40:16 PM EST 2025
// Linux x64
//
//============================================================================
#include <stdio.h>

char searchStr[64];
int  i;
char ch;

int main()
{
    printf("Enter string(s): ");
    for (i = 0; i < 64; i++)
    {
        scanf("%c", &ch);
        searchStr[i] = ch;
        if (ch == '\n')
        {
            searchStr[i] = 0;
            break;
        }
    }

    printf("Entered string: %s\n", searchStr);
}
