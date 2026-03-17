;============================================================================
; listTools.asm
; John Schwartzman, Forte Systems, Inc.
; 09/05/2024
; Linux x86_64
;
;============================================================================
ELEMENT_SIZE	equ		256

%include "macro.inc"

global	getElement, putElement, swap
extern	QuicksortStr, BubblesortStr		; external procedures
extern	fileName, perm, sFileSize, sFileTime, sUid, sGid, nHardLinks
extern	begItemFmt
global	listIndex
global	array, pTemp, pTempi, pTempj	; exported data
global	insertNode
global	traverseList, freeList
global	dspFmt, listIndex
global	n_sPerm, n_sSize, n_sTime, n_sNameLink
global	sFileInfo0, sFileInfo1, sFileInfo2, sFileInfo3

%define	NODE_NAME			0
%define NODE_PERM	   	   64
%define NODE_SIZE	   	   96
%define NODE_TIME	   	  112
%define NODE_NAME_LINK    128

%define	buffer		qword [rsp + 0]	; for insertNode
%define	nRecords 	qword [rsp + 0]	; for traverseList

;============================================================================
swap:
	prologue

	mov		rcx, r8
	lea		rdi, [pTempi]			; temp holding var
	call	getElement				; pTempi contains str from array[i]

	mov		rcx, r9
	lea		rdi, [pTempj]			; temp holding var
	call	getElement				; pTempj contains str from array[j]
	
	mov		rcx, r8
	lea		rsi, [nTempj]
	call	putElement				; rdi contains qword from listIndex[]

	mov		rcx, r9
	lea		rsi, [nTempi]
	call	putElement				; rdi contains qword from listIndex[]

 	epilogue

;============================================================================
getElement:							; rcx = index, rsi = src, rdi = dest
	mov		rsi, [listIndex + 8 * rcx]
	lea		rsi, [rsi + NODE_NAME]
	push	rcx
	strcpy
	pop		rcx
	ret								; rdi contains array[rcx] on return

;============================================================================
putElement:							; rcx = index, rsi = src, rdi = dest
	mov		rsi, [listIndex + 8 * rcx]
	mov		rdi, [rsi]
	ret								; rdi contains listIndex + 8 * rcx on return

;============================================================================
freeList:
	mov		rax, [headNode]
	mov		rax, [rax + nNext]

.top:
	push	rax
	free	eax						; free the node
	pop		rax
	mov		rax, [rax + nNext]
	cmp		rax, [headNode]
	je		.fin
	jmp		.top

.fin:
	free	eax						; free headNode
	ret

;============================================================================
createHeadNode:
	prologue

	malloc	ELEMENT_SIZE
	jz		.fin

	mov		[rax + nPrev], rax		; head points back to itself
	mov		[rax + nNext], rax		; head points forward to itself
	mov		[headNode], rax

.fin:	
	epilogue

;============================================================================
insertNode:							; rcx contains number of records
	prologue 2

	test	rcx, rcx				; is numEntries 0
	jnz		.continue				;	jump if yes, createHeadNode on nRecord 0 

	call	createHeadNode
	zero	rcx

.continue:
	push	rcx
	malloc	ELEMENT_SIZE			; dataNode_size			; rax => allocation
	pop		rcx
	mov		[listIndex + 8 * rcx], rax	; save allocation in listIndex[]
	jz		.fin

	lea		rsi, [fileName]
	lea		rdi, [rax + NODE_NAME]
	push	rcx						; save insertion index
	push	rax
	strcpy
	pop		rax
	pop		rcx

	lea		rsi, [sFileInfo0]	
	lea		rdi, [rax + NODE_PERM]
	push	rcx						; save insertion index
	push	rax
	strcpy
	pop		rax
	pop		rcx

	push	rax						; get file size
	lea		rsi, [sFileInfo1]
	lea		rdi, [rax + NODE_SIZE]
	strcpy							; copy file size into node
	pop		rax

	push	rax
	lea		rsi, [sFileInfo2]
	lea		rdi, [rax + NODE_TIME]
	strcpy							; copy file mod time into node
	pop		rax

	push	rax
	lea		rsi, [sFileInfo3]
	lea		rdi, [rax + NODE_NAME_LINK]	; copy sNameLink into node
	strcpy
	pop		rax

	; housekeeping - insert new node at head->next
	push	rcx

	mov		rcx, [headNode]			; get head node
	mov		[rax + nPrev], rcx		; new node prev = head

	mov		rcx, [rcx + nNext]		; rcx = head=>next
	mov		[rax + nNext], rcx		; new node next = head->next

	mov		rcx, [headNode]
	mov		[rcx + nNext], rax		; head->next = new node
									; do not change head->prev
	pop		rcx

.fin:
	epilogue

;============================================================================
traverseList:					; retrieve the nodes the way they're sorted
	prologue 2					; and not the way they're inserted
	mov		nRecords, rdi
	zero	rcx

.top:
	mov		rax, nRecords
	cmp		rcx, rax
	; cmp		rcx, nRecords
	je		.fin

	push	rcx

	mov		r10, [listIndex + 8 * rcx]
	lea		rdi, [dspFmt]
	lea		rsi, [r10 + NODE_PERM]		; perm, nHardLinks, sUid, sPid
	lea		rdx, [r10 + NODE_SIZE]		; file size
	lea		rcx, [r10 + NODE_TIME]		; file time
	lea		r8,  [r10 + NODE_NAME_LINK]	; file name, link (if any), * if executable
	print								; display contents of node
	
	pop		rcx
	inc		rcx
	jmp		.top

.fin:
	epilogue

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
nameFmt		db  "%s", LF, EOL
prtInsTotal	db	TAB, LF, "%d elements were loaded.", LF, EOL
dspFmt		db	"%s%s%s%s", LF, EOL

;============================================================================
section	.bss
pTemp		times 64	db 0
pTempi		times 64	db 0
pTempj		times 64	db 0
nTempi		resq		1
nTempj		resq		1

    STRUC   dataNode
n_sName		resb    64
n_sPerm		resb    32
n_sSize		resb	16
n_sTime		resb	16
n_sNameLink	resb	64
nPrev   	resq     1
nNext   	resq     1
    ENDSTRUC

node	istruc	dataNode
		iend

headNode    resq 	  1
listIndex   resq   1024             ; max number of linked list elements

sFileInfo0	resb	64
sFileInfo1	resb	16
sFileInfo2	resb	16
sFileInfo3	resb	64
;============================================================================