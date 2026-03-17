;============================================================================
; sum.asm - retrieve floats from cmdline and compute sum of floats
; John Schwartzman, Forte Systems, Inc.
; 06/08/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
LF              equ		10			; ASCII linefeed char
EOL             equ		 0			; end of line
ARG_SIZE		equ		 8			; size of argv vector & size of a push
VAR_SIZE		equ 	 8			; each local var is 8 bytes
NUM_VAR			equ		 6			; number local var (round up to even num)

;========================== DEFINE LOCAL VARIABLES ==========================
%define		index 		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define		argc 		qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define		argv0 		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define     sum         qword [rsp + VAR_SIZE * (NUM_VAR - 3)]  ; rsp + 24
%define		tmpR12		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]  ; rsp + 32

;============================== CODE SECTION ================================
section	.text
global	main							; gcc linker expects main, not _start
extern printf, atof						; tell linker about externals

main:									; program starts here
	push	rbp							; set up stack frame
	mov		rbp, rsp					; set up stack frame - stack is aligned
    sub     rsp, NUM_VAR * VAR_SIZE		; make space for local variables
										; set local variables
	pxor	xmm0, xmm0					; initialize xmm0 to 0.0
	movsd	sum, xmm0					; save it in sum
	mov		index, 1					; index = 1
	mov		argc, rdi					; argc  = rdi (1st arg to main)
	mov		argv0, rsi					; argv0 = rsi (2nd arg to main)
	mov		tmpR12, r12					; r12 is callee saved reg we need		

	lea		rdi, [newLine]				; print blank line
	xor		rax, rax
	call	printf

argvLoop:								; print each argv[i] - do-while loop
	mov		rsi, index					; 2nd arg to printf - index
	mov		rax, argv0
	mov		rdi, [rax + rsi * ARG_SIZE]	; 3rd arg to printf - rdx => argv[i]
	mov		r12, rdi					; save rdi to r12
	or		rdi, rdi					; is there an argv[i]?
	jz 		next						;	jump if no
    call    atof						; double is placed in xmm0

next:
	movsd	xmm1, sum					; xmm1 = sum
	addsd	xmm1, xmm0					; xmm1 = xmm1 + xmm0
	movsd	sum, xmm1					; save sum = xmm1

	lea		rdi, [formatVal]			; 1st arg to printf - formatVal string
	mov		rsi, index					; 2nd arg to printf - index
	mov		rdx, r12					; 3rd arg to printf - restore rdx from r12
	call	printsd						; print scalar double (argv[i])

	inc		index						; index++
	mov		rax, index
	cmp		rax, argc					; index == argc?
	jl		argvLoop					; 	jump if no - print more argv[]

	lea		rdi, [formatSum]			; print sum
	movsd	xmm0, sum					; sum must be in xmm0 for printf
	call	printsd

	xor		rax, rax					; return EXIT_SUCCESS

finish:									; === end of the program ===
	mov		r12, tmpR12					; restore calee saved reg r12
	leave								; undo 1st 2 instructions in main
	ret									; return from main with retCode in rax

;============================== LOCAL METHODS ===============================
printsd:		; print sclar double - rdi, rsi and rdx are args to print
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned
	
	mov		rax, 1					; one floating point arg (Xmm0) to printf
	call	printf

	leave							; undo 1st 2 instructions of printsd
	ret

;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
formatVal	db 	"argv[%d] = %s = %.2f", LF, EOL		; double must be in xmm0
formatSum	db  LF, "sum     = %.2f", LF, LF, EOL	; double must be in xmm0
newLine		db	LF, EOL
;============================================================================
