;============================================================================
; macro.inc - x64 assembly language macros
; John Schwartzman, Forte Systems, Inc.
; Sun Sep 29 03:36:25 PM EDT 2024
; Linux x64 yasm
;
;============================================================================
LF			    equ	  10		; ASCII linefeed char
TAB				equ	   9		; ASCII horizontal tab
ESC				equ	  27		; ASCII escape char
SPACE			equ	  32		; ASCII space char
EOL			    equ	   0		; end of line
VAR_SIZE		equ	   8		; each local var is 8 bytes
PATH_MAX		equ	 256
false			equ	   0
true		  	equ	   1
EXIT_SUCCESS	equ	   0
EXIT_FAILURE	equ	   1

default	rel

extern 	printf, puts			; tell assembler/linker about externs
extern	strcmp, strcat, strlen
extern	strncmp
extern	strncpy, strcpy
extern	strcasecmp
extern	malloc, free
extern	memcpy, memmove
extern 	chdir, strncat
extern	lstat, getpwnam

;=============================== DEFINE MACROS ==============================
%macro      zero    1
    xor     %1, %1					; clear register
%endmacro

%macro prologue	0					;=== prologue macro takes 0 arguments ===
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
%endmacro

%macro prologue	1					;=== prologue macro takes NUM_VAR arg ===
	prologue
	localvar %1
%endmacro

%macro epilogue 0
	leave							; restore stack
	ret								; return 
%endmacro

%macro epilogue 1
	mov		rax, %1					; provide a return value
	epilogue
%endmacro

%macro return 1
	mov		rax, %1
	ret
%endmacro

%macro chdir 0
	call	chdir
	rdflags rax
%endmacro

%macro chdir 1
	lea		rdi, %1					; path
	chdir							; getFileType needs us to chdir 
%endmacro

%macro localvar 1
	sub		rsp, %1 * 8	; make space on stack for local qword variables
%endmacro

%macro memcpy 0
	call	memcpy
%endmacro

%macro memcpy 1
	mov		rdx, %1
	memcpy
%endmacro

%macro memmove 0
	call	memmove
%endmacro

%macro memmove 1
	mov		rdx, %1
	memmove
%endmacro

%macro rdflags 1
	test	%1, %1					; read rflags (could also be and %1, %1)
%endmacro

%macro strcasecmp 0					; case insensitive string comparison
	call	strcasecmp				; strcmp changes rax, test checks flags
	test	eax, eax
%endmacro

%macro strcasecmp 2					; case insensitive string comparison
	lea		rdi, %1
	lea		rsi, %2
	strcasecmp						; strcmp changes rax
%endmacro

%macro strcmp 0
	call	strcmp					; strcmp changes rax, test checks flags
	test	eax, eax
%endmacro

%macro strcmp 2
	lea		rdi, %1
	lea		rsi, %2
	strcmp							; strcmp changes rax
%endmacro

%macro rdstruc 2					; %1 => struc, %2 = offset into struc
	mov		rdi, %1					; struct
	add		rdi, %2					; offset
    lea     rdi, [rdi]				; dest string
%endmacro 

%macro strEndsWith 0
	call	strncmp					; compare the last 5 char
	test	eax, eax
%endmacro

%macro print 0
	zero	eax						; no floating point args
	call	printf
%endmacro

%macro print 1
	lea		rdi, %1					; 1st arg to printf
	print
%endmacro

%macro print 2
	lea		rdi, %1					; 1st arg to printf
	lea		rsi, %2					; 2nd arg to printf
	print
%endmacro

%macro print 3
	lea		rdi, %1					; 1st arg to printf
	mov		rsi, %2					; 2nd arg to printf
	mov		rdx, %3					; 3rd arg to printf (size)
	print
%endmacro

%macro puts 0						; puts always prints blank line at end
	call	puts
%endmacro

%macro puts 1
	lea		rdi, %1
	puts
%endmacro

%macro strcat 0
	call 	strcat
%endmacro

%macro strcat 2
	lea		rdi, %1		; dest
	lea		rsi, %2		; src
	strcat
%endmacro

%macro strncat 2
	lea		rdi, %1		; dest
	lea		rsi, %2		; src
	strncat
%endmacro

%macro strncat 0
	call strncat
%endmacro

%macro strncat 3
	lea		rdi, %1
	lea		rsi, %2
	mov		rdx, %3
	strncat
%endmacro

%macro strncpy 0
	call	strncpy
%endmacro

%macro strncpy 1
	mov		rdx, %1				; count
	strncpy
%endmacro

%macro strncpy 3
	lea		rdi, %1				; dest
	lea		rsi, %2				; src
	mov		rdx, %3				; count
	strncpy
%endmacro

%macro strncpy 4
	lea		rdi, %1				; dest
	lea		rsi, [%2 + %3]		; src + offset
	mov		rdx, %4				; count
	strncpy
%endmacro

%macro strcpy 0					
	call	strcpy				; rdi = dest, rsi = src
%endmacro

%macro strcpy 2
	lea		rdi, %1				; dest
	lea		rsi, %2				; src
	strcpy
%endmacro

%macro push2 2
	push	%1
	push	%2
%endmacro

%macro pop2 2
	pop		%2
	pop		%1
%endmacro

%macro strlen 0
	call	strlen
%endmacro

%macro strlen 1
	lea		rdi, %1
	strlen
%endmacro

%macro malloc 0
	call	malloc
	rdflags	eax
%endmacro

%macro malloc 1
	mov		rdi, %1
	malloc
%endmacro

%macro	free 0
	call	free
%endmacro

%macro free 1
	mov		edi, %1
	free
%endmacro

%macro	testop 1
	mov		rax, %1
	test	rax, rax
%endmacro

%macro	swapreg	2
	push	%1						; swap two registers
	push	%2
	pop		%1
	pop		%2
%endmacro

%macro setPenColor 1
	sub		rsp, 16					; position stack for 2 pushes
	push	rcx
	push	rsi
	print	%1						; print embedded ASCII code to console
	pop		rsi
	pop		rcx
	add		rsp, 16					; restore stack
%endmacro

%macro	clearPenColor 0
	setPenColor [RESET]
%endmacro

%macro lstat 0
	call lstat
%endmacro

%macro lstat 2
	lea	rdi, %1
	lea rsi, %2
	lstat
%endmacro

%macro getpwnam 0
	call getpwnam
%endmacro

;========================================================================