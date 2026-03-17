;============================================================================
; macro.inc - x86_64 assembly language macros
; John Schwartzman, Forte Systems, Inc.
; Fri Oct  4 12:14:47 PM EDT 2024
; Linux x86_64 yasm
;
;============================================================================
LF			    equ	   10		; ASCII linefeed char
TAB				equ	    9		; ASCII horizontal tab
ESC				equ	   27		; ASCII escape char
SPACE			equ	   32		; ASCII space char
ASTERISK		equ	   42		; ASCII asterisk char
EOL			    equ	    0		; end of line
VAR_SIZE		equ	    8		; each local var is 8 bytes
ARG_SIZE		equ		8		; size of command line args
PATH_MAX		equ	  256		; max size of Linux file path
STD_STR_LEN		equ	   64
false			equ	    0
true		  	equ	    1
EXIT_SUCCESS	equ	    0
EXIT_FAILURE	equ	    1
ZERO			equ		0
ONE				equ		1

default	rel

extern 	printf, puts, putchar	; tell assembler/linker about externs
extern	strcat, strlen
extern	strncpy, strcpy
extern	strcmp, strncmp, strcasecmp
extern	malloc, free
extern	memcpy, memmove
extern 	chdir, strncat, getcwd
extern	lstat, getpwnam
extern	opendir, readdir, closedir
extern	getpwuid, getgrgid
extern	readlink
extern	perror
extern	sprintf, localtime
extern  strftime, asctime
extern	strstr, strcasestr
extern	execl

;=============================== DEFINE MACROS ==============================
%macro      zero    1
    xor     %1, %1					; clear register
%endmacro

%macro prologue	0					;=== prologue macro takes 0 arguments ===
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned
	and		rsp, -16				; align stack pointer on 16 bit value
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
	mov		eax, %1					; provide a return value
	epilogue
%endmacro

%macro chdir 0
	call	chdir					; will set ZF to 1 if successful
	test	rax, rax
%endmacro

%macro chdir 1
	lea		rdi, %1					; path
	chdir							; getFileType needs us to chdir 
%endmacro

%macro localvar 1
	sub		rsp, %1 * 8	; make space on stack for local qword variables
%endmacro

%macro asctime 0
	call asctime
%endmacro

%macro asctime 1
	mov		rdi %1
	asctime
%endmacro

%macro localtime 0
	call	localtime
%endmacro

%macro localtime 1
	lea		rdi, %1
	localtime
%endmacro

%macro memcpy 0
	call	memcpy
	test	eax, eax
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

%macro print 0						; print changes eax
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
	lea		rdi, %1					; 1st arg to printf (format)
	mov		rsi, %2					; 2nd arg to printf
	mov		rdx, %3					; 3rd arg to printf (size)
	print
%endmacro

%macro puts 0						; puts always prints blank line at end
	call	puts
%endmacro

%macro puts 1
	lea		rdi, %1					; format string
	puts
%endmacro

%macro putchar 0
	call	putchar
%endmacro

%macro putchar 1
	mov		rdi, %1
	putchar
%endmacro

%macro sprint 0						; sprint changes eax
	zero	eax						; no floating point args
	call	sprintf
%endmacro

%macro sprint 3
	lea		rdi, %1					; destination buffer
	lea		rsi, %2					; format ("%lld")
	mov		rdx, %3					; 3rd arg to sprintf (size)
	sprint
%endmacro

%macro strftime 0
	call	strftime
%endmacro

%macro strftime 4
	lea		rdi, %1					; buffer
	mov		rsi, %2					; size of buffer
	lea		rdx, %3					; format
	mov		rcx, %4					; struct tm
	strftime	
%endmacro

%macro strcat 0						; concatenate two strings
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
	test	eax, eax
%endmacro

%macro malloc 1
	mov		edi, %1
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
	test eax, eax					; exit if ZF = 1
%endmacro

%macro lstat 2
	lea	rdi, %1
	lea rsi, %2
	lstat
%endmacro

%macro getpwnam 0
	call 	getpwnam
%endmacro

%macro getpwuid 0
	call getpwuid
%endmacro

%macro getpwuid 1
	mov	edi, %1
	getpwuid
%endmacro

%macro getgrgid 0
	call getgrgid
%endmacro

%macro getgrgid 1
	mov	edi, %1
	getgrgid
%endmacro

%macro opendir 0
	call	opendir
	test	eax, eax
%endmacro

%macro opendir 1
	lea		rdi, %1
	opendir
%endmacro

%macro readdir 0
	call 	readdir
	test	eax, eax
%endmacro

%macro readdir 1
	lea		rdi, %1
	readdir
%endmacro

%macro closedir 0
	call	closedir
%endmacro

%macro closedir 1
	mov		rdi, %1
	closedir
%endmacro

%macro readlink 0
	call	readlink
%endmacro

%macro readlink 3
	lea		rdi, %1					; file name
	lea		rsi, %2					; buffer
	mov		rdx, %3					; buffer size
	readlink
%endmacro

%macro perror 0
	call	perror
%endmacro

%macro	perror 1
	lea		rdi, %1
	perror
%endmacro

%macro getcwd 0						; get current working directory
	call	getcwd					; current working directory is returned in rax
	test	eax, eax				; success?
%endmacro

%macro getcwd 2
	lea		rdi, %1					; path string for curent working directory
	mov		rsi, %2					; size of path string
	getcwd
%endmacro

%macro modulo 2						; modulo
	xor		rdx, rdx
	mov		rax, %1					; rax = dividend
	mov		r8,  %2					; r8  = divisor
	div		r8
	mov		rax, rdx				; return remainder
	test	rax, rax				; ZF = 1 if no remainder
%endmacro

%macro strstr 0						; find sub string
	call strstr
	test	eax, eax				; ZF = 1 if not found
%endmacro

%macro strstr 2
	lea		rdi, %1					; string to search
	lea		rsi, %2					; substring to find
	strstr
%endmacro

%macro strcasestr 0
	call strcasestr
	test eax, eax					; ZF = 1 if not found
%endmacro

%macro strcasestr 2
	lea		rdi, %1
	mov		rsi, %2
	strcasestr
%endmacro

%macro execl 0						; execute a program
	call	execl					; invoke execl
	test	eax, eax				; execl successful (ZF = 1)?
%endmacro

%macro execl 1
	lea		rdi, %1					; path of executable
	execl
%endmacro

%macro execl 2
	lea		rdi, %1					; path of executable
	lea		rsi, %2					; command line argument
	xor		rdx, rdx				; zero additional arguments
	execl
%endmacro

%macro execl 3
	lea		rdi, %1					; path of executable
	lea		rsi, %2					; command line argument
	lea		rdx, %3					; argv0
	xor		rcx, rcx
	execl
%endmacro

;========================================================================	