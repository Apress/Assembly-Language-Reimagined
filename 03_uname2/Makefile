#############################################################################
#
#	Makefile for uname2
# 	John Schwartzman, Forte Systems, Inc.
# 	Fri 13 Feb 2026 10:56:27 AM EST
#
#	Commands:  make [release], make debug, make clean, make install
#   Requires:  ../maketest.sh
#
#	Note:	-z noexecstack is required because of a gcc bug
#			It should not be required in a later release of gcc.
#############################################################################
PROG  		:= uname2
SHELL 		:= /bin/bash
ASM_FLAGS	:= -f elf64
ASM_DFLAGS	:= -f elf64 -g dwarf2
C_FLAGS		:= -Wall -O3 -z noexecstack
C_DFLAGS	:= -Wall -g -z noexecstack

.phony: install, clean

release: $(PROG).asm Makefile
	$(info ##### release mode #####)
	@source ../maketest.sh && test release debug
	yasm $(ASM_FLAGS) -o $(PROG).obj $(PROG).asm		# assemble
	gcc $(C_FLAGS) $(PROG).obj -o $(PROG)				# link

debug: $(PROG).asm Makefile
	$(info ##### debug mode #####)
	@source ../maketest.sh && test debug release
	yasm $(ASM_DFLAGS) -o $(PROG).obj $(PROG).asm		# assemble
	gcc $(C_DFLAGS) $(PROG).obj -o $(PROG)				# link

install: release
	sudo cp uname2 /usr/local/bin/
	sudo cp os-distro.sh /usr/local/bin/os-distro

clean:
	rm -f $(PROG) $(PROG2) *.obj debug release
#############################################################################
