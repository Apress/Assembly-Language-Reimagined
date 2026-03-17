;============================================================================
; bsortStr.asm
; John Schwartzman, Forte Systems, Inc.
; 12/07/2023		Linked with arrayTools, bubblesortStr, quicksortStr
; Linux x64
;
;============================================================================
ARRAY_SIZE			equ 4096
ELEMENT_SIZE		equ	  64

%include "macro.inc"

global	main
extern	bubblesortStr					; external procedures
global	array, pTemp, pTempi, pTempj	; exported data
global	getElement, putElement, swapij
global	displayArray

%define nRecords	qword [rsp + 0]		; for main, loadArray, displayArray

;============================== CODE SECTION ================================
section	.text

;============================================================================
swapij:
	mov		rcx, r8
	lea		rdi, [pTempi]			; temp holding var
	call	getElement				; pTempi contains str from array[i]

	mov		rcx, r9
	lea		rdi, [pTempj]			; temp holding var
	call	getElement				; pTempj contains str from array[j]
	
	mov		rcx, r8
	lea		rsi, [pTempj]
	call	putElement				; rdi contains str from array[j]

	mov		rcx, r9
	lea		rsi, [pTempi]
	call	putElement				; rdi contains str from array[i]

 	ret

;============================================================================
getElement:							; rcx = index, returns element in rsi
	mov		rax, ELEMENT_SIZE
	imul	rcx
	lea		rsi, [rax + array]
	push	rcx
	strcpy
	pop		rcx
	ret								; rsi contains array[rcx] on return

;============================================================================
putElement:							; rcx = index, rsi = int, rdi = dest
	mov		rax, ELEMENT_SIZE
	imul	rcx
	lea		rdi, [rax + array]
	push	rcx
	strcpy
	pop		rcx
	ret

;============================================================================
displayArray:
	prologue 2
	mov		nRecords, rdi			; get nElements to display
	zero	rcx						; rcx is nIndex = 0

.top
	lea		rdi, [pTemp]
	call	getElement
	push	rcx
	print2Str	[arrayFmt], [pTemp]
	pop		rcx
	inc		rcx
	cmp		rcx, nRecords
	jle		.top					; stop at nRecords - 1

	epilogue

;============================================================================
loadArray:
	zero	rcx					; 0
	lea		rsi, [SRC_STR0]
	call	putElement			; create element of string bytes array[i] 

	inc		rcx					; 1
	lea		rsi, [SRC_STR1]
	call	putElement

	inc		rcx					; 2
	lea		rsi, [SRC_STR2]
	call	putElement

	inc		rcx					; 3
	lea		rsi, [SRC_STR3]
	call	putElement

	inc		rcx					; 4
	lea		rsi, [SRC_STR4]
	call	putElement

	inc		rcx					; 5
	lea		rsi, [SRC_STR5]
	call	putElement

	inc		rcx					; 6
	lea		rsi, [SRC_STR6]
	call	putElement

	inc		rcx					; 7
	lea		rsi, [SRC_STR7]
	call	putElement

	inc		rcx					; 8
	lea		rsi, [SRC_STR8]
	call	putElement

	inc		rcx					; 9
	lea		rsi, [SRC_STR9]
	call	putElement

	inc		rcx					; 10
	lea		rsi, [SRC_STR10]
	call	putElement

	inc		rcx						; 1st element is 0
	; mov		rsi, rcx
	push	rcx	
	print1Str1Int	[prtInsTotal], rcx			; print loadArray summary info
	pop		rcx

.fin:
	return	rcx						; return nElements - 1 found
;============================================================================

main:
	prologue 2
	call	loadArray
	mov		nRecords, rax			; get nElements found by loadArray
	
	puts1StrLF	[unsorted]
	mov		rdi, nRecords
	call	displayArray

	puts1StrLF	[bsorted]
	zero	rdi
	mov		rsi, nRecords
	dec		rsi						; bubblesorted wants nRecords - 1
	call	bubblesortStr			; call string version of bubblesort

.fin:
	mov		rdi, nRecords
	call	displayArray
	printLF
	epilogue	0

;================================ DATA SECTION ==============================
section		.rodata
unsorted	db "Insertion ordered array:", EOL
bsorted		db "Bubblesorted array:", EOL
qsorted		db "Quicksorted array:", EOL
blankLine	db EOL
arrayFmt	db  TAB, "%s", LF, EOL
prtInsTotal	db	TAB, LF, "%d elements were loaded.", LF, EOL

SRC_STR0	db  "Fred Flintstone", EOL
SRC_STR1	db  "Barney Rubble", EOL
SRC_STR2	db  "Wilma Flintstone", EOL
SRC_STR3	db  "Betty Rubble", EOL
SRC_STR4	db  "Dino the Dinosaur", EOL
SRC_STR5	db	"Fido the Dogasauraus", EOL
SRC_STR6	db  "Rasputin", EOL
SRC_STR7	db 	"Jack the Giant", EOL
SRC_STR8	db	"Homer the Odyssey", EOL
SRC_STR9	db	"Warner the Brother #2", EOL
SRC_STR10	db	"Warner the Brother #1", EOL
;================================ DATA SECTION ==============================
section	.bss
array		resb	ARRAY_SIZE
pTemp		times ELEMENT_SIZE	resb 1
pTempi		times ELEMENT_SIZE	resb 1
pTempj		times ELEMENT_SIZE	resb 1
;============================================================================