	.file	"testfgets.c"
	.intel_syntax noprefix
	.text
.Ltext0:
	.file 0 "/home/js/Development/asm_x64/sort" "testfgets.c"
	.section	.rodata
.LC0:
	.string	"Enter a string: "
.LC1:
	.string	"You entered: %s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.file 1 "testfgets.c"
	.loc 1 3 12
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 112
	.loc 1 5 9
	mov	DWORD PTR [rbp-4], 99
	.loc 1 7 5
	mov	edi, OFFSET FLAT:.LC0
	mov	eax, 0
	call	printf
	.loc 1 10 5
	mov	rdx, QWORD PTR stdin[rip]
	mov	ecx, DWORD PTR [rbp-4]
	lea	rax, [rbp-112]
	mov	esi, ecx
	mov	rdi, rax
	call	fgets
	.loc 1 11 5
	lea	rax, [rbp-112]
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC1
	mov	eax, 0
	call	printf
	.loc 1 12 12
	mov	eax, 0
	.loc 1 13 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
.Letext0:
	.file 2 "/usr/include/bits/types.h"
	.file 3 "/usr/include/bits/types/struct_FILE.h"
	.file 4 "/usr/include/bits/types/FILE.h"
	.file 5 "/usr/include/stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x2fc
	.value	0x5
	.byte	0x1
	.byte	0x8
	.long	.Ldebug_abbrev0
	.uleb128 0xb
	.long	.LASF48
	.byte	0x1d
	.long	.LASF0
	.long	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.long	.Ldebug_line0
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF2
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF3
	.uleb128 0xc
	.byte	0x8
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF4
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF5
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF6
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.long	.LASF7
	.uleb128 0xd
	.byte	0x4
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF8
	.uleb128 0x5
	.long	.LASF9
	.byte	0x2
	.byte	0x98
	.byte	0x19
	.long	0x61
	.uleb128 0x5
	.long	.LASF10
	.byte	0x2
	.byte	0x99
	.byte	0x1b
	.long	0x61
	.uleb128 0x2
	.long	0x8a
	.uleb128 0x8
	.long	0x80
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF11
	.uleb128 0xe
	.long	0x8a
	.uleb128 0xf
	.long	.LASF49
	.byte	0xd8
	.byte	0x3
	.byte	0x31
	.byte	0x8
	.long	0x200
	.uleb128 0x1
	.long	.LASF12
	.byte	0x33
	.byte	0x7
	.long	0x5a
	.byte	0
	.uleb128 0x1
	.long	.LASF13
	.byte	0x36
	.byte	0x9
	.long	0x80
	.byte	0x8
	.uleb128 0x1
	.long	.LASF14
	.byte	0x37
	.byte	0x9
	.long	0x80
	.byte	0x10
	.uleb128 0x1
	.long	.LASF15
	.byte	0x38
	.byte	0x9
	.long	0x80
	.byte	0x18
	.uleb128 0x1
	.long	.LASF16
	.byte	0x39
	.byte	0x9
	.long	0x80
	.byte	0x20
	.uleb128 0x1
	.long	.LASF17
	.byte	0x3a
	.byte	0x9
	.long	0x80
	.byte	0x28
	.uleb128 0x1
	.long	.LASF18
	.byte	0x3b
	.byte	0x9
	.long	0x80
	.byte	0x30
	.uleb128 0x1
	.long	.LASF19
	.byte	0x3c
	.byte	0x9
	.long	0x80
	.byte	0x38
	.uleb128 0x1
	.long	.LASF20
	.byte	0x3d
	.byte	0x9
	.long	0x80
	.byte	0x40
	.uleb128 0x1
	.long	.LASF21
	.byte	0x40
	.byte	0x9
	.long	0x80
	.byte	0x48
	.uleb128 0x1
	.long	.LASF22
	.byte	0x41
	.byte	0x9
	.long	0x80
	.byte	0x50
	.uleb128 0x1
	.long	.LASF23
	.byte	0x42
	.byte	0x9
	.long	0x80
	.byte	0x58
	.uleb128 0x1
	.long	.LASF24
	.byte	0x44
	.byte	0x16
	.long	0x219
	.byte	0x60
	.uleb128 0x1
	.long	.LASF25
	.byte	0x46
	.byte	0x14
	.long	0x21e
	.byte	0x68
	.uleb128 0x1
	.long	.LASF26
	.byte	0x48
	.byte	0x7
	.long	0x5a
	.byte	0x70
	.uleb128 0x1
	.long	.LASF27
	.byte	0x49
	.byte	0x7
	.long	0x5a
	.byte	0x74
	.uleb128 0x1
	.long	.LASF28
	.byte	0x4a
	.byte	0xb
	.long	0x68
	.byte	0x78
	.uleb128 0x1
	.long	.LASF29
	.byte	0x4d
	.byte	0x12
	.long	0x45
	.byte	0x80
	.uleb128 0x1
	.long	.LASF30
	.byte	0x4e
	.byte	0xf
	.long	0x4c
	.byte	0x82
	.uleb128 0x1
	.long	.LASF31
	.byte	0x4f
	.byte	0x8
	.long	0x223
	.byte	0x83
	.uleb128 0x1
	.long	.LASF32
	.byte	0x51
	.byte	0xf
	.long	0x233
	.byte	0x88
	.uleb128 0x1
	.long	.LASF33
	.byte	0x59
	.byte	0xd
	.long	0x74
	.byte	0x90
	.uleb128 0x1
	.long	.LASF34
	.byte	0x5b
	.byte	0x17
	.long	0x23d
	.byte	0x98
	.uleb128 0x1
	.long	.LASF35
	.byte	0x5c
	.byte	0x19
	.long	0x247
	.byte	0xa0
	.uleb128 0x1
	.long	.LASF36
	.byte	0x5d
	.byte	0x14
	.long	0x21e
	.byte	0xa8
	.uleb128 0x1
	.long	.LASF37
	.byte	0x5e
	.byte	0x9
	.long	0x3c
	.byte	0xb0
	.uleb128 0x1
	.long	.LASF38
	.byte	0x5f
	.byte	0x15
	.long	0x24c
	.byte	0xb8
	.uleb128 0x1
	.long	.LASF39
	.byte	0x60
	.byte	0x7
	.long	0x5a
	.byte	0xc0
	.uleb128 0x1
	.long	.LASF40
	.byte	0x62
	.byte	0x8
	.long	0x251
	.byte	0xc4
	.byte	0
	.uleb128 0x5
	.long	.LASF41
	.byte	0x4
	.byte	0x7
	.byte	0x19
	.long	0x96
	.uleb128 0x10
	.long	.LASF50
	.byte	0x3
	.byte	0x2b
	.byte	0xe
	.uleb128 0x6
	.long	.LASF42
	.uleb128 0x2
	.long	0x214
	.uleb128 0x2
	.long	0x96
	.uleb128 0x9
	.long	0x8a
	.long	0x233
	.uleb128 0x7
	.long	0x2e
	.byte	0
	.byte	0
	.uleb128 0x2
	.long	0x20c
	.uleb128 0x6
	.long	.LASF43
	.uleb128 0x2
	.long	0x238
	.uleb128 0x6
	.long	.LASF44
	.uleb128 0x2
	.long	0x242
	.uleb128 0x2
	.long	0x21e
	.uleb128 0x9
	.long	0x8a
	.long	0x261
	.uleb128 0x7
	.long	0x2e
	.byte	0x13
	.byte	0
	.uleb128 0x2
	.long	0x91
	.uleb128 0x11
	.long	.LASF51
	.byte	0x5
	.byte	0x95
	.byte	0xe
	.long	0x272
	.uleb128 0x2
	.long	0x200
	.uleb128 0x8
	.long	0x272
	.uleb128 0xa
	.long	.LASF45
	.value	0x28e
	.byte	0xe
	.long	0x80
	.long	0x29c
	.uleb128 0x4
	.long	0x85
	.uleb128 0x4
	.long	0x5a
	.uleb128 0x4
	.long	0x277
	.byte	0
	.uleb128 0xa
	.long	.LASF46
	.value	0x16b
	.byte	0xc
	.long	0x5a
	.long	0x2b3
	.uleb128 0x4
	.long	0x261
	.uleb128 0x12
	.byte	0
	.uleb128 0x13
	.long	.LASF52
	.byte	0x1
	.byte	0x3
	.byte	0x5
	.long	0x5a
	.quad	.LFB0
	.quad	.LFE0-.LFB0
	.uleb128 0x1
	.byte	0x9c
	.long	0x2f3
	.uleb128 0x14
	.long	.LASF47
	.byte	0x1
	.byte	0x4
	.byte	0xa
	.long	0x2f3
	.uleb128 0x3
	.byte	0x91
	.sleb128 -128
	.uleb128 0x15
	.string	"n"
	.byte	0x1
	.byte	0x5
	.byte	0x9
	.long	0x5a
	.uleb128 0x2
	.byte	0x91
	.sleb128 -20
	.byte	0
	.uleb128 0x16
	.long	0x8a
	.uleb128 0x7
	.long	0x2e
	.byte	0x63
	.byte	0
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 3
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x37
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 5
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_aranges,"",@progbits
	.long	0x2c
	.value	0x2
	.long	.Ldebug_info0
	.byte	0x8
	.byte	0
	.value	0
	.value	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF20:
	.string	"_IO_buf_end"
