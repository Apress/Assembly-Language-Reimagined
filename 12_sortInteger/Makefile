#############################################################################
#
#	Makefile for sort strings
#	John Schwartzman, Forte Systems, Inc.
#	Mon Feb  3 04:31:33 PM EST 2025
#
#	Commands:  make [release], make debug, make clean
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
DEF			:= "__quicksort__"			# or DEF := "__bubblesort__"

release: $(DEPENDS)
	@source ../maketest.sh && test release debug
	$(as) $(ASM_FLAGS) -o bSearchStr.obj bSearchStr.asm						# assemble bSearchStr.asm
	$(as) $(ASM_FLAGS) -o bSearchStrRecursive.obj bSearchStrRecursive.asm	# assemble bSearchStrRecursive.asm
	$(as) $(ASM_FLAGS) -D $(DEF) -o testStr.obj testStr.asm					# assemble testStr.asm
	$(as) $(ASM_FLAGS) -o arrayTools.obj arrayTools.asm						# assemble arrayTools.asm
	$(as) $(ASM_FLAGS) -o qsortPartStr.obj qsortPartStr.asm					# assemble qsortStr.asm
	$(as) $(ASM_FLAGS) -o bubblesortStr.obj bubblesortStr.asm				# assemble qsortStr.asm
	$(cc) $(C_FLAGS) testStr.obj bubblesortStr.obj qsortPartStr.obj \
					 arrayTools.obj bSearchStr.obj -o testStr1				# link testStr
	$(cc) $(C_FLAGS) testStr.obj bubblesortStr.obj qsortPartStr.obj \
					 arrayTools.obj bSearchStrRecursive.obj -o testStr2		# link testStr

debug: $(DEPENDS)
	@source ../maketest.sh && test debug release
	$(as) $(ASM_DFLAGS) -o bSearchStr.obj bSearchStr.asm					# assemble bSearchStr.asm
	$(as) $(ASM_DFLAGS) -o bSearchStrRecursive.obj bSearchStrRecursive.asm	# assemble bSearchStrRecursive.asm
	$(as) $(ASM_DFLAGS) -D $(DEF) -o testStr.obj testStr.asm				# assemble testStr.asm
	$(as) $(ASM_DFLAGS) -o arrayTools.obj arrayTools.asm					# assemble arrayTools.asm
	$(as) $(ASM_DFLAGS) -o qsortPartStr.obj qsortPartStr.asm				# assemble qsortStr.asm
	$(as) $(ASM_DFLAGS) -o bubblesortStr.obj bubblesortStr.asm				# assemble qsortStr.asm
	$(cc) $(C_DFLAGS) testStr.obj bubblesortStr.obj qsortPartStr.obj \
					  arrayTools.obj bSearchStr.obj -o testStr1				# link testStr
	$(cc) $(C_DFLAGS) testStr.obj bubblesortStr.obj qsortPartStr.obj \
					  arrayTools.obj bSearchStrRecursive.obj -o testStr2	# link testStr

clean:
	rm -f *.obj debug release *.obj testStr1, testStr2
 
#############################################################################
