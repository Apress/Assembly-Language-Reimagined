	.file	"qsortStrPartition.c"
	.text
	.globl	array
	.section	.rodata
.LC0:
	.string	"Fred Flintstone"
.LC1:
	.string	"Barney Rubble"
.LC2:
	.string	"Wilma Flintstone"
.LC3:
	.string	"Betty Rubble"
.LC4:
	.string	"Dino the Dinosaur"
.LC5:
	.string	"Fido the Dogasauraus"
.LC6:
	.string	"Rasputin"
.LC7:
	.string	"Jack the Giant"
.LC8:
	.string	"Homer the Odyssey"
.LC9:
	.string	"Warner the Brother #2"
.LC10:
	.string	"Warner the Brother #1"
	.data
	.align 32
	.type	array, @object
	.size	array, 88
array:
	.quad	.LC0
	.quad	.LC1
	.quad	.LC2
	.quad	.LC3
	.quad	.LC4
	.quad	.LC5
	.quad	.LC6
	.quad	.LC7
	.quad	.LC8
	.quad	.LC9
	.quad	.LC10
	.globl	nArraySize
	.align 4
	.type	nArraySize, @object
	.size	nArraySize, 4
nArraySize:
	.long	11
	.text
	.globl	swapij
	.type	swapij, @function
swapij:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	array(,%rax,8), %rax
	movq	%rax, -8(%rbp)
	movl	-24(%rbp), %eax
	cltq
	movq	array(,%rax,8), %rdx
	movl	-20(%rbp), %eax
	cltq
	movq	%rdx, array(,%rax,8)
	movl	-24(%rbp), %eax
	cltq
	movq	-8(%rbp), %rdx
	movq	%rdx, array(,%rax,8)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	swapij, .-swapij
	.globl	partition
	.type	partition, @function
partition:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	-24(%rbp), %eax
	cltq							; sign extend EAX into RAX
	movq	array(,%rax,8), %rax
	movq	%rax, -16(%rbp)
	movl	-20(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.L3
.L5:
	movl	-8(%rbp), %eax
	cltq
	movq	array(,%rax,8), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jns	.L4						; jump if not signed
	addl	$1, -4(%rbp)
	movl	-8(%rbp), %edx
	movl	-4(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	swapij
.L4:
	addl	$1, -8(%rbp)
.L3:
	movl	-8(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L5
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	-24(%rbp), %eax
	movl	%eax, %esi
	movl	%edx, %edi
	call	swapij
	movl	-4(%rbp), %eax
	addl	$1, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	partition, .-partition
	.globl	quickSort
	.type	quickSort, @function
quickSort:										; quickSort
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jge	.L9
	movl	-24(%rbp), %edx
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	partition
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	leal	-1(%rax), %edx
	movl	-20(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	quickSort
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movl	-24(%rbp), %eax
	movl	%eax, %esi
	movl	%edx, %edi
	call	quickSort
.L9:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	quickSort, .-quickSort
	.section	.rodata
.LC11:
	.string	"\nInsertion Sorted Array:"
.LC12:
	.string	"\t%s\n"
.LC13:
	.string	"\nQuicksorted Array:"
.LC14:
	.string	""
	.text
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$.LC11, %edi
	call	puts
	movl	$0, -4(%rbp)
	jmp	.L11
.L12:
	movl	-4(%rbp), %eax
	cltq
	movq	array(,%rax,8), %rax
	movq	%rax, %rsi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -4(%rbp)
.L11:
	movl	nArraySize(%rip), %eax
	cmpl	%eax, -4(%rbp)
	jl	.L12
	movl	nArraySize(%rip), %eax
	subl	$1, %eax
	movl	%eax, %esi
	movl	$0, %edi
	call	quickSort
	movl	$.LC13, %edi
	call	puts
	movl	$0, -8(%rbp)
	jmp	.L13
.L14:
	movl	-8(%rbp), %eax
	cltq
	movq	array(,%rax,8), %rax
	movq	%rax, %rsi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -8(%rbp)
.L13:
	movl	nArraySize(%rip), %eax
	cmpl	%eax, -8(%rbp)
	jl	.L14
	movl	$.LC14, %edi
	call	puts
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.ident	"GCC: (SUSE Linux) 14.2.1 20241007 [revision 4af44f2cf7d281f3e4f3957efce10e8b2ccb2ad3]"
	.section	.note.GNU-stack,"",@progbits
