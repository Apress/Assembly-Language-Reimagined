#############################################################################
#
#	Makefile for sort strings and search strings
#	John Schwartzman, Forte Systems, Inc.
#	Fri Feb 28 06:04:08 PM EST 2025
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
C_FLAGS		:= -Wall -O0 -z noexecstack
C_DFLAGS	:= -Wall -g -z noexecstack
DEPENDS		:= $(wildcard *.asm) $(INCLUDEFILE) Makefile
DEF1		:= __quicksort__		# or __bubblesort__
DEF2		:= __lsearch__		# or __lsearch__
DEF3		:= __bsearch__

release: $(DEPENDS)
	@source ../maketest.sh && test release debug
	$(as) $(ASM_FLAGS) -o bSearchStr.obj bSearchStr.asm						# assemble bSearchStr.asm
	$(as) $(ASM_FLAGS) -o lSearchStr.obj lSearchStr.asm						# assemble lSearchStr.asm
	$(as) $(ASM_FLAGS) -D $(DEF1) -D $(DEF2)	 						\
			-o testStr1.obj testStr.asm										# assemble testStr.asm
	$(as) $(ASM_FLAGS) -D $(DEF1) -D $(DEF3)				 				\
			-o testStr2.obj testStr.asm										# assemble testStr.asm
	$(as) $(ASM_FLAGS) -o arrayTools.obj arrayTools.asm						# assemble arrayTools.asm
	$(as) $(ASM_FLAGS) -o quicksortStr.obj quicksortStr.asm					# assemble quicksortStr.asm
	$(as) $(ASM_FLAGS) -o bubblesortStr.obj bubblesortStr.asm				# assemble bubblesortStr.asm
	$(cc) $(C_FLAGS) testStr1.obj bubblesortStr.obj quicksortStr.obj 	\
					 arrayTools.obj bSearchStr.obj lSearchStr.obj	 	\
					 -o testStr1											# link testStr
	$(cc) $(C_FLAGS) testStr2.obj bubblesortStr.obj quicksortStr.obj 	\
					 arrayTools.obj bSearchStr.obj lSearchStr.obj	 	\
					 -o testStr2											# link testStr

debug: $(DEPENDS)
	@source ../maketest.sh && test debug release
	$(as) $(ASM_DFLAGS) -o bSearchStr.obj bSearchStr.asm					# assemble bSearchStr.asm
	$(as) $(ASM_DFLAGS) -o lSearchStr.obj lSearchStr.asm					# assemble lSearchStr.asm
	$(as) $(ASM_DFLAGS) -D $(DEF1) -D $(DEF2)			 				\
			-o testStr1.obj testStr.asm										# assemble testStr.asm
	$(as) $(ASM_DFLAGS) -D $(DEF1) -D $(DEF3)							\
			-o testStr2.obj testStr.asm										# assemble testStr.asm
	$(as) $(ASM_DFLAGS) -o arrayTools.obj arrayTools.asm					# assemble arrayTools.asm
	$(as) $(ASM_DFLAGS) -o quicksortStr.obj quicksortStr.asm				# assemble qsortStr.asm
	$(as) $(ASM_DFLAGS) -o bubblesortStr.obj bubblesortStr.asm				# assemble bubblesortStr.asm
	$(cc) $(C_DFLAGS) testStr1.obj bubblesortStr.obj quicksortStr.obj 	\
					  arrayTools.obj bSearchStr.obj lSearchStr.obj   	\
					  -o testStr1											# link testStr1
	$(cc) $(C_DFLAGS) testStr2.obj bubblesortStr.obj quicksortStr.obj 	\
					  arrayTools.obj bSearchStr.obj lSearchStr.obj   	\
					  -o testStr2											# link testStr2

clean:
	rm -f *.obj debug release testStr1, testStr2
 
#############################################################################
