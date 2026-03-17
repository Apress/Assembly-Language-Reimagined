/////////////////////////////////////////////////////////////////////////////
// dir.c
// John Schwartzman, Forte Systems, Inc.
// dir.c reads the entries of a Linux file directory.
// Sat Nov  2 02:58:21 PM EDT 2024
//
//  gcc dir.c
////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h> 
#include <dirent.h>

int main(int argc, char *argv[])
{
    DIR*            dir;
    struct dirent*  dirent;
    char*           pFileType;
    int             nEntries = 0;
    char*           pFileName;

    if (argc == 1)
    {
        puts ("USAGE: dir directory\n");
        return EXIT_FAILURE;
    }

    dir = opendir(argv[1]);
   
    if (dir != NULL)
    {
        while ((dirent = readdir(dir)) != NULL)
        {
            ++nEntries;
            pFileName = dirent->d_name;
            switch (dirent->d_type)
            {
                case DT_REG:
                    pFileType = "reg";
                    break;

                case DT_DIR:
                    pFileType = "dir";
                    break;

                case DT_LNK:
                    pFileType = "link";
                    break;

                case DT_SOCK:
                    pFileType = "socket";
                    break;

                case DT_BLK:
                    pFileType = "block";
                    break;

                case DT_CHR:
                    pFileType = "char";
                    break;

                default:
                    pFileType = "unknown";
            }
        printf("\t%s (%s)\n", dirent->d_name, pFileType);
        }
        printf("%d entries were found.\n\n", nEntries);
    }
    closedir(dir);
    return EXIT_SUCCESS;
}
////////////////////////////////////////////////////////////////////////////
