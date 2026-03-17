#############################################################################
#
#	Makefile for sum
#	John Schwartzman, Forte Systems, Inc.
#	06/06/2023
#
#	Commands:  make [release], make debug, make clean
#			   make = make release
#   Requires:  ../maketest.sh
#
#############################################################################
PROG		:= sum
PROG2		:= calcFile2
SHELL 		:= /bin/bash
ASM_FLAGS	:= -f elf64
ASM_DFLAGS	:= -f elf64 -g dwarf2
C_FLAGS		:= -Wall -O3 -z noexecstack
C_DFLAGS	:= -Wall -O0 -g -z noexecstack

release: $(PROG2).asm Makefile
	@source ../maketest.sh && test release debug
	yasm $(ASM_FLAGS) -o $(PROG).obj $(PROG).asm
	yasm $(ASM_FLAGS) -o $(PROG2).obj $(PROG2).asm
	gcc	 $(C_FLAGS) $(PROG).obj -o $(PROG)
	gcc	 $(C_FLAGS) $(PROG2).obj -o $(PROG2)


debug: $(PROG2).asm Makefile
	@source ../maketest.sh && test debug release
	yasm $(ASM_DFLAGS) -o $(PROG).obj $(PROG).asm
	yasm $(ASM_DFLAGS) -o $(PROG2).obj $(PROG2).asm
	gcc	 $(C_DFLAGS) $(PROG).obj -o $(PROG)
	gcc	 $(C_DFLAGS) $(PROG2).obj -o $(PROG2)

clean:
	rm -f $(PROG) *.obj a.out debug release

#############################################################################
