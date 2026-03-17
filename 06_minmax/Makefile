#############################################################################
#
#	Makefile for minmax
# 	John Schwartzman, Forte Systems, Inc.
# 	Fri 13 Feb 2026 11:27:32 AM EST
#
#	Commands:  make DEF=C_VERSION [DEBUG] will build a.out only
#			   make [DEBUG] will build minmax (minmax.c and minmax.asm)
#   Requires:  ../maketest.sh
#
#############################################################################
PROG  := minmax
SHELL := /bin/bash

.phony: clean

ifeq ($(DEF), C_VERSION)	##### BUILD a.out #####

release: $(PROG).c Makefile
	$(info "Building a.out only...")
	@source ../maketest.sh && test release debug
	gcc -D $(DEF) $(PROG).c 

debug: $(PROG).c Makefile
	$(info "Building a.out only...")
	@source ../maketest.sh && test debug release
	gcc -g -D $(DEF) $(PROG).c

else	##### BUILD minmax #####

release: $(PROG).asm Makefile
	@source ../maketest.sh && test release debug
	$(info "Building minmax.asm")
	yasm -f elf64 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -z noexecstack $(PROG).c $(PROG).obj -o $(PROG)

debug: $(PROG).asm Makefile
	$(info "Building minmax.asm")
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 -o $(PROG).obj -l $(PROG).lst $(PROG).asm
	gcc -g -z noexecstack $(PROG).c $(PROG).obj -o $(PROG)

endif	##### end of conditional build #####

clean:
	rm -f $(PROG) $(PROG).obj $(PROG).lst a.out debug release
#############################################################################
