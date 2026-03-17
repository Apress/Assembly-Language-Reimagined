;============================================================================
; macro.inc - assembly language macros
; John Schwartzman, Forte Systems, Inc.
; Sat 21 Feb 2026 09:21:37 AM EST
;
;============================ CONSTANT DEFINITIONS ==========================
STDIN           equ       0         ; kbd
STDOUT          equ       1         ; console
STDERR          equ       2         ; console
EXIT_SUCCESS    equ       0         ; return 0 to indicate success
EXIT_FAILURE    equ       1         ; return 1 to indicate failure
EOL   			equ 	  0			; end of line character
TAB             equ       9         ; horizontal tab
LF				equ 	 10			; ASCII linefeed character

;================================= EXTERNS ==================================
extern 	printf, puts, putc, getc   	; tell assembler/linker about externs

;============================ MACRO DEFINITIONS =============================
%macro  zeroReg 1                   ; this macroinstruction takes one arg reg
    xor     %1, %1                  ; reg <== 0, for any size regi
%endmacro

;============================================================================

