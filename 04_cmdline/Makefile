#############################################################################
#
#	Makefile for cmdline
#	John Schwartzman, Forte Systems, Inc.
#	Thu 05 Feb 2026 01:49:13 AM ES
#
#	Commands:  make [release], make debug, make clean
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  		:= cmdline
SHELL 		:= /bin/bash
MAKEFILE	:= Makefile
ASM_FLAGS	:= -f elf64
ASM_DFLAGS	:= -f elf64 -g dwarf2
C_FLAGS		:= -Wall -O3 -z noexecstack
C_DFLAGS	:= -g -z noexecstack

,phony = clean

release: $(PROG).asm $(PROG).c $(MAKEFILE)
	$(info ########## build release ##########)
	@source ../maketest.sh && test release debug
	yasm $(ASM_FLAGS) -o $(PROG).obj $(PROG).asm
	gcc  $(C_FLAGS) $(PROG).obj -o $(PROG)
	gcc  $(C_FLAGS) $(PROG).c

debug: $(PROG).asm $(PROG).c $(MAKEFILE)
	$(info ########## build debug ##########)
	@source ../maketest.sh && test debug release
	yasm $(ASM_DFLAGS) -o $(PROG).obj $(PROG).asm
	gcc  $(C_DFLAGS) $(PROG).obj -o $(PROG)
	gcc  $(C_DFLAGS) $(PROG).c

clean:
	$(info ########## build clean ##########)
	rm -f $(PROG) *.obj a.out debug release
#############################################################################
