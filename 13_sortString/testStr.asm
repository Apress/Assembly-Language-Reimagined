;============================================================================
; testStr.asm - A testbed for timing functions.
; John Schwartzman, Forte Systems, Inc.
; Sat Mar  1 12:02:14 PM EST 2025	
; Linux x64	
;
;============================================================================

; testLoad.loop will execute FACTOR times
FACTOR			equ		250000000	; two hundred and fifty million

%include "macro.inc"

global	main
global	searchStr	; , searchStrOut, searchStrFound, searchStrNotFound
extern	bSearchStr, lSearchStr
extern	quicksortStr, bubblesortStr
extern	putElement,	displayArray
extern	pTemp

%define nRecords	qword [rsp +  0]	; for main and displayArray
%define nIndex		qword [rsp +  8]
%define char		byte  [rsp + 16]

%define	nRecords	qword [rsp +  0]	; for testLoad
%define nIndex		qword [rsp +  8]
%define	nLow		qword [rsp + 16]
%define nHigh		qword [rsp + 24]

;============================== CODE SECTION ================================
section	.text

;============================================================================
main:
	prologue 4

	zero	rax
	mov		nRecords, rax

	cmp		rdi, 1					; is there only one command line argument
	je		.entryPoint				;	jump if yes

	mov		rsi, [rsi + 8]			; get command line argument searchStr
	lea		rdi, [searchStr]
	strcpy
	jmp		.next2					; load array

	;========================================================================
	; This is one method for reading a multi-word string from the console.
	; This method uses bash to get the string.
	; The string must have double quotes: "Hi John".

	; mov		rsi, [rsi + 8]		; get searchStr from the command line
	; lea		rdi, [searchStr]
	; strcpy

	;========================================================================
	; This is another method for reading a multi-word string from the console.
	; This method uses fscan to get the string.
	; The string must NOT have double quotes: Hi John

.entryPoint:						; jump here to redisplay prompt
	mov		nIndex, rax
	print1Str	[promptStr]

.topOfLoop:							; loop to get searchStr one char at a time
	scan	[scanFmt], char
	mov		al, char
	cmp		al, 10					; '\n'
	je		.next

	mov		rcx, searchStr
	add		rcx, nIndex
	mov		[rcx], al
	inc		nIndex
	cmp		nIndex, STD_STR_LEN - 1
	jl		.topOfLoop

.next:
	mov		rcx, searchStr
	add		rcx, nIndex
	mov		byte [rcx], EOL			; EOL = 0

	strlen	[searchStr]				; make sure searchStr is not empty
	test	rax, rax
	jz		.entryPoint

.next2:
	print2Str	[searchStrOut], [searchStr]

	mov		nRecords, 0
	call	loadArray
	mov		nRecords, rax			; get nRecords found by loadArray

	puts1StrLF	[unsorted]
	mov		rdi, nRecords
	call	displayArray

	mov		rdi, 0
	mov		rsi, nRecords
	call	testLoad

fin:								; calculate and print elapsed time
	mov		rdi, nRecords			; display sorted array
	call	displayArray

	epilogue EXIT_SUCCESS

;============================================================================
loadArray:
	prologue

	zero	rcx						; 0
	lea		rsi, [SRC_STR0]
	push	rcx
	call	putElement				; create element of string bytes array[i] 
	pop		rcx

	inc		rcx						; 1
	lea		rsi, [SRC_STR1]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 2
	lea		rsi, [SRC_STR2]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 3
	lea		rsi, [SRC_STR3]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 4
	lea		rsi, [SRC_STR4]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 5
	lea		rsi, [SRC_STR5]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 6
	lea		rsi, [SRC_STR6]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 7
	lea		rsi, [SRC_STR7]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 8
	lea		rsi, [SRC_STR8]
	push	rcx
	call	putElement
	pop		rcx	

	inc		rcx						; 9
	lea		rsi, [SRC_STR9]
	push	rcx
	call	putElement
	pop		rcx

	inc		rcx						; 10
	lea		rsi, [SRC_STR10]
	push	rcx
	call	putElement
	pop		rcx

.fin:
	mov		rax, rcx				; return nRecords - 1
	epilogue

;============================================================================
testLoad:
	prologue 4

	mov		nLow, rdi
	mov		nHigh, rsi
	mov		nIndex, rdi
	mov		nRecords, rsi

.preLoop:							; do the appropriate sort

%ifdef __bubblesort__

	puts1StrLF	[bsorted]
	zero	rdi
	mov		rsi, nRecords			; bubblesortStr wants nRecords
	call	bubblesortStr
	
%elifdef __quicksort__

	puts1StrLF	[qsorted]
	zero	rdi
	mov		rsi, nRecords			; quickSortStr wants nRecords
	call	quicksortStr

%endif

	time							; get start time	
	mov		[timeStart], rax
	zero	r8

%ifdef	__lsearch__					;========================================

	puts1StrLF	[call_lSearchStr]

%elifdef __bsearch__				;========================================

	puts1StrLF	[call_bSearchStr]

%endif								;========================================

.loop:

	zero	rdi						; prepare for search
	mov		rsi, nRecords

%ifdef __lsearch__					;========================================

	call	lSearchStr				; lSearchStr wants nRecords

%elifdef __bsearch__				;========================================

	call	bSearchStr				; bSearchStr wants nRecords

%endif								;========================================

	inc		r8
	cmp		r8, FACTOR
	jl		.loop

.postLoop:
	cmp		rax, -1
	je		.notFound

.found:
	print2Str1Int	[searchStrFound], [searchStr], rax
	jmp		.fin

.notFound:
	print2Str	[searchStrNotFound], [searchStr]

.fin:
	time							; get stop time
	mov		[timeStop], rax
	sub		rax, [timeStart]
	print1Str1Int [timeElapsed], rax
	epilogue

;================================ DATA SECTION ==============================
section		.rodata
promptStr			db	"Enter a non-empty search string: ", EOL
scanFmt				db	"%c", EOL
searchStrOut		db	"Searching for: '%s'", LF, EOL
searchStrFound		db	TAB, "Found '%s' at position %lld.", LF, EOL
searchStrNotFound	db  TAB, "'%s' was not found.", LF, EOL
prtInsTotal			db	TAB, LF, "%lld elements were loaded.", LF, EOL
unsorted			db "Unsorted array:", EOL
bsorted				db "Bubblesorted array:", EOL
qsorted				db "Quicksorted array:", EOL
call_lSearchStr		db "Calling lSearchStr...", EOL
call_bSearchStr		db "Calling bSearchStr...", EOL
timeElapsed			db TAB, "Elapsed time: %ds", LF, LF, EOL

SRC_STR0	db  "Fred Flintstone", EOL
SRC_STR1	db  "Barney Rubble", EOL
SRC_STR2	db  "Wilma Flintstone", EOL
SRC_STR3	db  "Betty Rubble", EOL
SRC_STR4	db  "Dino the Dinosaur", EOL
SRC_STR5	db	"Fido the Dogasauraus", EOL
SRC_STR6	db  "Rasputin the Mystic", EOL
SRC_STR7	db 	"Jack the Giant Killer", EOL
SRC_STR8	db	"Homer the Odyssey", EOL
SRC_STR9	db	"Warner the Brother #2", EOL
SRC_STR10	db	"Warner the Brother #1", EOL
;========================= UNINITIALIZED DATA SECTION =======================
section .bss
searchStr	resb	STD_STR_LEN
timeStart	resq	 1
timeStop	resq	 1
timeDiff	resq	 1
;============================================================================