.LASF28:
	.string	"_old_offset"
.LASF23:
	.string	"_IO_save_end"
.LASF7:
	.string	"short int"
.LASF33:
	.string	"_offset"
.LASF17:
	.string	"_IO_write_ptr"
.LASF12:
	.string	"_flags"
.LASF47:
	.string	"buff"
.LASF19:
	.string	"_IO_buf_base"
.LASF24:
	.string	"_markers"
.LASF14:
	.string	"_IO_read_end"
.LASF37:
	.string	"_freeres_buf"
.LASF45:
	.string	"fgets"
.LASF32:
	.string	"_lock"
.LASF8:
	.string	"long int"
.LASF46:
	.string	"printf"
.LASF29:
	.string	"_cur_column"
.LASF49:
	.string	"_IO_FILE"
.LASF4:
	.string	"unsigned char"
.LASF38:
	.string	"_prevchain"
.LASF6:
	.string	"signed char"
.LASF34:
	.string	"_codecvt"
.LASF3:
	.string	"unsigned int"
.LASF42:
	.string	"_IO_marker"
.LASF31:
	.string	"_shortbuf"
.LASF16:
	.string	"_IO_write_base"
.LASF40:
	.string	"_unused2"
.LASF13:
	.string	"_IO_read_ptr"
.LASF5:
	.string	"short unsigned int"
