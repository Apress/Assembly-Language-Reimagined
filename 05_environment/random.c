// random.c
// John Schwartzman, Forte Systems, Inc.
// 05/29/2023

#include <time.h>       // declaration of time; definition of time_t
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int guessNumber()
{
    int nGuess;

    printf("\nGuess a number between 0 and 100: ");
    scanf("%d", &nGuess);
    printf("\n");
    return nGuess;
}

int initRandom()
{
    // Use current time as seed for random generator
    srand(time(0));
    return rand() % 100;  // get random int between 0 and 100
}

#ifdef __NEEDED__

int main(void)
{
    int nRandom = initRandom();
    int nGuess;
 
    while (true)
    {
        nGuess = guessNumber();
        if (nGuess > nRandom)
        {
            printf("Too high!\n");
        }
        else if (nGuess < nRandom)
        {
            printf("Too low!\n");
        }
        else
        {
            printf("Just right!\n");
            break;
        }
    }
}

#endif  // __NEEDED__


   

