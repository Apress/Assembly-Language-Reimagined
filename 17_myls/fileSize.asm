;============================================================================
; fileSize.asm
; John Schwartzman, Forte Systems, Inc.
; 08/20/2024
; Linux x86_64
;============================================================================
%include	"macro.inc"

global		readFileSize, printFileSize
extern		fileName

%define	DIVISOR		1000
%define PETABYTE	DIVISOR * DIVISOR * DIVISOR * DIVISOR * DIVISOR 
%define TERABYTE	DIVISOR * DIVISOR * DIVISOR * DIVISOR 
%define GIGABYTE	DIVISOR * DIVISOR * DIVISOR 
%define MEGABYTE	DIVISOR * DIVISOR 
%define KILOBYTE	DIVISOR 

%define	NUM_VAR		4		; round up to next even value

;================== DEFINE LOCAL VARIABLES for readFileSize ================ =================
%define	nSize		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp +  0
%define	nDividend	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp +  8
%define	buffer		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp +  16

;============================== CODE SECTION ================================
section	.text

printFileSize:					; rdi contains file size
	prologue

	call 	readFileSize        ; formatted output string in left in rax
	lea		rdi, [rax]			; get return value from readFileSize
	print

	epilogue

;============================================================================
readFileSize:
	prologue NUM_VAR

	mov		nSize, rdi
	mov		rax, nSize
	cmp		rax, DIVISOR
	jb		.belowDivisor			; jump if nSize < 1000

	mov		rax, [sizeArray]
	mov		nDividend, rax
	xor		rcx, rcx				; loop count - initialization for loop

.topOfLoop:
	mov		nDividend, rax			; if (nSize < nDividend) continue
	cmp		nSize, rax
	jb		.bottomOfLoop
	jmp		.proceed

.bottomOfLoop:
	inc		rcx						; increment loop count
	mov		rax, [sizeArray + 8 * rcx]
	mov		nDividend, rax
	jmp		.topOfLoop

.proceed:
	modulo	nSize, nDividend		; is there a remainder?
	jz		.integerDivide			;	no remainder
	jmp		.nonIntegerDivide

.integerDivide:						; perform integer division
	mov		rax, nSize				; divide nSize / nMultiplicand
	mov		r8, nDividend
	cdqe							; sign extend rax into rdx
	div 	r8
	lea		rdi, buffer
	lea		rsi, [szModMultiplierZero]	; prepare to print result
	mov		rdx, rax					;  rax contains the quotient
	mov		cl,	byte [rangeArray + rcx]
	sprint
	jmp		.fin

.nonIntegerDivide:					; perform the floating point division
	movsd	xmm0, nSize
	movsd	xmm1, nDividend
	divsd	xmm0, xmm1
	lea		rdi, buffer
	lea		rsi, [szModMultiplierNotZero]
	zero	rdx
	mov		dl, byte [rangeArray + rcx]
	mov		eax, ONE
	call	sprintf
	jmp		.fin

.belowDivisor:
	lea		rdi, buffer
	lea		rsi, [szFmt]
	mov		rdx, nSize
	sprint

.fin:
	lea		rax, buffer

.exit:
	epilogue

;============================================================================

%ifdef __MAIN__	;============================================================

main:
	prologue
	
 	mov		rcx, -1					; starting position

.runFileSize:
	inc		rcx
	push	rcx
	mov		rdi, [nFileSizes + 8 * rcx]
	cmp		rdi, ZERO		; sentinal value is -1
	jl		.fin

	call	printFileSize
    putchar LF
	pop		rcx
	jmp		.runFileSize

.fin:
	epilogue

%endif	;===================== __MAIN__ =====================================

;============================================================================
section		.rodata

szFmt					db	"%5lld ", EOL
szModMultiplierZero		db	"%4lld.0%c ", EOL
szModMultiplierNotZero	db	"%4.1f%c ", EOL

rangeArray				db		'P', 'T', 'G', 'M', 'K'

sizeArray				dq		PETABYTE, \
								TERABYTE, \
								GIGABYTE, \
								MEGABYTE, \
								KILOBYTE

section     .data

nFileSize				dq	0

%ifdef __MAIN__	;============================================================

nFileSizes	dq		0, 	 0, 10,		100,	999,
			dq		1000, 	1121,   21000, 22007,
			dq		22107,	1250000, 135000000, 
			dq		13500000000, 13500000000000, 0, -1

%endif	;===================== __MAIN__ =====================================
;============================================================================
