;============================================================================
; fileTime.asm
; John Schwartzman, Forte Systems, Inc.
; 08/20/2024
; Linux x64
;============================================================================
%include	"macro.inc"

global		readFileTime, printFileTime

%define	NUM_VAR		2		; round up to next even value

;================== DEFINE LOCAL VARIABLES for printFileTime ================
%define	buffer		qword [rsp + VAR_SIZE * (NUM_VAR - 2)]	; rsp +  0

;============================== CODE SECTION ================================
section	.text

;===========================================================================
readFileTime:
	prologue NUM_VAR

	localtime					; edi contains the file modification time
	mov		[tm], rax

	lea		rdi, buffer
	mov		rsi, 40				; size of buffer
	lea		rdx, [tdFmt]
	mov		rcx, [tm]
	strftime
	lea		rax, buffer			; return buffer to caller in rax
	
	epilogue

;============================================================================

%ifdef __MAIN__	;============================================================

main:
	prologue
	mov     edi, [nFileTime]
	call	printFileTime

.fin:
	epilogue

%endif	;===================== __MAIN__ =====================================

;============================================================================
section     .rodata

tdFmt		db		"%b %-2d %H:%M ", EOL

section		.bss

	struc	tm_type					; structure declaration
		tm_sec		resd	1
		tm_min		resd	1
		tm_hour		resd	1
		tm_mday		resd	1
		tm_mon		resd	1
		tm_year		resd	1
		tm_wday		resd	1
		tm_yday		resd	1
		tm_isdst	resd	1
	endstruc

tm		istruc	tm_type
		iend

;============================================================================
