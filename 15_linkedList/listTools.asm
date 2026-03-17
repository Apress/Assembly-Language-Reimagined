;============================================================================
; listTools.asm
; John Schwartzman, Forte Systems, Inc.
; 02/12/2024
; Linux x64
;
;============================================================================
%include "macro.inc"

global	getElement, putElement, swapij	; exported procedures
global	setPenColor, clearPenColor
global	createHeadNode, insertNode
global	traverseList, freeList
extern	array, pTemp, pTempi, pTempj	; exported data
extern	nTempi, nTempj, nType
extern	nNameType, headNode, nNext, nPrev
extern	node_size, nRecordCnt, nAllocations
extern	listIndex
extern	dt_unknown, dt_fifo, dt_char, dt_block
extern	dt_dir, dt_reg, dt_link, dt_sock
extern	fileType

%define	nRecords 	qword [rsp + 0]	; for traverseList

;============================================================================
freeList:
	prologue
	zero	rcx

.top:
	mov		edi, [listIndex + 8 * rcx]
	test	edi, edi
	jz		.fin

	push	rcx
	free
	pop		rcx
	dec		qword [nAllocations]
	inc		rcx
	jmp		.top

.fin:
	mov		edi, [headNode]
	test	edi, edi				; is there a headNode?
	jz		.exit					;	jump if no

	free
	dec		qword [nAllocations]

.exit:
	epilogue

;============================================================================
createHeadNode:
	prologue
	malloc	node_size				;  node_size is defined by struc node
	jz		.fin

	mov		[rax + nPrev], eax		; head points back to itself
	mov		[rax + nNext], eax		; head points forward to itself
	mov		[headNode], eax
	inc		qword [nAllocations]

.fin:	
	epilogue

;============================================================================
insertNode:
	push	rsi						; save nNameType
	push	rcx						; save insertion index

	malloc	node_size				; rax => allocation
	jz		.fin

	pop		rcx
	mov		[listIndex + 8 * rcx], eax	; save allocation in listindex[]

	pop		rsi						; get nodeNameT
	lea		rdi, [rax + nNameType]	; dest
	push	rax
	strcpy
	pop		rax

	lea		rdi, [rax + nType]
	push	rsi
	push	rax
	lea		rsi, [fileType]
	strcpy
	pop		rax
	pop		rsi

	; housekeeping - insert new node at head's->next
	mov		rcx, [headNode]			; get head node
	mov		[rax + nPrev], rcx		; new node=>prev = head node

	mov		rcx, [rcx + nNext]		; rcx = head=>next
	mov		[rax + nNext], rcx		; new node next = head=>next

	mov		rcx, [headNode]
	mov		[rcx + nNext], rax		; head=>next = new node

	mov		rcx, [headNode]
	mov		rcx, [rcx + nNext]		; rcx = head=>next
	mov		rcx, [rcx + nPrev]		; rcx = head=>next=>prev
	mov		[rcx], rax				; head=>next=>prev = new node
									; do not change head->prev

	inc		qword [nRecordCnt]
	inc		qword [nAllocations]
	
.fin:
	ret

;============================================================================
traverseList:					; retrieve the nodes the way they're sorted
	prologue 2					; and not the way they're inserted
	mov		nRecords, rdi
	zero	rcx

.top:
	cmp		rcx, nRecords				; any records to print?
	je		.fin						;	jump if no

	mov		rsi, [listIndex + 8 * rcx]
	
	; detect a directory listing
	cmp		[rsi], byte SPACE			; is this a directory?
	je		.dirPrint					;	jump if yes

	; detect a regular file
	lea		rdi, [rsi + nType]
	push	rsi
	push	rcx
	lea		rsi, [dt_reg]
	strcmp
	pop		rcx
	pop		rsi
	je		.regPrint

	; detect a link
	lea		rdi, [rsi + nType]
	push	rsi
	push	rcx
	lea		rsi, [dt_link]
	strcmp
	pop		rcx
	pop		rsi
	je		.linkPrint

.regPrint:
	setPenColor [BLUE]
	jmp		.doPrint
	
.dirPrint:
	; we found a directory
	inc		rsi							; skip over space char
	setPenColor [GREEN]					; print directories in GREEN
	jmp		.doPrint

.linkPrint:
	setPenColor [RED]					; print links in RED
	jmp		.doPrint

.doPrint:
	push	rcx
	print	[listFmt]
	pop		rcx
	clearPenColor
	inc		rcx							; point to next node
	jmp		.top

.fin:
	epilogue

;=========================== READ-ONLY DATA SECTION =========================
section	.rodata
BLACK		db	ESC, "[0;30m", EOL
RED			db	ESC, "[0;31m", EOL
GREEN		db	ESC, "[0;32m", EOL
YELLOW		db	ESC, "[0;33m", EOL
BLUE		db	ESC, "[0;34m", EOL
PURPLE		db	ESC, "[0;35m", EOL
CYAN		db	ESC, "[0;36m", EOL
WHITE		db	ESC, "[0;37m", EOL
RESET		db	ESC, "[0m",    EOL
listFmt		db  TAB, "%s", LF, EOL
prtInsTotal	db	TAB, LF, "%d elements were loaded.", LF, EOL

section	.bss
buffer		resb	64
;===========================+++++============================================
