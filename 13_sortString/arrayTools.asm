;============================================================================
; arrayTools.asm	- for sorting strings
; John Schwartzman, Forte Systems, Inc.
; Sun Jan 12 03:13:54 PM EST 2025
; Linux x64
;
;============================================================================
ARRAY_SIZE			equ  256
ELEMENT_SIZE		equ	  64

%include "macro.inc"

extern	quicksortStr, bubblesortStr		; external procedures
global	getElement, putElement, swap
global	displayArray
global	array, pTemp, pTempi, pTempj, pPivot	; exported data

%define nRecords	qword [rsp + 0]		; for displayArray

;============================================================================
swap:								; r8 and r9 contain the indexes to swap
	prologue

	lea		rdi, [pTemp]
	mov		rcx, r8
	call	getElement				; pTemp <- array[r8]
	strcpy

	mov		rax, ELEMENT_SIZE
	imul	r9
	lea		rdi, [array + rax]		; rdi <- array[r9]

	swapreg	rdi, rsi
	strcpy							; array[r9] <- array[r8]

	lea		rsi, [pTemp]
	mov		rcx, r9
	call	putElement				; array[r8] <- array[r9]

 	epilogue

;============================================================================
getElement:							; rcx = index, returns element in rdi
	prologue
	zero	rdx
	mov		rax, ELEMENT_SIZE
	imul	rcx
	lea		rsi, [rax + array]
	push	rcx
	strcpy
	pop		rcx
	epilogue								; rdi contains array[rcx] on return

;============================================================================
putElement:							; rcx = index, rsi = src, rdi = dest
	prologue
	zero	rdx
	mov		rax, ELEMENT_SIZE
	imul	rcx
	lea		rdi, [rax + array]
	push	rcx
	strcpy
	pop		rcx
	epilogue

;============================================================================
displayArray:
	prologue 2
	mov		nRecords, rdi			; get nElements to display
	zero	rcx						; rcx is nIndex = 0

.top
	lea		rdi, [pTemp]
	call	getElement
	push	rcx
	printNumAndStr	[arrayFmt], rcx, [pTemp]
	pop		rcx
	inc		rcx
	cmp		rcx, nRecords
	jle		.top					; stop at nRecords - 1

	epilogue

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
arrayFmt	db  TAB, "%2d. %s", LF, EOL
prtInsTotal	db	TAB, LF, "%ld elements were loaded.", LF, EOL
;================================ DATA SECTION ==============================
section .bss
array			resb	ARRAY_SIZE
;============================================================================
section	.data
pTemp		times ELEMENT_SIZE	db 0
pTempi		times ELEMENT_SIZE	db 0
pTempj		times ELEMENT_SIZE	db 0
pPivot		times ELEMENT_SIZE  db 0
;============================================================================