.LASF11:
	.string	"char"
.LASF52:
	.string	"main"
.LASF35:
	.string	"_wide_data"
.LASF36:
	.string	"_freeres_list"
.LASF48:
	.string	"GNU C17 14.2.1 20241007 [revision 4af44f2cf7d281f3e4f3957efce10e8b2ccb2ad3] -masm=intel -mtune=generic -march=x86-64 -g -O0"
.LASF43:
	.string	"_IO_codecvt"
.LASF2:
	.string	"long unsigned int"
.LASF18:
	.string	"_IO_write_end"
.LASF10:
	.string	"__off64_t"
.LASF9:
	.string	"__off_t"
.LASF25:
	.string	"_chain"
.LASF44:
	.string	"_IO_wide_data"
.LASF22:
	.string	"_IO_backup_base"
.LASF51:
	.string	"stdin"
.LASF27:
	.string	"_flags2"
.LASF39:
	.string	"_mode"
.LASF15:
	.string	"_IO_read_base"
.LASF30:
	.string	"_vtable_offset"
.LASF21:
	.string	"_IO_save_base"
.LASF26:
	.string	"_fileno"
.LASF41:
	.string	"FILE"
.LASF50:
	.string	"_IO_lock_t"
	.section	.debug_line_str,"MS",@progbits,1
.LASF1:
	.string	"/home/js/Development/asm_x64/sort"
.LASF0:
	.string	"testfgets.c"
	.ident	"GCC: (SUSE Linux) 14.2.1 20241007 [revision 4af44f2cf7d281f3e4f3957efce10e8b2ccb2ad3]"
	.section	.note.GNU-stack,"",@progbits
