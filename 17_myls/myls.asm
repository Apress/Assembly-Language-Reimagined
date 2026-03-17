;============================================================================
; myls.asm - retrieve file metadata from useer and display as ls -lAFh
; John Schwartzman, Forte Systems, Inc.
; 09/20/2024
; linux x86_64
;
;============================ CONSTANT DEFINITIONS ==========================

%include "macro.inc"

NUM_VAR		equ		 4				; num local var main (round up to even num)

;========================== DEFINE LOCAL VARIABLES main ======================
%define		nIndex 		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp +  0
%define		argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp +  8
%define		argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 16
%define		nRecords	qword [rsp + VAR_SIZE * (NUM_VAR - 1)]	; rsp + 24

;============================== CODE SECTION ================================
section	.text
global	main
extern	fileName
extern	readFileInfo, readFileSize, printFileSize
extern	quicksortStr
extern  insertNode, traverseList, freeList
extern	listIndex
extern	totalBytes

;============================================================================
main:
	prologue	NUM_VAR

	mov		argc, rdi				; argc  = rdi (1st arg to main)
	mov		argv0, rsi				; argv0 = rsi (2nd arg to main)

	cmp		argc, ONE				; if there is exactly 1 argument execute myll
	jne		.continue				; 	otherwise execute myls argv0

	execl	[runLLPath], [runLLArg]	; invoke myll
	jz		.fin					; jump if execl was successful

	perror	[execlName]				; report error
	jmp		.fin					;	and get out
	
.continue:
	zero	rax
	mov		nRecords, rax			; nRecords = 0
	inc		rax
	mov		nIndex, rax				; nIndex = 1

	getcwd	[path], 256				; get current working directory
	test	rax, rax				; success?
	jnz		.argvLoop				;	jump if yes
									; set path to current working directory
	perror [getcwdName]				; return errno
	jmp		.fin					; 	and get out

.argvLoop:							; let bash expand wildcards - do-while loop
	mov		rsi, nIndex
	mov		rax, argv0
	mov		rsi, [rax + rsi * ARG_SIZE]	; filename - rsi => argv[nIndex]
	lea		rdi, [fileName]
	strcpy							; rdi -> fileName

	mov		rcx, nRecords		
	push	rcx
	call	insertFile				; add file metadata to list
	pop		rcx

	inc		nRecords				; nRecords++
	inc		nIndex					; nIndex++
	inc		rcx
	mov		rax, nIndex
	cmp		rax, argc				; nIndex == argc?
	jl		.argvLoop				; 	jump if no - END OF .argvLoop

	mov		rdi, argc
	dec		rdi
	call	traverseList
	call	freeList

.fin:
	putchar		LF
	zero		eax
	epilogue	eax					; end of main

;============================================================================
insertFile:							; rcx = record number
 	prologue						; create new node and insert it at front of list

	lea		rsi, [fileName]			; get file name
	push	rcx
	call	readFileInfo			; read file metadata
	pop		rcx

	push	rcx
	call	insertNode				;  create new element - rsi => array[rcx]
	pop		rcx
	inc		rcx
	mov		nRecords, rcx

	epilogue

;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
getcwdName	db 	"getcwd returned", EOL
execlName	db	"execl returned", EOL
errFmt		db	"ERROR: %s is not a valid file or directory!", LF, EOL
runLLPath	db	"/usr/local/bin/myll", EOL
runLLArg	db	"%s", EOL

;========================= UNINITIALIZED DATA SECTION =======================
section .bss
path		resb	256

;============================================================================
