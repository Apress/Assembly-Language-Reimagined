;============================================================================
; calcFile2.asm - read and print doubles from calc.txt
; John Schwartzman, Forte Systems, Inc.	- Activity 3.5
; 06/08/2023
; Linux x8; readFile.asm - read and print distro info from file /etc/os-release
; John Schwartzman, Forte Systems, Inc.	- Activity 3.5
; 06/08/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
BUFF_SIZE		equ      32			; number of bytes in buffer
LF				equ 	 10			; ASCII line feed character
EOL   			equ 	  0			; end of line character
TAB				equ 	  9			; ASCII tab character
NULL            equ       0
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  4			; number local var (round up to even num)
;
;=============================== DEFINE MACRO ===============================
%macro      zero    1
	xor     %1, %1
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		fp		qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp +  0
%define     valDbl  qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp + 8
%define     sum     qword [rsp + VAR_SIZE * (NUM_VAR - 2)]  ; rsp + 16

;============================== CODE SECTION ================================
section     .text
global      main                    ; gcc expects to find the label main
extern		printf	                ; tell linker about external functions
extern		fopen, fscanf, fclose	; tell linker about external functions

;============================= LOCAL FUNCTION ===============================
printsd:							; print scalar double
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned

	mov		rax, 1					; one floating point arg
	call    printf

	leave
	ret

;============================= LOCAL FUNCTION ===============================
printBlankLine:
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned

	lea     rdi, [newLine]          ; print blank line
	zero    rax						; zero floating point args
	call    printf

	leave
	ret

;============================================================================

main:								; beginning of program
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned
	sub     rsp, NUM_VAR * VAR_SIZE ; make space on stack for fp

	pxor	xmm0, xmm0				; init sum to double containing 0.0
	movsd	sum, xmm0

openFile:
	lea     rdi, [fileName]			; open file
	lea     rsi, [fileMode]
	call    fopen
	mov     fp, rax                 ; save file pointer fp
	or      rax, rax                ; fopen success?
	jl		exit                    ;   if no, exit

	call	printBlankLine

readFile:
	mov		rdi, fp					; 1st arg to fscanf
	lea		rsi, [scanFmt]			; 2nd arg to fcsanf
	lea		rdx, valDbl				; 3rd arg to fscanf
	call	fscanf
	or      rax, rax                ; read 0 bytes?                ;
	jz      closeFile				;	jump if yes	

	movsd   xmm1, sum	          	; init sum
	addsd   xmm1, xmm0              ; accumulate sum in xmm - xmm1 += xmm0
	movsd   sum, xmm1          		; save sum

	lea     rdi, [argStr]
	call    printsd                  ; print arg
	jmp     readFile

closeFile:

	lea     rdi, [sumStr]
	movsd   xmm0, sum
	call    printsd

	call	printBlankLine

	mov     rdi, fp					; close the file
	call    fclose					; returns with EXIT_SUCCESS (0)                

exit:	
	leave
	ret

;========================= READ-ONLY DATA SECTION ===========================
section     .rodata
fileName	db      "calc.txt", EOL
fileMode    db      "r", EOL
newLine     db      LF, EOL
scanFmt		db		"%f", EOL
argStr      db      TAB, "%.2f", TAB, "+", LF, EOL
sumStr      db      LF, TAB, "= %.2f", TAB, LF, EOL

;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
fileBuf     resb    BUFF_SIZE;
;============================================================================
