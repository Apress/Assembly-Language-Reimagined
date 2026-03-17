;============================================================================
; llDir.asm - retrieve ls info from the OS, sort & print it (ignores . and ..)
; John Schwartzman, Forte Systems, Inc.
; 01/20/2024
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
NUM_VAR			equ	   6		; for main - round up to even number
ARG_SIZE		equ	   8		; size of argv vector
PATH_SEP		equ	  47		; ASCII '/' char
D_TYPE_OFFSET	equ	  18		; offset to dirent->d_type
D_NAME_OFFSET	equ	  19		; offset to dirent->d_name
STR_SIZE		equ	  64
BAD_PATH		equ	   1
BAD_OPEN		equ	   2

%include "macro.inc"

%define __quicksort__

global	main
extern	opendir, readdir, closedir
extern	quicksortStr, bubblesortStr	; global procedures
extern  insertNode, traverseList
extern	createHeadNode, freeList
global	listIndex, pTemp, pTempi, pTempj
global	nTempi, nTempj, fileType
global  nNameType, headNode, nNext, nPrev, nType
global	node_size, nRecordCnt, nAllocations
global	dt_unknown, dt_fifo, dt_char, dt_block
global	dt_dir, dt_reg, dt_link, dt_sock

DT_UNKNOWN	equ	 0		; dirent file types - from /usr/include/dirent.h
DT_FIFO		equ	 1
DT_CHR		equ	 2
DT_DIR		equ	 4
DT_BLK		equ  6
DT_REG		equ	 8
DT_LINK		equ	10
DT_SOCK		equ	12

;======================= DEFINE LOCAL VARIABLES (main) ======================
%define	argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define	argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define	dir			qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define dirent  	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]  ; rsp + 24
%define nRecords	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 32
;============================== CODE SECTION ================================
section	.text

;============================================================================
main:
	prologue NUM_VAR				; setup stack and space for 4 local var
	mov		argc, rdi				; argc  = rdi (1st arg to main)
	mov		argv0, rsi				; argv0 = rsi (2nd arg to main)
	zero	rax
	mov		nRecords, rax			; zero record count
	cmp		rdi, 1					; more than 1 command line arg?
	je		.getCurrentDir			;   jump if no

	lea		rdi, [path]				; rdi => path[]  <= dest
	mov		rsi, [rsi + ARG_SIZE]	; rsi => argv[1] <= src
	strcpy
	jmp		.terminatePath

.getCurrentDir:
	lea		rdi, [path]
	lea		rsi, [current_dir]			; src  => "./"
	strcpy	

.terminatePath:
	lea		rdi, [path]
	strlen							; rax = strlen(path)

	lea		rdi, [path]
	dec		rax						; rax => last char of path
	cmp		byte [rax + rdi], PATH_SEP
	je		.chdir					; 	jump if yes

	lea		rsi, [path_sep]
	strcat

.chdir:
	chdir	[path]					; getFileType needs us to chdir 
	jz		.opendir				;	jump if chdir successfull

	lea		rsi, [path]				; invalid directory selection
	print	[errFmt]				; print error message
	mov		rax, BAD_PATH
	mov		[exitCode], rax
	jmp		.fin					; and exit

.opendir:
	lea		rdi, [path]
	call	opendir					; rax = opendir(path)
	mov		dir, rax				; save dir
	rdflags	rax						; is dir null?
	mov		rax, BAD_OPEN
	mov		[exitCode], rax
	jz		.fin					;    jump if yes 

	call	createHeadNode

.top_of_loop:
	mov     rdi, dir
	call	readdir					; rax = readdir(dir)
	mov	    dirent, rax				; Dirent <- rax
	rdflags	rax						; is dirent NULL?
	jz		.dirEnd					;    jump if yes (exit)

	rdstruc dirent, D_TYPE_OFFSET	; get file  type
	mov		rax, [rdi]

	cmp		al, DT_REG
	lea		rsi, [dt_reg]			
	je		.getFileType

	cmp		al, DT_DIR
	lea		rsi, [dt_dir]
	je		.getFileType

	cmp		al, DT_LINK
	lea		rsi, [dt_link]
	je		.getFileType

	cmp		al, DT_FIFO
	lea		rsi, [dt_fifo]			
	je		.getFileType

	cmp		al, DT_CHR
	lea		rsi, [dt_chr]			
	je		.getFileType

	cmp		al, DT_BLK
	lea		rsi, [dt_blk]			
	je		.getFileType

	cmp		al, DT_SOCK
	lea		rsi, [dt_sock]			
	je		.getFileType

	lea		rsi, [dt_unknown]

.getFileType:
	lea		rdi, [fileType]
	strcpy							; copy fileType

	rdstruc dirent, D_NAME_OFFSET	; get file name
	lea		rsi, [rdi]
	lea		rdi, [fileName]
	strcpy							; copy fileName

	lea		rsi, [parent_dir]		; ignore ../
	strcmp
	jz		.top_of_loop

	lea		rsi, [this_dir]			; ignore ./
	strcmp
	jz		.top_of_loop
	
	lstat	[fileName], [stat]
	strcmp	[fileType], [dt_dir]
	jne		.continue

