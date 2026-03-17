;============================================================================
; quicksortInt.asm     - NOTE: elements to be sorted are integers.
; John Schwartzman, Forte Systems, Inc.
; 11/11/2023
; Linux x64
;
;============================================================================
ELEMENT_SIZE	equ		8

%include "macro.inc"

global	quicksortInt				; global procedures
extern	array						; extern data
extern	getElement, swapij

%define nLow		qword [rsp +  0] ; for quicksortInt
%define nHigh		qword [rsp +  8]
%define i           qword [rsp + 16]
%define j           qword [rsp + 24]
%define nPivot		qword [rsp + 32]
;============================== CODE SECTION ================================
section	.text

;============================================================================
quicksortInt:
	prologue 6

	mov     nLow, rdi
	mov     nHigh, rsi
	mov		i, rdi
	mov		j, rsi
	mov		nPivot, rdi				; nPivot = nLow

	mov		rax, nLow
	cmp		rax, nHigh
	jnl		.fin

.outerWhile:						; while (i < j)
	mov		rax, i
	cmp		rax, j
	jnl		.doSwap

.firstInnerWhile:
	mov		rax, i					; if i ! lt nHigh, get out
	cmp		rax, nHigh
	jnl		.endFirstInnerWhile

	mov		rcx, i
	call	getElement				; get array[i]
	mov		rsi, rax

	mov		rcx, nPivot				; get array[nPivot]
	call	getElement

	cmp		rsi, rax				; if array[i] ! lte array[nPivot], get out
	jnle	.endFirstInnerWhile

	inc		i
	jmp		.firstInnerWhile		; do another iteration

.endFirstInnerWhile:
.secondInnerWhile:
	mov		rcx, j
	call	getElement
	mov		rsi, rax

	mov		rcx, nPivot
	call	getElement

	cmp		rsi, rax
	jng		.endSecondInnerWhile

	dec		j
	jmp		.secondInnerWhile

.endSecondInnerWhile:
.if:
	mov		rax, j
	cmp		i, rax
	jnl		.endif

	mov		r8, i
	mov		r9, j
	call	swapij

.endif:
	jmp		.outerWhile

.doSwap:
	mov		r8, nPivot				; exchange array[nPivot] and arry[j]
	mov		r9, j
	call	swapij

.firstRecursiveCall:
	mov     rdi, nLow
	mov     rsi, j
	dec		rsi
	call    quicksortInt			; quicksortInt(nLow, j - 1)

.secondRecursiveCall:
	mov     rdi, j
	inc		rdi
	mov     rsi, nHigh
	call    quicksortInt			; quicksortInt(j + 1, nHigh)

.fin:
	epilogue
;
;============================================================================
