#############################################################################
#
#	Makefile for linkedList
#	John Schwartzman, Forte Systems, Inc.
#	02/12/2024
#
#	Commands:  make [release], make debug, make clean, make asm_c_prog
#   Requires:  ../maketest.sh
#
#############################################################################
INCLUDEFILE	:= macro.inc
SHELL 		:= /bin/bash
cc			:= gcc
as			:= yasm
ASM_FLAGS	:= -f elf64
ASM_DFLAGS	:= -f elf64 -g dwarf2
C_FLAGS		:= -Wall -O3 -z noexecstack
C_DFLAGS	:= -Wall -g -z noexecstack
DEPENDS		:= $(wildcard *.asm) $(INCLUDEFILE) Makefile
DEF			:= __quicksort__		# or __bubblesort__

release: $(DEPENDS)
	@source ../maketest.sh && test release debug
	$(as) $(ASM_FLAGS) -D $(DEF) -o llDir.obj llDir.asm
	$(as) $(ASM_FLAGS) -o quicksortStr.obj quicksortStr.asm
	$(as) $(ASM_FLAGS) -o bubblesortStr.obj bubblesortStr.asm
	$(as) $(ASM_FLAGS) -o listTools.obj listTools.asm
	$(cc) $(C_FLAGS) llDir.obj quicksortStr.obj bubblesortStr.obj listTools.obj -o llDir

debug: $(DEPENDS)
	@source ../maketest.sh && test debug release
	$(as) $(ASM_DFLAGS) -D $(DEF) -o llDir.obj llDir.asm -l llDir.lst
	$(as) $(ASM_DFLAGS) -o quicksortStr.obj quicksortStr.asm
	$(as) $(ASM_DFLAGS) -o bubblesortStr.obj bubblesortStr.asm
	$(as) $(ASM_DFLAGS) -o listTools.obj listTools.asm
	$(cc) $(C_DFLAGS) llDir.obj bubblesortStr.obj quicksortStr.obj listTools.obj -o llDir

clean:
	rm -f *.obj debug release vgcore.*
 
asm_c_prog: dir.c
	gcc -S -fno-asynchronous-unwind-tables \
	    -fno-dwarf2-cfi-asm -fno-exceptions -masm=intel llDir.c
#############################################################################