.parseFilename:
	strcat	[space], [fileName]
	strcpy	[fileName], [space]
	strcpy	[space], [empty_str]	; restore space
	
.continue:
	strcat 	[fileName], [fileType]	; concatenate 
	lea		rsi, [fileName]
	mov		rcx, nRecords
	call	insertNode				;  create new element - rsi => array[rcx]
	inc		nRecords
	jmp		.top_of_loop			; continue for other dir entries

.dirEnd:
	mov		rdi, dir
	call	closedir				; closrdir(dir)
	mov		rsi, nRecords
	print 	[prtFmtTotal]
	mov		rax, nRecords			
	test	rax, rax				; have we created any nodes?
	jz		.fin					;	jump of no

	puts	[unsorted]
	mov		rdi, nRecords
	call	traverseList
	
%ifdef __bubblesort__

 	puts	[bsorted]
	zero	rdi					; i = nLow
	mov		rsi, nRecords 			; nHigh 						
	dec		rsi						; j = nHigh = nRecords - 1
	call	bubblesortStr

%elifdef __quicksort__

	puts	[qsorted]
	zero	rdi						; nLow = 0
	mov		rsi, nRecords			
	dec		rsi						; nHigh = number of records - 1
	call	quicksortStr

%endif

	mov		rdi, nRecords
	call	traverseList

.fin:
	mov		rax, [nAllocations]		; get max number of allocations
	mov		[nMaxAlloc], rax

	call	freeList

	puts	[deptStat]				; print legand

	; show number of allocations remaining after call to free list
	print	[allocMsg], [nAllocations], [nMaxAlloc]

	; show the size [node_size]
	print	[nodeSizeFmt], [node_size]

	zero	rax						; EXIT_SUCCESS
	mov		[exitCode], rax

	puts	[blankline]
	epilogue [exitCode]				; exit the program

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
RESET		db ESC, "[0m"
RED			db ESC, "[0;31m"
prtUserFmt	db TAB, "User ID  = %s", LF, EOL
prtGroupFmt	db TAB, "Group ID = %s", LF, EOL
prtFmt		db TAB, "%s (%s)", LF, EOL
prtFmtTotal	db "%2d entries found.", LF, EOL
listFmt		db TAB, "%s", LF, EOL
nodeSizeFmt	db TAB, "node_size = %2d", LF, EOL
this_dir	db ".", EOL
parent_dir  db "..", EOL
current_dir db "./", EOL
empty_str	db		" ", EOL
deptStat	db LF, "Department of Statistics:", EOL
allocMsg	db TAB, "There are %d out of %d memory allocations "
			db "remaining after call to freeList.", LF, EOL
errFmt		db "ERROR: %s is not a valid directory!", LF, EOL
path_sep	db "/", EOL
blankline	db EOL
unsorted	db LF, "Insertion sorted List:", EOL 
bsorted		db LF, "Bubblesorted List:", EOL
qsorted		db LF, "Quicksorted List:", EOL
dt_unknown	db	"(unknown)", EOL		; dirent file types
dt_fifo		db	"(fifo)", EOL
dt_chr		db	"(char)", EOL
dt_blk		db	"(block)", EOL
dt_dir		db	"(dir)", EOL	 
dt_reg		db	"(reg)", EOL
dt_link		db	"(link)", EOL
dt_sock		db	"(socket)", EOL
;========================= UNINITIALIZED DATA SECTION =======================
section .bss
path		resb	PATH_MAX
fileName	resb	STR_SIZE
fileType	resb	16
listIndex   times   2 * PATH_MAX dq 0	; max number of linked list elements

pTemp		times STR_SIZE	db 0
pTempi		times STR_SIZE	db 0
pTempj		times STR_SIZE	db 0

nTempi		dq	0
nTempj		dq	0

    STRUC   node
nNameType	resb    STR_SIZE
nType		resb	16
nPrev   	resq     1
nNext   	resq     1
			align	 8
    ENDSTRUC

	STRUC   stat
st_dev      	resq	1
st_ino	    	resq	1
st_mode	    	resq	1
st_nlink		resq	1 
st_uid	    	resq	1 
st_gid	    	resq	1 
st_rdev     	resq	1
st_size      	resq	1
st_blksize   	resq	1
st_blocks       resq	1
st_atime        resq	1
st_atime_nsec   resq    1
st_mtime        resq    1
st_mtime_nsec   resq    1
st_ctime        resq    1
st_ctime_nsec   resq    1
__unused4       resq    1
__unused5       resq    1
	ENDSTRUC

	STRUC	passwd
pw_name		resq	1
pw_uid		resw	1 
pw_gid		resw	1
pw_dir		resq	1
pw_shell	resq	1
	ENDSTRUC

headNode    resb 	node_size		; node_size auto generated by STRUCT node
;=========================== DATA SECTION ===================================
section .data
nRecordCnt		dq		0
nAllocations	dq		0
nMaxAlloc		dq		0
exitCode 		dq		EXIT_SUCCESS
space			db		" "
times STR_SIZE	db	0, EOL
;============================================================================
