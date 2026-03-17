;============================================================================
; quicksortStr.asm     - NOTE: elements to be sorted are strings.
; John Schwartzman, Forte Systems, Inc.
; 01/23/2024
; Linux x64
;
;============================================================================
%include "macro.inc"

global	quicksortStr				; global procedures
extern	listIndex, nTempi, nTempj	; external variables

%define nLow		qword [rsp +  0]	; for QuicksortStr
%define nHigh		qword [rsp +  8]
%define i			qword [rsp + 16]
%define	j			qword [rsp + 24]
%define nPivot		qword [rsp + 32]

;============================== CODE SECTION ================================
section	.text

;============================================================================
quicksortStr:
	prologue 6
    mov		nLow, rdi
	mov		nPivot, rdi
	mov		nHigh, rsi				; nHigh = nRecords - 1

.firstIf:
	cmp		rdi, rsi
	jnl		.fin

	mov		nPivot, rdi				; nPivot = nLow
	mov		i, rdi					; i = nLow
	mov		j, rsi					; j = nHigh = nRecords - 1

.outerWhile:
	mov		rax, i
	cmp		rax, j
	jnl		.endOuterWhile

.while1:
	mov		rax, i
	cmp		rax, nHigh				; i < nHigh is 1st part of the AND condition
	jnl		.endWhile1

	mov		rcx, i
	mov		rdi, [listIndex + 8 * rcx]

	mov		rcx, nPivot
	mov		rsi, [listIndex + 8 * rcx]

	strcasecmp
	jle		.endWhile1

	inc		i
	jmp		.while1

.endWhile1:
.while2:
	mov		rcx, j
	mov		rdi, [listIndex + 8 * rcx]

	mov		rcx, nPivot
	mov		rsi, [listIndex + 8 * rcx]

	strcasecmp
	jng	.endWhile2

	dec		j
	jmp		.while2

.endWhile2:
.secondIf:
	mov		rax, i
	cmp		rax, j
	jnl		.endSecondIf

	; swap [listIndex + 8 * i] and [listIndex + 8 * jj
	mov		rcx, i
	mov		[listIndex + 8 * rcx], rdi

	mov		rcx, j
	mov		[listIndex + 8 * rcx], rsi

	jmp		.outerWhile

.endSecondIf:
	; swap [listIndex + 8 * nPivot] and [listIndex + 8 * j]
	mov		rcx, nPivot
	mov		[listIndex + 8 * rcx], rdi

	mov		rcx, j
	mov		[listIndex + 8 * rcx], rsi

.endOuterWhile:
.firstRecursion:
	mov		rdi, nLow
	mov		rsi, j
	dec		rsi
	call	quicksortStr			; QuicksortStr(nLow, j - 1)

.secondRecursion:
	mov		rdi, j
	inc		rdi
	mov		rsi, nHigh
	call	quicksortStr			; QuicksortStr(j + 1, nHigh)

.endFirstIf:
.fin:
	epilogue

;============================================================================
