;============================================================================
; quicksortPartInt.asm     - NOTE: elements to be sorted are integers.
; John Schwartzman, Forte Systems, Inc.
; 12/25/2023
; Linux x64
;
;============================================================================
ARRAY_SIZE		equ  256
ELEMENT_SIZE	equ	   8

%include "macro.inc"

global	main

%define nLow		qword [rsp +  0]	; for qsortPartInt and partition
%define nHigh		qword [rsp +  8]	; qsortPartInt doesn't need i & j
%define i			qword [rsp + 16]	; but needs nPivot
%define j			qword [rsp + 24]
%define nPivot		qword [rsp + 32]

%define nRecords	qword [rsp +  0]    ; for main

;============================== CODE SECTION ================================
section	.text

;============================================================================
qsortPartitionInt:					; qsort method with partition function
	prologue 6
	mov		nLow, rdi
	mov		nHigh, rsi

.if:
	cmp		rdi, rsi
	jnl		.fin

	call	partition
	mov		nPivot, rax

	mov		rdi, nLow
	mov		rsi, nPivot
	dec		rsi
	call	qsortPartitionInt

	mov		rdi, nPivot
	inc		rdi
	mov		rsi, nHigh
	call	qsortPartitionInt

.fin:
	epilogue

;============================================================================
partition:
	prologue 6
	mov 	nLow, rdi
	mov		nHigh, rsi

	mov		rcx, nHigh
	call	getElement
	mov		nPivot, rax
	mov		rax, nLow
	dec		rax
	mov		i, rax					; i = nLow - 1

	mov		rax, nLow				; prepare j for forLoop
	mov		j, rax

.forLoop:
.if:
	mov		rcx, j
	call	getElement				; rax = array[j]
	cmp		rax, nPivot
	jnl		.endif

	inc		i						; i++
	mov		r8, i
	mov		r9, j
	call	swapij

.endif:
.forLoopTest:
	mov		rax, nHigh
	cmp		j, rax
	jnl		.endForLoop

	inc		j
	jmp		.forLoop				; do another iteration

.endForLoop:
.doSwap:
	mov		r8, i
	inc		r8
	mov		r9, nHigh
	call	swapij

	mov		rax, i
	inc		rax
	epilogue	

;============================================================================
swapij:
	cmp		r8, r9
	je		.fin

	mov		rcx, r8
	mov		rdi, [nTempi]			; temp holding var
	call	getElement				; pTempi contains int from array[i]
	push	rax

	mov		rcx, r9
	mov		rdi, [nTempj]			; temp holding var
	call	getElement				; pTempj contains int from array[j]
	push	rax

	mov		rcx, r8
	pop		rdi
	call	putElement				; rdi contains sinttr from array[j]

	mov		rcx, r9
	pop		rdi
	call	putElement				; rdi contains int from array[i]

.fin:
 	ret

;============================================================================
getElement:							; rcx = index, returns element in rax
	mov		rax, ELEMENT_SIZE
	imul	rcx
	mov		rax, [rax + array]
	ret								; rdi contains array[rcx] on return

;============================================================================
putElement:							; rcx = index, rdi = element
	mov		rax, ELEMENT_SIZE
	imul	rcx
	mov		[rax + array], rdi
	ret

;============================================================================
displayArray:
	prologue 2
	mov		nRecords, rdi			; get nElements to display
	zero	rcx						; rcx is nIndex = 0

.top
	call	getElement				; return: rdi contains int from array
	mov		rsi, rax
	push	rcx
	print	[prtFmtInt]
	pop		rcx
	inc		rcx
	cmp		rcx, nRecords
	jl		.top					; stop at nRecords - 1

	epilogue

;============================================================================
loadArray:
	zero	rcx

.top:
	mov		rdi, [nDigits + 8 * rcx] ; get next value from local storage
	cmp		rdi, -1					; check for sentinal value
	je		.fin
	call	putElement				; place value into the array

	inc		rcx						; prepare for next iteration
	jmp		.top

.fin:
	mov 	rsi, rcx
	lea		rdi, [prtInsTotal]
	push	rcx	
	print
	pop		rcx
	return	rcx						; return nElements found

;============================================================================
main:
	prologue 2
	call	loadArray
	mov		nRecords, rax			; get nElements found by loadArray
	
	
	puts	[unsorted]
	mov		rdi, nRecords
	call	displayArray

	puts	[qsorted]
	zero	rdi
	mov		rsi, nRecords
	dec		rsi						; provide nRecords -1 to qsortPartInt
	call	qsortPartitionInt		; perform quicksort on the array

.fin:
	mov		rdi, nRecords
	call	displayArray
	puts	[blankline]
	epilogue

;================================ DATA SECTION ==============================
section     .data
array		dq		ARRAY_SIZE
nTempi		dq		1
nTempj		dq		1
;================================ DATA SECTION ==============================
;============================================================================
section		.rodata
prtFmtInt	db  TAB, "%2d", LF, EOL
prtInsTotal	db	TAB, "%d elements were inserted.", LF, EOL
unsorted	db LF, "Insertion Sorted Array:", EOL
qsorted		db LF, "Quicksorted Array:", EOL
blankline	db EOL
;============================================================================
section 	.data
nDigits		dq	19, 2, 3, 9, 1, 4, 7, 6, 5, 11, 10, -1
;============================================================================
