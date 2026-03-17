#############################################################################
#
#	Makefile for uname
# 	John Schwartzman, Forte Systems, Inc.
# 	12/16/2023
#
#	Commands:  make [release], make debug, make clean, make install
#   Requires:  ../asm/maketest.sh
#
#############################################################################
PROG  := uname
SHELL := /bin/bash

.phony: clean

release: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test release debug
	yasm -f elf64 -o $(PROG).obj $(PROG).asm	# assemble
	ld $(PROG).obj -o $(PROG)					# link
	gcc $(PROG).c								# compile and link a.out

debug: $(PROG).asm $(PROG).c Makefile
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj $(PROG).asm	# assemble
	ld -g $(PROG).obj -o $(PROG)						# link 
	gcc -g $(PROG).c									# compile and link a.out

clean:
	rm -f $(PROG) *.obj a.out debug release
#############################################################################
