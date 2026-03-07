;============================================================================
; cmdline.asm - retrieve cmdline info from the OS and print it
; John Schwartzman, Forte Systems, Inc.
; Fri 06 Mar 2026 03:54:35
;========================= CONSTANT DEFINITIONS ==========================
LF              equ		10			; ASCII linefeed char
EOL             equ		 0			; end of line
TAB				equ		 9			; ASCII tab char
ARG_SIZE		equ		 8			; size of argv vector & size of a push
VAR_SIZE		equ 	 8			; each local var is 8 bytes
NUM_VAR			equ		 4			; number local var (round up to even num)
STDIN           equ		 0			; file descriptor standard input
STDOUT          equ		 1			; file descriptor standard output
STDERR          equ		 3			; file descriptor standard error

;================================= MACRO DEFINITIONS ========================
%macro zeroReg 1
    xor %1, %1
%endmacro

%macro printChar 0
    call putchar
%endmacro

%macro printChar 1      ; print 
    mov rdi, %1
    printChar
%endmacro

%macro printLF 0        
    mov rdi, LF
    printChar
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		index 		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp +  0
%define		argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp +  8
%define		argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 16

;============================== CODE SECTION ================================
section	.text
global	main						; gcc linker expects main, not _start
extern printf, putchar 				; tell assembler/linker about externals

main:
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned
    sub     rsp, NUM_VAR * VAR_SIZE	; make space for local variables

	xor		rax, rax				; set local variables
	mov		index, rax				; index = 0
	mov		argc, rdi				; argc  = rdi (1st arg to main)
	mov		argv0, rsi				; argv0 = rsi (2nd arg to main)

	lea		rdi, [formatc]			; 1st arg to printf - formatc string
	mov		rsi, argc				; 2nd arg to printf - argc
	call	print					; printf argc

argvLoop:							; print each argv[i] - do-while loop
	lea		rdi, [formatv]			; 1st arg to printf - formatv string
	mov		rsi, index				; 2nd arg to printf - index
	mov		rax, argv0
	mov		rdx, [rax + rsi * ARG_SIZE]	; 3rd arg to printf - rdx => argv[i]
	call	print					; print argv[i]

	inc		index					; index++
	mov		rax, index
	cmp		rax, argc				; index == argc?
    jl		argvLoop				;    jump if no - print more argv[]

    printLF                         ; print a final newline
    zeroReg eax						; retCode = 0 (EXIT_SUCCESS)

finish:								; ==== this is the end of the program ===
	leave							; undo 1st 2 instructions in main
	ret								; return from main with retCode in rax

;============================== LOCAL METHODS ===============================
print:								; rdi, rsi and rdx are args to printf
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned
	
	zeroReg eax        				; no floating point args to printf
	call	printf

	leave							; undo 1st 2 instructions of print
	ret

;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
formatc		db  LF, "argc    = %d",  LF, EOL
formatv		db 	"argv[%d] = %s", LF, EOL
;============================================================================
