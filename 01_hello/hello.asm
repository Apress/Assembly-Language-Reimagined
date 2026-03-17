;============================================================================
; hello.asm
; John Schwartzman, Forte Systems, Inc.
; Tue 03 Mar 2026 05:07:53 AM EST
; Write an ASCII string to the console
;============================= CONSTANT DEFINITIONS =========================
LF        		equ		10		; ASCII linefeed character
EXIT_SUCCESS	equ  	 0		; Linux apps normally ret 0 to indicate success
STDOUT			equ  	 1		; destination for SYS_WRITE
SYS_WRITE		equ  	 1		; kernel SYS_WRITE service number
SYS_EXIT		equ 	60		; kernel SYS_EXIT service number

;================================ CODE SECTION ==============================
section	.text                   
global 	_start                  ; tell linker and loader where to find _start

_start:
	mov		rdi, STDOUT			; 1st arg to SYS_WRITE - where to write
	lea		rsi, [msg]			; 2nd arg to SYS_WRITE - what to write
	mov		rdx, MSGLEN			; 3rd arg to SYS_WRITE - num char to write
	mov		rax, SYS_WRITE		; prepare to call SYS_WRITE 
	syscall						; invoke Linux kernel SYS_WRITE service
    
	sub		eax, MSGLEN			; syscall ret with rax = num bytes write
	mov		rdi, rax			; 1st arg to SYS_EXIT = 0 if MSGLEN char written
	mov 	rax, SYS_EXIT		; prepare to call SYS_EXIT
	syscall						; invoke Linux kernel SYS_EXI service

;========================== READ-ONLY DATA SECTION ==========================
section 		.rodata
    msg		db 		LF, "Hello, world!", LF, LF
    MSGLEN 	equ 	$-msg
;============================================================================
