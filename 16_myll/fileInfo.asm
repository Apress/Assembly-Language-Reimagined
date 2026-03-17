;============================================================================
; fileInfo.asm
; John Schwartzman, Forte Systems, Inc.
; 08/20/2024
; Linux x64
;============================================================================
%include	"macro.inc"

global		readFileInfo
extern		readFileSize
extern		readFileTime
global		begItemFmt
global		perm, sUid, sGid, nHardLinks
global		mtime, msize, fileName
extern		sFileInfo0, sFileInfo1, sFileInfo2, sFileInfo3
extern		listIndex, n_sPerm, n_sSize, n_sTime, n_sNameLink
global		totalBytes

%define S_IFMT   0170000q	; q is necessary to indicate octal values

%define S_IFSOCK 0140000q	; socket - from <sys/stat.h>
%define S_IFLNK  0120000q	; hard link
%define S_IFREG  0100000q	; regular file
%define S_IFBLK  0060000q	; block device
%define S_IFDIR  0040000q	; directory
%define S_IFCHR  0020000q	; character device
%define S_IFIFO  0010000q	; fifo (pipe)

%define	S_IRUSR		0400q	; Read by owner
%define	S_IWUSR		0200q	; Write by owner
%define	S_IXUSR		0100q	; Execute by owner
%define	S_IRGRP		0040q	; Read by group
%define	S_IWGRP		0020q	; Write by group
%define	S_IXGRP		0010q	; Execute by group
%define	S_IROTH		0004q	; Read by others
%define	S_IWOTH		0002q	; Write by others
%define	S_IXOTH		0001q	; Execute by others

%define	st_dev			0	; struct stat64
%define st_ino			8
%define st_nlink	   16
%define st_mode		   24
%define st_uid		   28
%define st_gid		   32
%define st_rdev		   40
%define st_size		   48
%define st_blksize	   56
%define st_blocks	   64
%define st_atime	   72
%define st_mtime	   88
%define st_ctime	  104

%define pw_name			0	; struct pw
%define pw_passwd		8
%define pw_uid		   16
%define pw_gid		   20
%define pw_gecos	   24
%define pw_dir		   32
%define pw_shell	   40

%define gr_name			0	; struct gw
%define gr_passwd		8
%define gr_gid		   16
%define gr_mem		   24

%define	NUM_VAR		2		; round up to next even value

;================== DEFINE LOCAL VARIABLES for readFileInfo =================
%define	buffer		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 0

;============================== CODE SECTION ================================
section	.text

;============================================================================
readFileInfo:
	prologue NUM_VAR				; leave room for stack variable buffer

	mov		rdi, rsi
	lea		rsi, [stat64]
	lstat							; fill stat64 structure for this file
	cmp		rax, -1
	je		.err1					; error - return with rax = -1

	lea		eax, dword [stat64 + st_uid]
	mov		esi, dword [eax]

	lea		rsi, qword [stat64 + st_mode]	; get mode
	mov		esi, [rsi]
	mov		[nMode], esi

	lea		rdi, [stat64 + st_uid]			; get uid
	mov		rdi, [rdi]
	getpwuid						; get struc password
	mov		[pw], rax

	lea		rdi, [pw]				; get gid name
	mov		rax, [rdi]				; save struc password

	lea		rdi, [stat64 + st_gid]	; get gid
	mov		rdi, [rdi]
	getgrgid						; get struc group
	mov		[gw], rax				; save struc group
	
	lea		rdi, [sUid]				; copy uid name
	mov		rsi, [pw]
	mov		rsi, [rsi]
	strcpy

	lea		rdi, [sGid]				; copy gid name
	mov		rsi, [gw]
	mov		rsi, [rsi]
	strcpy

	lea		rdi, [stat64 + st_nlink]	; get hard links
	mov		rdi, [rdi]
	mov		[nHardLinks], rdi

	lea		rdi, [stat64 + st_size]	; get file size
	mov		rdi, [rdi]
	mov		[nFileSize], rdi

	lea		rdi, [stat64+st_mtime]	; get file modification time
	mov		rdi, [rdi]
	mov		[nFileTime], rdi

	lea		rsi, [roperm]			; init permissions
	lea		rdi, [perm]
	mov		rcx, ROPERM_LEN
	rep		movsb

	mov		eax, [nMode]
	and		eax, S_IFMT				; check file type

	cmp		rax, S_IFREG			; regular file
	je		.gotFileType

	cmp		rax, S_IFDIR			; directory
	mov		byte [perm], 'd'
	je		.gotFileType

	cmp		rax, S_IFLNK			; link
	mov		byte [perm], 'l'
	je		.gotFileType

	cmp		rax, S_IFIFO			; pipe (FIFO)
	mov		byte [perm], 'p'
	je		.gotFileType

	cmp		rax, S_IFSOCK			; socket
	mov		byte [perm], 's'
	je		.gotFileType

	cmp		rax, S_IFBLK			; block device
	mov		byte [perm], 'b'
	je		.gotFileType

	cmp		rax, S_IFCHR			; character device
	mov		byte [perm], 'c'
	je		.gotFileType

	mov		byte [perm], '?'

.gotFileType:						; now check file permissions
	mov		eax, [nMode]
	test	eax, S_IRUSR			; owner read
	jz		.gotUserRead
	mov		byte [perm + 1], 'r'

.gotUserRead:
	test	eax, S_IWUSR			; owner write
	jz		.gotUserWrite
	mov		byte [perm + 2], 'w'

.gotUserWrite:
	test	eax, S_IXUSR			; owner execute
	jz		.gotUserExecute
	mov		byte [perm + 3], 'x'

.gotUserExecute:
	test	eax, S_IRGRP			; group read
	jz		.gotGroupRead
	mov		byte [perm + 4], 'r'

