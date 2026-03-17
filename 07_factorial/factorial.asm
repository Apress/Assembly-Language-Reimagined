;============================================================================
; factorial.asm
; John Schwartzman, Forte Systems, Inc.
; 05/28/2023
; Linux x64
;============================================================================
%include "macro.inc"
;============================ CONSTANT DEFINITIONS ==========================
ONE             equ       1         ; number 1
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  2			; number local var (round up to even num)
MAX_INPUT       equ      20         ; max size input

;========================== DEFINE LOCAL VARIABLES ==========================
%define		n		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0
%define		fact	qword [rsp + VAR_SIZE * (NUM_VAR - 1)]		; rsp + 8

;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============
global 		main                    ; tell linker about export
extern 		scanf, printf        	; tell assembler/linker about externals

%ifdef __COMMA__                    ;========== use commaSeparate ===========
	extern      commaSeparate
%endif                              ;========================================

%ifdef __MAIN__                     ;============== use main ===============+

main:
	push    rbp
	mov     rbp, rsp
	sub     rsp, NUM_VAR * VAR_SIZE ; make space on stack for n and fact var.

promptUser:
	lea     rdi, [promptFmt]        ; 1st arg to printf
	zeroReg eax
	call    printf                  ; prompt user

	lea     rdi, [scanfFmt]         ; 1st arg to scanf
	lea     rsi, n	                ; 2nd arg to scanf - where to place input
	zeroReg    eax						; no floating point args to scanf
	call    scanf                   ; get x

	cmp     n, MAX_INPUT          	; legal input?
	jg      badInput                ;    jump if no
    cmp     n, ONE               	; legal input?
    jl      badInput                ;    jump if no
	jmp     continue				; skip over badInput section

badInput:
	lea     rdi, [wrongInputStr]	; report bad input and exit
	zeroReg eax
	call    printf
	mov     rax, EXIT_FAILURE
	jmp     promptUser

%endif                              ;================== __MAIN =============

continue:
	mov     rdi, n                	; pass n as 1st and only arg to factorial 
	call    factorial
	mov     fact, rax             	; save factorial of x

	lea     rdi, [outputFmt]        ; 1st arg to printf
	mov     rsi, n					; 2nd arg to printf
	mov     rdx, fact	            ; 3rd arg to printf
	zeroReg eax                     ; no floating point args to printf
	call    printf                  ; print result

%ifdef __COMMA__                    ; == DISPLAY RESULT with commaSeparate ==

	mov     rdi, fact             ; 1st and only arg to commaSeparate
	lea		rsi, [buffer]
	call    commaSeparate

	lea     rdi, [outputFmtCommma]  ; 1st arg to printf
	mov     rsi, n               	; 2nd arg to printf
	lea     rdx, [buffer]           ; 3rd arg to printf
	zeroReg eax						; no floating point args to printf
	call    printf                  ; print "x! = " followed by result

%endif                              ; == DISPLAY RESULT with commaSeparate ==

	zeroReg rax                     ; return EXIT_SUCCESS

fin:
    leave
    ret

;========================== DEFINE LOCAL VARIABLE ===========================
;%define		n	    qword [rsp + VAR_SIZE * (NUM_VAR - 2)]		; rsp + 0

;============================== CODE SECTION ================================
factorial:
	push    rbp
	mov     rbp, rsp
	sub     rsp, NUM_VAR * VAR_SIZE	; make space for n

	cmp     rdi, ONE                ; base case?
	jg      greater                 ;    jump if no

	mov     rax, ONE                ; the answer to the base case
	leave
	ret

greater:
	mov     n, rdi                  ; save n
	dec     rdi                     ; call factorial with n - 1
	call    factorial               ; recursive call to factorial

	mov     rdi, n                  ; restore original n
	imul    rax, rdi                ; multiply factorial(n - 1) * n
	leave
	ret

;==============================  DATA SECTION ===============================
section     .data
buffer	times 32 db 0				; char buffer[32]

;========================= READ-ONLY DATA SECTION ===========================
section 	.rodata	
scanfFmt	    db		"%lld", EOL
promptFmt       db      LF, "Enter a positive integer from 1 to 20: ", EOL
outputFmt	    db		"%ld! = %lld", LF, EOL
outputFmtCommma db      "%ld! = %s", LF, LF, EOL
wrongInputStr   db      "You have entered an invalid number.", LF, LF, EOL

;============================================================================
