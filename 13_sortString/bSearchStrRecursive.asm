;============================================================================
; bSearchStrRecursive.asm
; John Schwartzman, Forte Systems, Inc.
; Mon Feb  3 04:10:47 PM EST 2025	
; Linux x64	Linked with arrayTools, bubblesortStr, quicksortStr
; Provides a strcasecmp recursive binary search of array.
;============================================================================

%include "macro.inc"

global  bSearchStr
extern	getElement
extern  searchStr, searchStrFmt, searchStrFound, searchStrNotFound, pTemp

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

	cmp		rdi, rsi
	jg		.notFound			; match does not exist

	mov		rax, nHigh
	sub		rax, nLow
	sar		rax, 1				; fast integer divide by 2
	mov		nIndex, rax
	mov		rax, nLow
	add		nIndex, rax			; nIndex = nLow + (nHigh - nLow) / 2

	mov		rcx, nIndex
	lea		rdi, [pTemp]
	call	getElement
	strcasecmp [pTemp], [searchStr]
	jz		.found				; array[nIndex] == key

.lessThan:						; array[nIndex] < key
	jg		.greaterThan

	mov		rdi, nIndex			; prepare for recursive call
	inc		rdi					
	mov		rsi, nHigh
	call	bSearchStr			; recursive call
	jmp		.fin

.greaterThan:					; array[nIndex] > key
	mov		rdi, nLow			; prepare for recursive call
	mov		rsi, nIndex
	dec		rsi
	call 	bSearchStr			; recursive call
	jmp		.fin

.found:
	print2Str1Int	[searchStrFmt], [pTemp], nIndex
	jmp		.fin

.notFound:
	print2Str	[searchStrNotFound], [searchStr]

.fin:
	epilogue

;============================================================================
