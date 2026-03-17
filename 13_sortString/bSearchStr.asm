;============================================================================
; bSearchStr.asm
; John Schwartzman, Forte Systems, Inc.
; Fri Feb 28 06:12:33 PM EST 2025	
; Linux x64	Linked with arrayTools, bubblesortStr, quicksortStr
; Provides a strcasecmp iterative binary search of array.
;============================================================================

%include "macro.inc"

global  bSearchStr
extern	getElement
extern  searchStr, pTemp

%define nLow		qword [rsp +  0]	; for bSearchStr
%define nHigh		qword [rsp +  8]
%define nIndex		qword [rsp + 16]

;============================== CODE SECTION ================================
section	.text

;============================================================================
bSearchStr:
	prologue 4					; nLow, nHigh

	mov		nLow, rdi
	mov		nHigh, rsi

.startSearch:
	mov		rax, nLow
	cmp		rax, nHigh
	jg		.notFound			; exit search if (nLow > nHigh)

	mov		rax, nHigh
	sub		rax, nLow
	sar		rax, 1				; fast integer divide by 2
	mov		nIndex, rax			
	mov		rax, nLow
	add		nIndex, rax			; nIndex = nLow + (nHigh - nLow) / 2

	mov		rcx, nIndex
	lea		rdi, [pTemp]
	call	getElement
	strcasecmp	[pTemp], [searchStr]
	jz		.found				; array[nIndex] == key

.lessThan:						; array[nIndex] < key
	jg		.greaterThan

	mov		rax, nIndex
	inc		rax
	mov		nLow, rax
	jmp		.startSearch		; loop - try again with different nLow			

.greaterThan:					; array[nIndex] > key
	mov		rax, nIndex
	dec		rax
	mov		nHigh, rax
	jmp		.startSearch		; loop - try again with different high

.found:
	mov		rax, nIndex
	jmp		.fin	

.notFound:
	mov		rax, MINUS_ONE

.fin:
	epilogue

;============================================================================
