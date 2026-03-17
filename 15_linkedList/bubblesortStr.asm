;============================================================================
; bubblesortStr.asm     - NOTE: Elements to be sorted are 8-byte qwords.
; John Schwartzman, Forte Systems, Inc.
; 11/20/2023
; Linux x64
;
;============================================================================
 %include "macro.inc"

global	bubblesortStr				; global procedure
extern	getElement, swapij			; external proccedures
extern	listIndex, nTempi, nTempj

%define i			qword [rsp +  0]	; for BubblesortStr
%define j			qword [rsp +  8]
%define bSwapped	qword [rsp + 16]
%define nRecords	qword [rsp + 24]

;============================== CODE SECTION ================================
section	.text

;============================================================================
bubblesortStr:
	prologue 4
	mov		nRecords, rsi			; rsi contains nRecords
	mov		j, rdi					; j = 0 prepare for .doWhileLoop
	cmp		rsi, 2
	jl		.fin

.doWhileLoop:
.initOuterForLoop:					; j goes from 0 to nRecords - 1
	mov		bSwapped, false			; bSwapped = false
	mov		j, 0

.outerForLoop:
	mov		rax, j
	inc		rax
	mov		i, rax					; i = j + 1

.innerForLoop:
	mov		rcx, i
	mov		rdi, [listIndex + 8 * rcx]

	mov		rcx, j
	mov		rsi, [listIndex + 8 * rcx]

	strcasecmp
	jnl		.endInnerForLoop

	; swap listIndex + 8 * i and listIndex + 8 * j
	mov		rcx, i
	mov		[listIndex + 8 * rcx], rsi

	mov		rcx, j
	mov		[listIndex + 8 * rcx], rdi
	mov		bSwapped, true

.endInnerForLoop:
	inc		i
	mov 	rax, i
	cmp		rax, nRecords
	jl		.innerForLoop

.endOuterForLoop:
	mov		rax, nRecords
	dec		rax
	inc		j
	cmp		j, rax					; is j too large?
	jle		.outerForLoop			; 	jump if no

.endDoWhileLoop:
	mov		rax, bSwapped
	test	rax, rax
	jz		.fin					; get out if !bSwapped
	jmp		.initOuterForLoop

.fin:
	epilogue

;============================================================================
