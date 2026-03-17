;============================================================================
; uname.asm - retrieve uname info from the kernel and print it
; John Schwartzman, Forte Systems, Inc.
; Tue 03 Mar 2026 05:07:53 AM EST
; Linux x64
;
;============================ CONSTANT DEFINITIONS ==========================
STDOUT          equ      1          ; file descriptor for terminal
SYS_EXIT        equ     60          ; Linux service ID for SYS_EXIT
SYS_WRITE       equ      1          ; Linux service ID for SYS_WRITE
SYS_UNAME       equ     63          ; Linux service ID for SYS_UNAME
UTSNAME_SIZE    equ     65          ; number of bytes in each *_res entry
LABEL_SIZE      equ     16          ; size of each header
WRITELINE_SIZE  equ      1          ; num bytes to write for linefeed
LF              equ     10          ; ASCII linefeed character
EXIT_SUCCESS	equ		 0			; success return code
EXIT_FAILURE	equ		 1			; failure return code
;============================== CODE SECTION ================================
section     .text
global      _start                  ; ld expects to find the label _start

_start:				    	        ; beginning of program
	lea 	rdi, [sysname_res]      ; 1st param RDI => structure addr
	mov	    rax, SYS_UNAME          ; prepare to call SYS_UNAME
	syscall                     	; call SYS_UNAME to populate .bss section

	mov 	rdi, rax                ; if -1 is ret in RAX, place in RDI and exit
	or      rax, rax                ; update RFLAGS register
	jnz 	exit                    ; exit if error getting SYS_UNAME

	lea 	rsi, [sysname]          ; SYS_WRITE 2nd arg
	call 	writeLabel              ; call local method - print w/o linefeed
	lea 	rsi, [sysname_res]      ; SYS_WRITE 2nd arg
	call 	writeData               ; call local method - print with linefeed
	lea 	rsi, [nodename]         ; print nodename header
	call	writeLabel
	lea 	rsi, [nodename_res]     ; print nodename data
	call 	writeData

	lea 	rsi, [release]          ; print release header
	call 	writeLabel
	lea 	rsi, [release_res]      ; print release data
	call 	writeData

	lea 	rsi, [version]          ; print version header
	call 	writeLabel
	lea 	rsi, [version_res]      ; print version data
	call 	writeData

	lea 	rsi, [domain]           ; print domain header
	call 	writeLabel
	lea 	rsi, [domain_res]       ; print domain data
	call 	writeData

	xor 	edi, edi       		    ; edi = EXIT_SUCCESS - fall into exit

exit:						       
	mov 	rax, SYS_EXIT		    ; exit program - 1st arg rdi = exit code
	syscall                     	; invoke kernel and we're gone

writeLabel: ;===== local method - caller sets 2nd param RSI =====
	mov 	rdi, STDOUT			    ; SYS_WRITE 1st arg
	mov 	rdx, LABEL_SIZE         ; SYS_WRITE 3rd arg
	mov 	rax, SYS_WRITE		    ; Linux service ID
	syscall					        ; invoke kernel
	ret					            ;====== end of writeLabel method =====

writeData:      ;===== local method - caller sets SYS_WRITE 2nd param =====
	mov 	rdi, STDOUT             ; SYS_WRITE 1st arg
	mov 	rdx, UTSNAME_SIZE       ; SYS_WRITE 3rd arg 
	mov 	rax, SYS_WRITE		    ; Linux service ID
	syscall					        ; invoke kernel and fall through to writeNewLine

writeNewLine:				        ;============ local method ============
	mov 	rdi, STDOUT             ; SYS_WRITE 1st arg
	lea 	rsi, [linefeed]         ; SYS_WRITE 2nd arg
	mov 	rdx, WRITELINE_SIZE     ; SYS_WRITE 3rd arg
	mov 	rax, SYS_WRITE		    ; Linux service ID
	syscall                         ; invoke kernel
	ret                             ; ====== end of writeNeLineMethod =======

;========================= READ-ONLY DATA SECTION ===========================
section     .rodata
sysname     db      "   OS name:     "
nodename    db      "   node name:   "
release     db      "   release:     "
version     db      "   version:     "
domain      db      "   machine:     "
linefeed    db      LF	; ASCII linefeed character

;========================== UNINITIALIZED DATA SECTION ======================
section     .bss
sysname_res     resb    UTSNAME_SIZE
nodename_res    resb    UTSNAME_SIZE
release_res     resb    UTSNAME_SIZE
version_res     resb    UTSNAME_SIZE
domain_res      resb    UTSNAME_SIZE
;============================================================================
