;============================================================================
; BubblesortStr.asm     - NOTE: Elements to be sorted are strings.
; John Schwartzman, Forte Systems, Inc.
; Tue Jan 21 03:36:56 PM EST 2025
; Linux x64
;
;============================================================================
%include "macro.inc"

global	bubblesortStr					; global procedure
extern	getElement, swap				; external proccedures
extern	pTempi, pTempj			; external data

%define i			qword [rsp +  0]	; for BubblesortStr
%define j			qword [rsp +  8]
%define bSwapped	qword [rsp + 16]
%define nRecords	qword [rsp + 24]

;============================== CODE SECTION ================================
section	.text

;============================================================================
bubblesortStr:
	prologue 4
	mov		nRecords, rsi			; rdi contains nRecords
	mov		j, rdi					; j = 0 prepare for .doWhileLoop

.doWhileLoop:
.initOuterForLoop:					; j goes from 0 to nRecords - 1
	mov		bSwapped, false			; bSwapped = false
	mov		j, 0

.outerForLoop:
.initInnerForLoop:					; i goes from j + 1 to nRecords
	mov		rax, j
	inc		rax
	mov		i, rax					; i = j + 1

.innerForLoop:
	mov		rcx, i
	lea		rdi, [pTempi]
	call	getElement				; pTempi now contains array[i]
	
	mov		rcx, j
	lea		rdi, [pTempj]
	call	getElement				; pTempj now contains array[j]

	strcasecmp	[pTempi], [pTempj]	; compare pArray[i] and pArray[j]
	jnl		.endInnerForLoop

	mov		r8, i
	mov		r9, j
	call	swap
	mov		bSwapped, true

.endInnerForLoop:
	inc		i
	mov 	rax, i
	dec		rax
	cmp		rax, nRecords
	jl		.innerForLoop

.endOuterForLoop:
	mov		rax, nRecords
	dec		rax
	inc		j
	cmp		j, rax				; is j too large?
	jle		.outerForLoop		; 	jump if no

.endDoWhileLoop:
	mov		rax, bSwapped
	test	rax, rax
	jz		.fin				; get out if !bSwapped
	
	jmp		.initOuterForLoop

.fin:
	epilogue

;============================================================================
