	.file	"test.c"
	.intel_syntax noprefix
	.text
	.globl	searchStr
	.bss
	.align 32
	.type	searchStr, @object
	.size	searchStr, 64
searchStr:
	.zero	64
	.globl	i
	.align 4
	.type	i, @object
	.size	i, 4
i:
	.zero	4
	.globl	ch
	.type	ch, @object
	.size	ch, 1
ch:
	.zero	1
	.section	.rodata
.LC0:
	.string	"Enter string(s): "
.LC1:
	.string	"%c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	edi, OFFSET FLAT:.LC0
	mov	eax, 0
	call	printf
	mov	DWORD PTR i[rip], 0
	jmp	.L2
.L5:
	mov	esi, OFFSET FLAT:ch
	mov	edi, OFFSET FLAT:.LC1
	mov	eax, 0
	call	__isoc99_scanf
	mov	eax, DWORD PTR i[rip]
	movzx	edx, BYTE PTR ch[rip]
	cdqe
	mov	BYTE PTR searchStr[rax], dl
	movzx	eax, BYTE PTR ch[rip]
	cmp	al, 10
	jne	.L3
	mov	eax, DWORD PTR i[rip]
	cdqe
	mov	BYTE PTR searchStr[rax], 0
	jmp	.L4
.L3:
	mov	eax, DWORD PTR i[rip]
	add	eax, 1
	mov	DWORD PTR i[rip], eax
.L2:
	mov	eax, DWORD PTR i[rip]
	cmp	eax, 63
	jle	.L5
.L4:
	mov	edi, OFFSET FLAT:searchStr
	call	puts
	mov	eax, 0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (SUSE Linux) 14.2.1 20241007 [revision 4af44f2cf7d281f3e4f3957efce10e8b2ccb2ad3]"
	.section	.note.GNU-stack,"",@progbits
