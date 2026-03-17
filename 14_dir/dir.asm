;============================================================================
; dir.asm - retrieve ls info from the OS and print it
; John Schwartzman, Forte Systems, Inc.
; 11/25/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
NUM_VAR			equ	   6
ARG_SIZE		equ	   8		; size of argv vector
PATH_SEP		equ	  47		; ASCII '/' char
D_TYPE_OFFSET	equ	  18		; offset to dirent->d_type
D_NAME_OFFSET	equ	  19		; offset to dirent->d_name

%include "macro.inc"

global	main
global	fileName
; extern	opendir, readdir, closedir	; tell assembler/linker about ext

DT_UNKNOWN	equ	 0				; dirent file types
DT_FIFO		equ	 1
DT_CHR		equ	 2
DT_BLK		equ  6
DT_DIR		equ	 4
DT_REG		equ	 8
DT_LNK		equ	10
DT_SOCK		equ	12
;========================== DEFINE LOCAL VARIABLES ==========================
%define	argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define	argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define	dir			qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define	type		qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp + 24
%define dirent  	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]  ; rsp + 32
%define nEntries	qword [rsp + VAR_SIZE * (NUM_VAR - 1)]	; rsp + 40
;============================== CODE SECTION ================================

section	.text

main:
	prologue NUM_VAR				; setup stack and space for 6 local var
	mov		argc, rdi				; argc  = rdi (1st arg to main)
	mov		argv0, rsi				; argv0 = rsi (2nd arg to main)
	zero	rax
	mov		nEntries, rax

	cmp		rdi, 1					; more than 1 arg?
	je		.getDefaultPath			;   jump if no

	lea		rdi, [path]				; rdi => path[]  <= dest
	mov		rsi, [rsi + ARG_SIZE]	; rsi => argv[1] <= src
	strcpy
	jmp		.terminatePath

.getDefaultPath:
	strcpy	[path], [current_dir]	;  path = "./"

.terminatePath:
	lea		rdi, [path]
	strlen							; rax = strlen(path)

	lea		rdi, [path]
	dec		rax						; rax => last char of path
	mov		dl, PATH_SEP
	cmp		[rdi + rax], dl			; does rdi end with a '/'?
	je		.chdir					; 	jump if yes

	inc		rax						; strlen++
	lea		rdi, [path]
	mov		[rdi + rax], dl			; append '/'
	inc		rax						; strlen++
	zero	dl
	lea		rdi, [path]
	mov		[rdi + rax], dl			; append EOL

.chdir:
	lea		rdi, [path]
	chdir							; getFileType needs us to chdir 
	or		rax, rax				; successfully changed dir?
	je		.opendir				;	jump if yes

	lea		rsi, [path]				; invalid directory selection
	print	[errFmt]				; print error message
	jmp		.fin					; and exit

.opendir:
	lea		rdi, [path]
	opendir							; rax = opendir(path)
	mov		dir, rax				; save dir
	rdflags	rax						; is dir null?
	jz		.fin					;    jump if yes 

.top_of_loop:
	mov     rdi, dir
	readdir							; rax = readdir(dir)
	mov	    dirent, rax				; Dirent <- rax
	rdflags	rax						; is dirent NULL?
	jz		.fin					;    jump if yes (exit)

	rdstruc dirent, D_TYPE_OFFSET	; get file  type
	mov		rax, [rdi]

	cmp		al, DT_REG
	lea		rdx, [dt_reg]			; 3rd arg to print
	je		.printFileType

	cmp		al, DT_DIR
	lea		rdx, [dt_dir]			; 3rd arg to print
	je		.printFileType

	cmp		al, DT_LNK
	lea		rdx, [dt_lnk]			; 3rd arg to print
	je		.printFileType

	cmp		al, DT_FIFO
	lea		rdx, [dt_fifo]			; 3rd arg to print
	je		.printFileType

	cmp		al, DT_CHR
	lea		rdx, [dt_chr]			; 3rd arg to print
	je		.printFileType

	cmp	al, DT_BLK
	lea		rdx, [dt_blk]			; 3rd arg to print
	je		.printFileType

	cmp		al, DT_SOCK
	lea		rdx, [dt_sock]			; 3rd arg to print
	je		.printFileType

	lea		rdx, [dt_unknown]		; 3rd arg to print  - file type

.printFileType:						; rdx = file type string 3rd arg to printf
	rdstruc dirent, D_NAME_OFFSET	; get directory name
	lea		rsi, [rdi]				; 2nd arg to printf - file name
	print	[prtFmt]				; 1st arg to printf - fmt str
	inc		nEntries
	jmp		.top_of_loop			; continue for other dir entries

.fin:
	mov		rsi, nEntries
	print	[prtFmtTotal]
	mov	    rdi, dir
	closedir						; closedir(dir)
	epilogue

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
prtFmt		db TAB, "%s (%s)", LF, EOL
prtFmtTotal	db "%2d entries found.", LF, LF, EOL
current_dir	db "./", EOL
errFmt		db "%s is not a valid directory!", LF, EOL
dt_unknown	db	"unknown", EOL		; dirent file types
dt_fifo		db	"fifo", EOL
dt_chr		db	"char", EOL
dt_blk		db	"block", EOL
dt_dir		db	"dir", EOL	 
dt_reg		db	"reg", EOL
dt_lnk		db	"link", EOL
dt_sock		db	"socket", EOL

section  .bss
fileName	resb	STD_STR_LEN
path		resb	256
;============================================================================
