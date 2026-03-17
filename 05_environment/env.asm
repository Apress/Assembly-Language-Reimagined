;============================================================================
; env.asm - demonstrates invoking getenv, printf and strncpy 
; env.asm is called by environment.c (environment.c has main())
; env.asm is a simplification of environment.asm
; declaration: int printenv(const char* sDateStr);
; John Schwartzman, Forte Systems, Inc.
; 05/08/2023
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
BUFF_SIZE		equ 	256			; number of bytes in buffer
LF				equ 	 10			; ASCII line feed character
EOL   			equ 	  0			; end of line character
TAB				equ 	  9			; ASCII tab character
NULL            equ       0
;
;============================= MACRO DEFINITION =============================
%macro getPrintEnv	1				;===== getSaveEnv macro takes 1 arg =====
	lea		rdi, [env%1]			; env%1 = ASCIIZ env var name
	call	getenv					; getenv will return with [RAX] => ASCIIZ
    lea     rdi, [fmtStrEnv]
    lea     rsi, [env%1]
    mov     rdx, rax					; rax ==> environment var def string
;   or      rax, rax                ; did getenv() return NULL
;   lea     rcx, [nullLine]
;	cmovz	rdx, rcx			    ;   if yes, use nullLine
    xor		eax, eax				; no floating point arguments
    call    printf
%endmacro							;======== end of getSaveEnv macro =======

;============================== CODE SECTION ================================
section		.text					;============= CODE SECTION =============
global 		printenv				; tell gcc linker we're exporting prntenv
extern 		getenv, printf		 	; tell assembler/linker about externals
									; this module doesn't have _start or main

;============================= EXPORTED FUNCTION ============================
printenv:							
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack now aligned

    mov     rsi, rdi                ; print dateStr (only arg to printenv)
    lea     rdi, [fmtStrDate]
    call    printf

	; get and print environment variables by using macro for each env var
	getPrintEnv HOME
	getPrintEnv HOSTNAME
	getPrintEnv HOSTTYPE
	getPrintEnv CPU
	getPrintEnv PWD
	getPrintEnv TERM
	getPrintEnv PATH
	getPrintEnv SHELL
	getPrintEnv EDITOR
	getPrintEnv MAIL
	getPrintEnv LANG
	getPrintEnv PS1
	getPrintEnv HISTFILE

	xor		rax, rax				; return EXIT_SUCCESS = 0
	leave							; undo 1st 2 instructions
	ret								; return to caller

;========================= READ-ONLY DATA SECTION ===========================
section		.rodata
fmtStrDate	    db LF,  "Environment Variables on %s", EOL
fmtStrEnv       db TAB,  "%s     ", TAB, " = %s", LF, EOL

envHOME			db "HOME", 		EOL
envHOSTNAME		db "HOSTNAME", 	EOL
envHOSTTYPE		db "HOSTTYPE", 	EOL
envCPU			db "CPU", 		EOL
envPWD			db "PWD", 		EOL
envTERM			db "TERM", 		EOL
envPATH			db "PATH", 		EOL
envSHELL		db "SHELL", 	EOL
envEDITOR		db "EDITOR",	EOL
envMAIL			db "MAIL",		EOL
envLANG			db "LANG",		EOL
envPS1			db "PS1",		EOL
envHISTFILE		db "HISTFILE",	EOL

;============================================================================
