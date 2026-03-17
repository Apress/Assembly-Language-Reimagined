;============================================================================
; qsortInt.asm
; John Schwartzman, Forte Systems, Inc.
; 12/06/2023		Linked with bubblesortStr, quicksortStr
; Linux x64
;
;============================================================================
ARRAY_SIZE		equ  256
ELEMENT_SIZE	equ	   8			; for QuicksortInt

%include "macro.inc"

global	main
extern	quicksortInt					; external procedures
global  getElement, putElement, swapij
global	array, nTempi, nTempj			; exported data

%define nRecords	qword [rsp + 0]		; for main, displayArray
%define	nSortMethod	qWord [rsp + 8]

;============================== CODE SECTION ================================
section	.text

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

	mov		rdx, rdi				; 3rd arg to printf
	mov		rsi, rcx				; 2nd arg to printf
	push	rcx
	print 	[prtInsItem]
	pop		rcx
	inc		rcx
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
	zero	rdi						; rsi = nLow
	mov		rsi, nRecords			; rdi = nHigh
	dec		rsi
	call	quicksortInt			; integer version of quicksort(nLow, nHigh)

.fin:
	mov		rdi, nRecords
	call	displayArray
	puts	[blankline]
	epilogue	0

;================================ DATA SECTION ==============================
section     .bss
array		resq		ARRAY_SIZE
nTempi		resq		1
nTempj		resq		1
;================================ DATA SECTION ==============================
section     .rodata
prtFmtInt	db  TAB, "%2d", LF, EOL
prtInsTotal	db	TAB, LF, "%2d elements were inserted.", LF, EOL
prtInsItem	db	TAB, "Inserted element %2d = %2d", LF, EOL
unsorted	db LF, "Insertion Sorted Array:", EOL
bsorted		db LF, "Bubblesorted Array:", EOL
qsorted		db LF, "Quicksorted Array:", EOL
blankline	db EOL
;============================================================================
section 	.const
nDigits		dq	19, 2, 3, 9, 1, 4, 7, 6, 5, 11, 10, -1
;============================================================================
