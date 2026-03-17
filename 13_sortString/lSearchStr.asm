;============================================================================
; lSearchStr.asm
; John Schwartzman, Forte Systems, Inc.
; Mon Feb  3 04:13:19 PM EST 2025	
; Linux x64	Linked with arrayTools, bubblesortStr, quicksortStr
; Provides a strcasecmp linear (or sequential) search of an array.
;============================================================================

%include "macro.inc"

global  lSearchStr
extern	getElement
extern  searchStr, pTemp

%define nLow		qword [rsp +  0]	; for bSearchStr
%define nHigh		qword [rsp +  8]
%define nIndex		qword [rsp + 16]

;============================== CODE SECTION ================================
section	.text

;============================================================================
lSearchStr:
	prologue 4					; nLow, nHigh

	mov		nLow, rdi
	mov		nHigh, rsi
	zero	rax
	mov		nIndex, -1

.startSearch:
	inc		nIndex
	mov		rcx, nIndex
	lea		rdi, [pTemp]
	call	getElement
	strcasecmp	[pTemp], [searchStr]
	jz		.found					; array[nIndex] == key

	mov		rcx, nIndex
	cmp		rcx, nHigh				; out of range?
	je		.notFound				;	jump if yes

	jmp		.startSearch	

.found:
	mov		rax, nIndex
	jmp		.fin

.notFound:
	mov		rax, -1

.fin:
	epilogue

;============================================================================
