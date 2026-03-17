#############################################################################
#
#	Makefile for dir - directory operations
#	John Schwartzman, Forte Systems, Inc.
#	Wed 04 Feb 2026 01:37:11 PM EST
#
#	Commands:  make [release], make debug, make clean, make asm_c_prog
#   Requires:  ../maketest.sh
#
#############################################################################
INCLUDEFILE	:= macro.inc
MAKEFILE	:= Makefile
HELPERFILE	:= ../maketest.sh
SHELL 		:= /bin/bash
cc			:= gcc
as			:= yasm
ASM_FLAGS	:= -f elf64
ASM_DFLAGS	:= -f elf64 -g dwarf2
C_FLAGS		:= -Wall -O3 -z noexecstack
C_DFLAGS	:= -Wall -g -z noexecstack
DEPENDS		:= $(wildcard *.asm) $(wildcard *.c) $(INCLUDEFILE) $(MAKEFILE)

release: $(DEPENDS)
	@source $(HELPERFILE) && test release debug
	$(as) $(ASM_FLAGS) -o dir.obj dir.asm				
	$(cc) $(C_FLAGS)   -o dir   dir.obj

debug: $(DEPENDS)
	@source ../maketest.sh && test debug release
	$(as) $(ASM_DFLAGS) -o dir.obj dir.asm				
	$(cc) $(C_DFLAGS) 	-o dir   dir.obj
	
clean:
	rm -f *.obj debug release dir
 
asm_c_prog: dir.c
	gcc -S -fno-asynchronous-unwind-tables \
		-fno-dwarf2-cfi-asm -fno-exceptions -masm=intel dir.c
#############################################################################
