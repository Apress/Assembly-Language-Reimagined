#############################################################################
#
#	Makefile for factorial
# 	Mon Feb 23 09:42:07 AM EST 2026
#
#	Commands:  make [DEF=__COMMA__] [release]
#			   make [DEF=__COMMA__] debug
#			   make clean
#   Requires:  ../maketest.sh
#
#	Executables: 
#				factorial (asm version), 
#				factorialc (c version), 
#				factorialcpp (c++ version)
#############################################################################
SHELL 		:= /bin/bash
EXT_PATH	:= ../09_commaSeparate
EXT_PROG	:= commaSeparate
DEPENDS		:= $(EXT_PATH)/$(EXT_PROG).asm factorial.c \
			    factorial.cpp factorial.asm Makefile

.phony: clean

ifeq ($(DEF), __COMMA__)	######### use commaSeparate for output ##########

release: $(DEPENDS)
	$(info release __COMMA__ build target)
	@source ../maketest.sh && test release debug
	yasm -f elf64 $(EXT_PATH)/$(EXT_PROG).asm -o $(EXT_PROG).obj
	yasm -f elf64 -D "__MAIN__" -D $(DEF) factorial.asm -o factorialAsm.obj
	gcc -z noexecstack factorialAsm.obj $(EXT_PROG).obj -o factorial
	gcc -z noexecstack -D $(DEF) factorial.c $(EXT_PROG).obj -o factorialc
	c++ -z noexecstack -D $(DEF) factorial.cpp $(EXT_PROG).obj -o factorialcpp

debug: $(DEPENDS)
	$(info debug __COMMA__ build target)
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 $(EXT_PATH)/$(EXT_PROG).asm -o $(EXT_PROG).obj
	yasm -f elf64 -g dwarf2 -D "__MAIN__" -D $(DEF) factorial.asm -o factorialAsm.obj
	gcc -z noexecstack -g factorialAsm.obj $(EXT_PROG).obj -o factorial
	gcc -z noexecstack -g -D $(DEF) factorial.c $(EXT_PROG).obj -o factorialc
	c++ -z noexecstack -g -D $(DEF) factorial.cpp $(EXT_PROG).obj -o factorialcpp

else						############### output normally #################

release: $(DEPENDS)
	$(info release build target)
	@source ../maketest.sh && test release debug
	gcc factorial.c -o factorialc
	c++ -Wall -O3 factorial.cpp -o factorialcpp

debug: $(DEPENDS)
	$(info debug build target)
	@source ../maketest.sh && test debug release
	gcc -g factorial.c -o factorialc
	c++ -Wall -g factorial.cpp -o factorialcpp

endif	######################## use commaSeparate ##########################

clean:
	$(info clean build target)
	rm -f factorial factorialc factorialcpp *.obj debug release
#############################################################################
