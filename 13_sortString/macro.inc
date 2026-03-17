;============================================================================
; macro.inc - x64 assembly language macros
; John Schwartzman, Forte Systems, Inc.
; Mon Mar  3 10:24:01 AM EST 2025
; Linux x64 yasm
;
;============================================================================
LF			    equ	  10		; ASCII linefeed char
TAB				equ	   9		; ASCII horizont/al tab
EOL			    equ	   0		; end of line
VAR_SIZE		equ	   8		; each local var is 8 bytes
PATH_MAX		equ	 256
STD_STR_LEN		equ	  64
false			equ	   0
true		  	equ	   1
ZERO			equ	   0
ONE				equ	   1
EXIT_SUCCESS	equ	   0
EXIT_FAILURE	equ	   1
STDIN_FILENO	equ	   0
STDOUT_FILENO	equ	   1
STDERR_FILENO	equ	   2
MINUS_ONE		equ	  -1

; default	rel

extern 	printf, puts, putchar		; tell assembler/linker about externs
extern	strcmp, strcat, strlen
extern	strncpy, strcpy, strstr
extern	strcasecmp
extern	scanf, fgets
extern	malloc, free
extern	memcpy, memmove
extern 	chdir, strncat
extern	time
extern	fopen

;=============================== DEFINE MACROS =============================
%macro time 0
	xor		rdi, rdi
	call	time
%endmacro

%macro	time 1
	time
	mov		[%1], rax
%endmacro

%macro zero 1
    xor     %1, %1					; clear register
%endmacro

%macro prologue	0					;=== prologue macro takes 0 arguments ===
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
	and		rsp, -16
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

%macro chdir 0
	call	chdir
	rdflags rax
%endmacro

%macro chdir 1
	lea		rdi, %1					; path
	chdir							; getFileType needs us to chdir 
%endmacro

%macro localvar 1
	sub		rsp, %1 * 8	; make space on stack for local variables
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
	strcasecmp						; strcmp returnsc rax
%endmacro

%macro strcmp 0
	call	strcmp					; strcmp returns rax, test checks flags
	test	eax, eax
%endmacro

%macro strcmp 2
	lea		rdi, %1
	lea		rsi, %2
	strcmp							; strcmp changes rax
%endmacro

%macro scan 0
	xor		eax, eax				; zero floating point args
	call 	scanf
%endmacro

%macro	scan 2
	lea		rdi, %1					; scan format "^\n"
	lea		rsi, %2					; input variable address
	scan
%endmacro

%macro gets 0
	call fgets
%endmacro

%macro gets 1
	lea		rdi, %1
	mov		rsi, STD_STR_LEN
	mov		rdx, STDIN_FILENO
	gets
%endmacro

%macro rdstruc 2					; %1 => struc, %2 = offset into struc
	mov		rdi, %1					; struct
	add		rdi, %2					; offset
    lea     rdi, [rdi]				; dest string
%endmacro 

%macro print 0
	zero	eax						; no floating point args
	call	printf
%endmacro

%macro print 1
	lea		rdi, %1					; 1st arg to printf
	print
%endmacro

%macro print 2						; print 2 strings
	lea		rdi, %1					; 1st arg to printf
	lea		rsi, %2					; 2nd arg to printf
	print
%endmacro

%macro print 3						; printStrAndNum
	lea		rdi, %1					; 1st arg to printf
	lea		rsi, %2					; 2nd arg to printf
	mov		rdx, %3					; 3rd arg to printf (size)
	print
%endmacro

%macro print1Num 2					; print a single numper
	lea		rdi, %1
	mov		rsi, %2
	print
%endmacro

%macro print1Str 1					; print one string
	lea		rdi, %1
	print
%endmacro

%macro print2Str 2					; print two strings
	lea		rdi, %1
	lea		rsi, %2
	print
%endmacro

%macro print1Str1Int 2
	lea		rdi, %1
	mov		rsi, %2
	print
%endmacro

%macro print2Str1Int 3
	lea		rdi, %1
	lea		rsi, %2
	mov		rdx, %3
	print
%endmacro

%macro printNumAndStr 3
	lea		rdi, %1
	mov		rsi, %2
	lea		rdx, %3
	print
%endmacro

%macro print3Num 4
	lea		rdi, %1
	mov		rsi, %2
	mov		rdx, %3
	mov		rcx, %4
	print
%endmacro

%macro puts 0						; puts always prints blank line at end
	call	puts
%endmacro

%macro putchar 0
	call	putchar
%endmacro

%macro putchar 1
	mov		rdi, %1
	putchar
%endmacro

%macro putLF 0
	mov		rdi, LF
	putchar
%endmacro

%macro puts1StrLF 1
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

%macro strstr 0
	call	strstr
	test	eax, eax
%endmacro

%macro strstr 2
	lea		rdi, %1
	lea		rsi, %2
	strstr
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
	rdflags	rax
%endmacro

%macro malloc 1
	mov		rdi, %1
	malloc
%endmacro

%macro	free 0
	call	free
%endmacro

%macro free 1
	mov		rdi, %1
	free
%endmacro

%macro	testop 1
	mov		rax, %1
	test	rax, rax
%endmacro

%macro	swapreg	2
	push	%1
	push	%2
	pop		%1
	pop		%2
%endmacro


;========================================================================