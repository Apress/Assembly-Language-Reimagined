//============================================================================
// fileInfo.c
// John Schwartzman, Forte Systems, Inc.
// 08/18/2024
// Linux x64
//============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <stddef.h>
#include <time.h>

struct stat		st;
struct passwd*	pw;
struct group*	gr;

const char*     pFilePath = "fileInfo.c";
char			filePerm[] = { '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 0};

// printFileAppDateTime
int printFileAppDateTime(long mTime)
{
	char		pDateTime[28];
	struct tm*	tmp;
	int			nRetVal;

	tmp = localtime(&mTime);
	nRetVal = strftime(pDateTime, 28,  " %b %d %H:%M\n", tmp);
	if(nRetVal == 0)
	{
		return EXIT_FAILURE;	// not enough space for pDateTime
	}

	printf("mTime = %s\n", pDateTime);
	return EXIT_SUCCESS;
}

// printFileInfo
int printFileInfo()
{
	// perform lstat on pFilePath and place result in st
	int	nResult = lstat(pFilePath, &st);

	if (nResult != 0)
		{
			return nResult;
		}

	printf("File path: %s\n", pFilePath);
	printf("uid: %d, gid: %d\n", st.st_uid, st.st_gid);

	printf("mode: %o (octal)\n", st.st_mode);

	// invoke getpwuid
	pw = getpwuid(st.st_uid);

	// invoke getgrgid
	gr = getgrgid(st.st_gid);

	printf("uid: %s, gid: %s\n", pw->pw_name, gr->gr_name);

	unsigned int nType = (st.st_mode) & __S_IFMT;

	if (nType == __S_IFREG)
		filePerm[0] = '-';
	else if (nType == __S_IFDIR)
		filePerm[0] = 'd';
	else if (nType == __S_IFLNK)
		filePerm[0] = 'l';
	else if (nType == __S_IFIFO)
		filePerm[0] = 'p';
	else if (nType == __S_IFSOCK)
		filePerm[0] = 's';
	else if (nType == __S_IFBLK)
		filePerm[0] = 'b';
	else if (nType == __S_IFCHR)
		filePerm[0] = 'c';

	if (st.st_mode & S_IRUSR)
		filePerm[1] = 'r';
	else 
		filePerm[1] = '-';

	if (st.st_mode & S_IWUSR)
		filePerm[2] = 'w';
	else
		filePerm[2] = '-';

	if (st.st_mode & S_IXUSR)
		filePerm[3] = 'x';
	else
		filePerm[3] = '-';


	if (st.st_mode & S_IRGRP)
		filePerm[4] = 'r';
	else
		filePerm[4] = '-';

	if (st.st_mode & S_IWGRP)
		filePerm[5] = 'w';
	else
		filePerm[5] = '-';

	if (st.st_mode & S_IXGRP)
		filePerm[6] = 'x';
	else
		filePerm[6] = '-';


	if (st.st_mode & S_IROTH)
		filePerm[7] = 'r';
	else
		filePerm[7] = '-';

	if (st.st_mode & S_IWOTH)
		filePerm[8] = 'w';
	else
		filePerm[8] = '-';

	if (st.st_mode & S_IXOTH)
		filePerm[9] = 'x';
	else
		filePerm[9] = '-';

	// print info collected by printFileInfo	
    printf("File: %s\n", pFilePath); 
    printf("hard links: %ld\n", st.st_nlink);
    printf("Permissions: %s\n", filePerm);
    printf("File size: %ld\n", st.st_size);
	printFileAppDateTime(st.st_atime);
	
	printf("st_dev:     %ld\n", offsetof(struct stat, st_dev));
	printf("st_ino:     %ld\n", offsetof(struct stat, st_ino));
	printf("st_mode:    %ld\n", offsetof(struct stat, st_mode));
	printf("st_nlink:   %ld\n", offsetof(struct stat, st_nlink));
	printf("st_uid:     %ld\n", offsetof(struct stat, st_uid));
	printf("st_gid:     %ld\n", offsetof(struct stat, st_gid));
	printf("st_rdev:    %ld\n", offsetof(struct stat, st_rdev));
	printf("st_size:    %ld\n", offsetof(struct stat, st_size));
	printf("st_blksize: %ld\n", offsetof(struct stat, st_blksize));
	printf("st_blocks:  %ld\n", offsetof(struct stat, st_blocks));
	printf("st_atime:   %ld\n", offsetof(struct stat, st_atime));
	printf("st_mtime:   %ld\n", offsetof(struct stat, st_mtime));
	printf("st_ctime:   %ld\n", offsetof(struct stat, st_ctime));
	printf("\n");

	printf("pw_name:    %ld\n", offsetof(struct passwd, pw_name));
	printf("pw_passwd:  %ld\n", offsetof(struct passwd, pw_passwd));
	printf("pw_uid:     %ld\n", offsetof(struct passwd, pw_uid));
	printf("pw_gid:     %ld\n", offsetof(struct passwd, pw_gid));
	printf("pw_gecos:   %ld\n", offsetof(struct passwd, pw_gecos));
	printf("pw_dir:     %ld\n", offsetof(struct passwd, pw_dir));
	printf("pw_shell    %ld\n", offsetof(struct passwd, pw_shell));
	printf("\n");
	
	printf("gw_name:    %ld\n", offsetof(struct group, gr_name));
	printf("gw_passwd:  %ld\n", offsetof(struct group, gr_passwd));
	printf("gr_gid:     %ld\n", offsetof(struct group, gr_gid));
	printf("gr_mem:     %ld\n", offsetof(struct group, gr_mem));

	return nResult;
}

int main()
{
    return printFileInfo();
}