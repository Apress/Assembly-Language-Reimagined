;============================================================================
; makeFile.asm - retrieve floats from cmdline and add to calc.txt
; John Schwartzman, Forte Systems, Inc.
; 06/08/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
LF              equ		10			; ASCII linefeed char
EOL             equ		 0			; end of line
ARG_SIZE		equ		 8			; size of argv vector & size of a push
VAR_SIZE		equ 	 8			; each local var is 8 bytes
NUM_VAR			equ		 4			; number local var (round up to even num)

;========================== DEFINE LOCAL VARIABLES ==========================
%define		index 		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp +  0
%define		argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp +  8
%define		argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 16
%define     fp          qword [rsp + VAR_SIZE * (NUM_VAR - 1)]  ; rsp + 40

;============================== CODE SECTION ================================
section	.text
global	main
extern	printf, atof						; tell linker about externals
extern	fopen, fprintf, fclose				; tell linker about externals

main:									; program starts here
	push	rbp							; set up stack frame
	mov		rbp, rsp					; set up stack frame - stack is aligned
	sub     rsp, NUM_VAR * VAR_SIZE		; make space for local variables
										
	mov		argc, rdi					; set local variables
	mov		argv0, rsi
	xor		rax, rax
	mov		index, rax

openFile:
	lea     rdi, [fileName]				; open file
	lea     rsi, [fileMode]
	call    fopen
	mov     fp, rax                 	; save file pointer fp
	or      rax, rax                	; fopen success?
	jl		finish                    	;   if no, exit

argvLoop:								; fprintf each argv[i] - for loop
	inc		index
	mov		rcx, index
	cmp		rcx, argc
	je		closeFile

	mov		rax, argv0
	mov		rdi, fp						; 1st arg to fprintf				
	lea		rsi, [fmtPrintLn]			; 2nd arg to fprintf
	mov		rdx, [rax + rcx * ARG_SIZE]	; 3rd arg to fprintf - rdx = argv[i]
	call	fprintf						; write entry to file
	jmp		argvLoop					; print more argv[]

closeFile:
	mov     rdi, fp						; close the file
	call    fclose						; returns with EXIT_SUCCESS (0) 

	lea		rdi, [fmtNumWrtn]
	mov		rsi, argc			
	dec		rsi
	xor		rax, rax
	call	printf

	xor		rax, rax					; return EXIT_SUCCESS

finish:									; === end of the program ===
	leave								; undo 1st 2 instructions in main
	ret									; return from main with retCode in rax

;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
fileName	db  "calc.txt", EOL
fileMode    db  "w", EOL
fmtPrintLn	db  "%s", LF, EOL
fmtNumWrtn	db	LF, "%d entries written to calc.txt.", LF, LF, EOL
;============================================================================