.gotGroupRead:
	test	eax, S_IWGRP			; group write
	jz		.gotGroupWrite
	mov		byte [perm + 5], 'w'

.gotGroupWrite:
	test	eax, S_IXGRP			; group execute
	jz		.gotGroupExecute
	mov		byte [perm + 6], 'x'

.gotGroupExecute:
	test	eax, S_IROTH			; other read
	jz		.gotOtherRead
	mov		byte [perm + 7], 'r'

.gotOtherRead:
	test	eax, S_IWOTH			; other write
	jz		.gotOtherWrite
	mov		byte [perm + 8], 'w'

.gotOtherWrite:
	test	eax, S_IXOTH			; other execute
	jz		.printPermissions
	mov		byte [perm + 9], 'x'

.printPermissions:
	cmp		byte [perm], 'l'		; is the current file a link?
	jne		.next					;	jump if no

	readlink	[fileName], [linkName], 64	; read linkName
	cmp		rax, -1
	je		.err2

.next:
	lea		rdi, [sFileInfo0]		; load file type, perm, uid, gid
	lea		rsi, [begItemFmt]
	lea		rdx, [perm]
	mov		rcx, [nHardLinks]
	lea		r8,  [sUid]
	lea		r9,  [sGid]
	sprint
	
	mov		rdi, [nFileSize]		; get file size
	add		[totalBytes], rdi		; accumulate file sizes
	call	readFileSize			; create human interface

	lea		rsi, [rax]				; get returned buffer into rsi
	lea		rdi, [sFileInfo1]
	sprint							; copy file size string into sFileInfo1

	lea		rdi, [nFileTime]		; get file mod time
	call	readFileTime			; create string version

	lea		rsi, [rax]				; calculate ds
	lea		rdi, [sFileInfo2]
	strcpy

	cmp		byte [perm], 'l'		; is the node a link?
	je		.next2					;	jump if yes

	lea		rsi, [fileName]
	lea		rdi, [sFileInfo3]
	strcpy							; buffer now contains fileName only
	jmp		.fin

.next2:
	lea		rdi, [sFileInfo3]		; output buffer
	lea		rsi, [linkNameFmt]
	lea		rdx, [fileName]
	lea		rcx, [linkName]
	sprint
	jmp		.fin					

	cmp		byte [perm + 9], 'x'	; is the link executable by everyone
	jne		.fin					;	jump if no

	strcat	[sNameLink], [pAsterisk]	; the link is executable
	strcpy	[sFileInfo3], [sNameLink]
	jmp		.fin

.err1:
	perror [lstatName]				; return errno
	jmp		.exit

.err2:
	perror [rdlinkName]				; return errno
	jmp		.exit

.fin:
	cmp		byte [perm], 'd'		; is the node a directory?
	je		.fin2					;	jump if yes (don't append '*')

	cmp		byte [perm + 9], 'x'	; is the node executible by everyone?
	jne		.fin2					;	jump if no

	strcat	[sFileInfo3], [pAsterisk]	; sNameLink is executible

.fin2:
	zero    eax                     ; return EXIT_SUCCESS

.exit:
	epilogue
	
;============================================================================
section		.bss

	struc	stat64_struct			; structure declaration
		ST_DEV		resq	1		; stat_struct +   0
		ST_INO		resq	1		;			  +   8
		ST_MODE		resd 	1		;			  +  16		file type and permissions 
		ST_NLINK	resq 	1		;			  +  20		NOTE: ORDER OF TERMS
		ST_UID		resd	1		;			  +  28
		ST_GID		resd	1		;			  +  32
		ST_FILL1	resd	1		;			  +  36		NOTE: ADDITION OF FILL TERM
		ST_RDEV		resq	1		;			  +	 40
		ST_SIZE		resq	1		;			  +  48
		ST_BLKSIZE	resq	1		;			  +  56
		ST_BLOCKS 	resq	1		;			  +  64
		ST_ATIME	resq	1		;			  +  72		
		ST_MTIME	resq	1		;			  +  88		NOTE: ORDER OF TERMS
		ST_CTIME	resq	1		;			  + 104
	endstruc

	struc	pw_struct				; structure declaration
		PW_NAME		resq	1
		PW_PASSWD	resq	1
		PW_UID		resd	1
		PW_GID		resd	1
		PW_GECOS	resq	1
		PW_DIR		resq	1
		PW_SHELL	resq	1
	endstruc

	struc	gr_struct				; structure declaration
		GR_NAME		resq	1
		GR_SIZE		resq	1
		GR_PASSWD	resq	1
		GR_GID		resd	1
	endstruc

sUid		resb	16
sGid		resb	16
nFileSize	resq	 1
nFileTime	resq	 1
nMode		resd	 1
linkName	resb	64
fileName	resb	64
sNameLink	resb	64

section     .data

nHardLinks		dq		0
perm			db		'-', '-', '-', '-', '-', '-', '-', '-', '-', '-', ' ', EOL
totalBytes		dq		0

stat64	istruc	stat64_struct
		iend

pw		istruc	pw_struct
		iend

gw		istruc	gr_struct
		iend

section	.rodata

lstatName	db		"lstat returned", EOL
rdlinkName	db		"rdlink returned", EOL
linkNameFmt	db		"%s -> %s", EOL
pAsterisk	db		"*", EOL
pFmt		db		"%s", EOL
begItemFmt	db		"%s%lld %s %s ", EOL	; perm, nHardLinks, sUid, sGid
roperm		db		'-', '-', '-', '-', '-', '-', '-', '-', '-', '-', ' ', EOL
ROPERM_LEN	equ		$-roperm - 1
;============================================================================
