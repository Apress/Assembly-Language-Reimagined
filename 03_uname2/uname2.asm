;============================================================================
; uname2.asm - retrieve uname info from glibc and print it
; John Schwartzman, Forte Systems, Inc.
; 09/19/2024
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
UTSNAME_SIZE    equ     65          ; number of bytes in each *_res entry
LF              equ     10          ; ASCII linefeed character
EOL				equ		 0			; end of line

;============================== CODE SECTION ================================
section     .text
global      main                  	; gcc expects to find the label main
extern		uname, printf			; tell asm/linker about external functions

main:   								; beginning of program
	push	rbp						; set up stack frame
	mov		rbp, rsp				; set up stack frame - stack is aligned

	lea 	rdi, [sysname_res]      ; 1st param RDI => structure addr
	call	uname					; invoke glibc function uname
	or		rax, rax				; was uname successful?
	jnz		exit					;	jump if no
									;  marshal arguments for printf
	lea		rdi, [unameFmtStr]		; 1st arg to printf - format string
	lea		rsi, [sysname_res]		; 2nd arg to printf - 1st placeholder
	lea		rdx, [nodename_res]		; 3rd arg to printf - 2nd placeholder 
	lea		rcx, [release_res]		; 4th arg to printf - 3rd placeholder
	lea		r8,	 [version_res]		; 5th arg to printf - 4th placeholder
	lea		r9,  [machine_res]		; 6th arg to printf - 5th placeholder
	xor		rax, rax				; no floating point arguments for printf
	call	printf					; invoke glibc function printf

	xor		eax, eax				; return EXIT_SUCCESS (0)

exit:	
	leave
	ret

;========================= READ-ONLY DATA SECTION ===========================
section     .rodata
unameFmtStr	db      "   OS name:     %s", LF, 	; NOTE: This is a single str
			db		"   node name:   %s", LF,
			db		"   release:     %s", LF,
			db		"   version:     %s", LF,
			db		"   machine:     %s", LF, EOL

;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
sysname_res     resb    UTSNAME_SIZE	; struct utsname buffer
nodename_res    resb    UTSNAME_SIZE
release_res     resb    UTSNAME_SIZE
version_res     resb    UTSNAME_SIZE
machine_res     resb    UTSNAME_SIZE
;============================================================================
