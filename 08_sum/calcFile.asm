;============================================================================
; readFile.asm - read and print distro info from file /etc/os-release
; John Schwartzman, Forte Systems, Inc.	- Activity 3.5
; 06/08/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
BUFF_SIZE		equ      32			; number of bytes in buffer;============================================================================
; readFile.asm - read and print distro info from file /etc/os-release
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
NUM_VAR			equ		  6			; number local var (round up to even num)
;
;=============================== DEFINE MACRO ===============================
%macro      zero    1
	xor     %1, %1
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		fp		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define		arg0 	qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define		arg1 	qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define		arg2 	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp + 24
%define		arg3 	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 32
%define     sum     qword [rsp + VAR_SIZE * (NUM_VAR - 1)]  ; rsp + 40

;============================== CODE SECTION ================================
section     .text
global      main                    ; gcc expects to find the label main
extern		printf	                ; tell linker about external functions
extern		fopen, fgets, fclose	; tell linker about external functions
extern      atof

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
	zero    eax						; zero floating point args
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
	lea     rdi, [fileBuf]
	mov     rsi, BUFF_SIZE
	mov     rdx, fp
	call    fgets                   ; read into file buffer
	or      rax, rax                ; read 0 bytes?                ;
	jz      closeFile				;	jump if yes	

	lea     rdi, [fileBuf]			; print line of text
	call    atof                    ; val read is in xmm0

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
argStr      db      TAB, "%.2f", TAB, "+", LF, EOL
sumStr      db      LF, TAB, "= %.2f", TAB, LF, EOL

;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
fileBuf     resb    BUFF_SIZE;
;============================================================================

NULL            equ       0
VAR_SIZE		equ 	  8			; each local var is 8 bytes
NUM_VAR			equ		  6			; number local var (round up to even num)
;
;=============================== DEFINE MACRO ===============================
%macro      zero    1
	xor     %1, %1
%endmacro

;========================== DEFINE LOCAL VARIABLES ==========================
%define		fp		qword [rsp + VAR_SIZE * (NUM_VAR - 6)]	; rsp +  0
%define		arg0 	qword [rsp + VAR_SIZE * (NUM_VAR - 5)]	; rsp +  8
%define		arg1 	qword [rsp + VAR_SIZE * (NUM_VAR - 4)]	; rsp + 16
%define		arg2 	qword [rsp + VAR_SIZE * (NUM_VAR - 3)]	; rsp + 24
%define		arg3 	qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp + 32
%define     sum     qword [rsp + VAR_SIZE * (NUM_VAR - 1)]  ; rsp + 40

;============================== CODE SECTION ================================
section     .text
global      main                    ; gcc expects to find the label main
extern		printf	                ; tell linker about external functions
extern		fopen, fgets, fclose	; tell linker about external functions
extern      atof

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
	lea     rdi, [fileBuf]
	mov     rsi, BUFF_SIZE
	mov     rdx, fp
	call    fgets                   ; read into file buffer
	or      rax, rax                ; read 0 bytes?                ;
	jz      closeFile				;	jump if yes	

	lea     rdi, [fileBuf]			; print line of text
	call    atof                    ; val read is in xmm0

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
argStr      db      TAB, "%.2f", TAB, "+", LF, EOL
sumStr      db      LF, TAB, "= %.2f", TAB, LF, EOL

;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
fileBuf     resb    BUFF_SIZE;
;============================================================================
