;============================================================================
; myll.asm - retrieve ls info from the OS, sort & print it as ls -lAFh 
; John Schwartzman, Forte Systems, Inc.
; Fri Oct 11 05:28:19 PM EDT 2024
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
NUM_VAR			equ	   6		; for main - round up to even number
D_NAME_OFFSET	equ	  19		; offset to dirent->d_name

%include "macro.inc"

global	main
extern	fileName
extern	readFileInfo, readFileSize, printFileSize
extern	quicksortStr
extern  insertNode, traverseList, freeList
extern	listIndex
extern 	totalBytes

;======================= DEFINE LOCAL VARIABLES (main) ======================
%define	argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define	argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define	dir			qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define dirent  	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]  ; rsp + 24
%define nRecords	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 40

;============================== CODE SECTION ================================
section	.text

;============================================================================
main:
	prologue NUM_VAR				; setup stack for 6 local var (5 + 1)
	mov		argc, rdi				; argc  = rdi (1st arg to main)
	mov		argv0, rsi				; argv0 = rsi (2nd arg to main)
	zero	rax
	mov		nRecords, rax			; zero record count

	getcwd	[path], 256				; set path to current working directory

	mov		rdi, argc
	cmp		rdi, ONE				; only one cmd line argument (myll itself)?
	je		.opendir				;	jump if yes

	print	[usageErr]				; we shouldn't get here if myll called with 1 arg
	jmp		.exit					

	lea		rdi, [path]				; append '/' to path
	lea		rsi, [path_sep]
	strcat

	lea		rdi, [path]				; append argv[1] to path
	mov		rsi, argv0
	mov		rsi, [rsi + ARG_SIZE]
	strcat

	lea		rdi, [path]				; append '/' to path
	lea		rsi, [path_sep]
	strcat

	; try iterating over argv[] here
	mov		r9, 0
	mov		rax, argc

	mov		r8,  argv0
	cmp		r8, rax
	jz		.fin
	mov		rsi, [rax + r9 * ARG_SIZE]	; current file name
	lea		rdi, [fileName]
	strcpy
	jmp		.insert

	inc 	r9
	cmp		r9, argc
	jne		.exit

.chdir:
	chdir	[path]					; getFileType needs us to chdir 
	jz		.opendir				;	jump if chdir successfull

	lea		rsi, [path]				; invalid directory selection
	print	[errFmt]				; print error message
	jmp		.exit					; and exit

.opendir:
	lea		rdi, [path]
	opendir							; rax = opendir(path)
	mov		dir, rax				; save dir
	jz		.exit					; jump if dir = null

.top_of_loop:
	mov     rdi, dir
	readdir							; rax = readdir(dir)
	mov	    dirent, rax				; Dirent <- rax
	jz		.fin					; jump to .fin if dirent = null

	rdstruc dirent, D_NAME_OFFSET	; get directory name
	lea		rsi, [rdi]
	lea		rdi, [fileName]
	strcpy							;  copy fileName

	; parent directory filter
	lea		rsi, [parent_dir]		; skip parent dir
	strcmp
	jz		.top_of_loop

	; current directory filter
	lea		rsi, [this_dir]			; skip currrent dir
	strcmp
	jz		.top_of_loop

	; If cmdline includes a wildcard, all files matching the wildcard
	; are included on the command line.

.insert:	 	; create new node and insert it at the front of the list
	lea		rsi, [fileName]
	mov		rcx, nRecords
	call	readFileInfo			; get file metadata including size and time
	
	mov		rcx, nRecords
	call	insertNode				;  create new element - rsi => array[rcx]
	
	inc		nRecords				; point to next record
	jmp		.top_of_loop			; continue for other dir entries

.fin:								; reached end of directory
	zero	rdi						; nLow = 0
	mov		rsi, nRecords			
	dec		rsi						; nHigh = number of records - 1
	call	quicksortStr

	print	[totalFmt]				; readFileSize uses an internal format (can't set rsi)
	mov		rdi, [totalBytes]		; get total accumulated file size
	call	printFileSize			; and display as string
	putchar	LF

	mov		rdi, nRecords
	call	traverseList			; print the list
	call	freeList

.exit:
	mov	    rdi, dir
	closedir						; closrdir(dir)
	putchar	LF

	epilogue EXIT_SUCCESS

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
this_dir		db ".", EOL
parent_dir  	db "..", EOL
errFmt			db "ERROR: %s is not a valid file or directory!", LF, EOL
path_sep		db "/", EOL
totalFmt		db "total ", EOL
usageErr		db "ERROR: Did you mean to call myls?", LF, EOL
;========================= UNINITIALIZED DATA SECTION =======================
section .bss
path	resb	PATH_MAX
;============================================================================
