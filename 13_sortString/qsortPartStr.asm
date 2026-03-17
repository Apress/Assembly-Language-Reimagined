;============================================================================
; qsortPartStr.asm     - NOTE: elements to be sorted are strings.
; John Schwartzman, Forte Systems, Inc.
; Sat Jan 18 02:04:41 PM EST 2025
; Linux x64
;
;============================================================================

%include "macro.inc"

global	qsortPartStr
extern	getElement, putElement, swap
extern	array, pTempi, pTempj, pPivot	; exported data

; automatic (stack based) variables for partition and qsortPartStr
%define nLow		qword [rsp +  0]
%define nHigh		qword [rsp +  8]
%define nPivot		qword [rsp + 16]
%define i			qword [rsp + 24]	; unused in qsortPartStr
%define j			qword [rsp + 32]	; unused in qsortPartStr

;============================== CODE SECTION ================================
section	.text

;============================================================================
partition:							; partition function for qsortPartStr
	prologue 6

	mov		nLow, rdi
	mov		nHigh, rsi
	mov		nPivot, rsi				; nPivot = nHigh
	mov		j, rdi					; j = nLow
	dec		rdi						; rdi = nLow -1
	mov		i, rdi					; i = nLow - 1

	lea		rdi, [pPivot]			; pPivot <= array[nHigh]
	mov 	rcx, nPivot				; rcx = nPivot = nHigh
	call 	getElement				; [pPivot] now contains array[nPivot]

.forLoop:
	lea		rdi, [pTempj]			; get pTempj
	mov		rcx, j
	call	getElement				; pTempj <- array[j]

	strcasecmp	[pTempj], [pPivot]
	jnl		.next					; if strcasecmp < 0

	inc		i						; 	do this
	mov		r8, i
	mov		r9, j
	call	swap

.next:
	inc 	j						; increment j as per forLoop
	mov		rcx, j
	cmp		rcx, nHigh				; is j <= nHigh?
	jl		.forLoop				; jump if no

.fin:
	mov		r8, i
	inc		r8
	mov		r9, nHigh
	call	swap 	

	mov		rax, i					; partition returns i + 1
	inc		rax
	epilogue

;============================================================================
qsortPartStr:
	prologue 6

	cmp		rsi, rdi				; if nHigh < nLow, return	
	jl		.fin

	mov		nLow, rdi
	mov		nHigh, rsi

	call	partition
	mov		nPivot, rax

.rc1:
	; first recursive call
	mov		rdi, nLow
	mov		rsi, rax
	dec		rsi
	call	qsortPartStr			; qsort(nLow, nPivot - 1)

.rc2:
	; second recursive call
	mov		rdi, nPivot
	inc		rdi
	mov		rsi, nHigh
	call	qsortPartStr			; qsort(nPivot + 1, nHigh)

.fin:
	epilogue

;============================================================================
