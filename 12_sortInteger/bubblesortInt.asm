;============================================================================
; bubblesortInt.asm     - NOTE: Elements to be sorted are 8-byte qwords.
; John Schwartzman, Forte Systems, Inc.
; 11/22/2023
; Linux x64
;
;============================================================================
%include "macro.inc"

global	bubblesortInt					; global procedure
extern	getElement, putElement, swapij	; extern procedure
extern	array, nTempi, nTempj			; extern data

%define i			qword [rsp +  0]	; for bubblesortInt
%define j			qword [rsp +  8]
%define nRecords	qword [rsp + 16]
%define bSwapped	qword [rsp + 24]

;============================== CODE SECTION ================================
section	.text

;============================================================================
bubblesortInt:
	prologue 4
	mov		nRecords, rsi			; rsi contains nRecords
	mov		i, 0					; j = 0 prepare for 1st iteration of outer
	mov		j, 0
.outerLoop:
	mov		bSwapped, 0				; change bSwapped flag to clear
	mov		j, 0

.testOuterLoop:
	mov		rax, nRecords
	dec		rax
	cmp		i, rax
	jnl		.fin

.innerLoop:
.testInnerLoop:
	mov		rax, nRecords
	sub		rax, i
	dec		rax
	cmp		j, rax
	jnl		.endInnerLoop

.doInnerLoop:
	mov		rcx, j
	call	getElement				; get array[j]
	mov		[nTempi], rax

	mov		rcx, j
	inc		rcx
	call	getElement				; get array[j + 1]
	mov		[nTempj], rax

.if:
	mov		rax, [nTempi]			; compare array[j] and array[j + 1]
	cmp		rax, [nTempj]			; signed comparison - jump (don't swap) if i <= j
	jng		.endif					; jng => ascending sort / jg => descending sort

	mov		r8, j					; swap array[j] and array[j + 1]
	mov		r9, j
	inc		r9
	call	swapij
	mov		bSwapped, 1				; chenge bSwapped flag to set

.endif:
	inc		j
	jmp		.innerLoop

.endInnerLoop:
.endOuterLoop:
	testop	bSwapped				; have we swapped during the outer loop?
	jz		.fin					;	jump if no

	inc		i
	jmp		.outerLoop

.fin:
	epilogue

;============================================================================
