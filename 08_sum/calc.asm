;============================================================================
; sum.asm - retrieve floats from cmdline and compute sum of floats
; John Schwartzman, Forte Systems, Inc.
; 06/06/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
LF              equ		10			; ASCII linefeed char
EOL             equ		 0			; end of line
ARG_SIZE		equ		 8			; size of argv vector & size of a push
VAR_SIZE		equ 	 8			; each local var is 8 bytes
NUM_VAR			equ		 6			; number local var (round up to even num)

;========================== DEFINE LOCAL VARIABLES ==========================
%define		arg0 	qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define		arg1 	qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define		arg2 	qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define		arg3 	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp + 24
%define     sum     qword [rsp + VAR_SIZE * (NUM_VAR - 2)]  ; rsp + 32

;============================== CODE SECTION ================================
section	.text
global	main							; gcc linker expects main, not _start
extern printf, atof						; tell linker about externals

main:									; program starts here
	push	rbp							; set up stack frame
	mov		rbp, rsp					; set up stack frame - stack is aligned
    sub     rsp, NUM_VAR * VAR_SIZE		; make space for local variables
										; set local variables
    ; movsd   xmm0, [val0]
    ; movsd   arg0, xmm0

    movsd     xmm0, [val0]
    ; mov     arg0, rax
    ; movsd   xmm0, arg0

    movsd   xmm1, [val1]
    ; movsd   arg1, xmm1

    movsd   xmm2, [val2]
    ; movsd   arg2, xmm2

    movsd   xmm3, [val3]
    ; movsd   arg3, xmm3

    movsd   xmm4, [valSum]
    ; movsd   sum, xmm4

    addsd   xmm4, xmm0
    addsd   xmm4, xmm1
    addsd   xmm4, xmm2
    addsd   xmm4, xmm3
    movsd   sum, xmm4

    ; movsd   xmm0, arg0
    ; movsd   xmm1, arg1
    ; movsd   xmm2, arg2
    ; movsd   xmm3, arg3
    ; movsd   xmm4, sum

    lea     rdi, [formatStr]
    mov     rax, 5
    call    printf

    xor     rax, rax
    leave
    ret

;=========================== READ-ONLY DATA SECTION =========================
section		.rodata
formatStr	db  LF, "Sum of %.2f + %.2f + %.2f + %.2f = %.2f", LF, LF, EOL
val0    dq  123.5
val1    dq  234.5
val2    dq -234.5
val3    dq  456.7
valSum  dq  0.0
;============================================================================
