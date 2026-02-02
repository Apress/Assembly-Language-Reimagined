#############################################################################
#
#	Makefile for factorial
# 	02/02/2026
#
#	Commands:  make [DEF=__COMMA__] [release]
#			   make [DEF=__COMMA__] debug
#			   make clean
#   Requires:  ../maketest.sh
#
#############################################################################
SHELL 		:= /bin/bash
EXT_PROG	:= commaSeparate
DEPENDS		:= ../commaSeparate/$(EXT_PROG).asm factorial.c factorial.cpp Makefile

# .PHONY: clean

ifeq ($(DEF), __COMMA__)	######### use commaSeparate for output ##########

release: $(DEPENDS)
	$(info release __COMMA__ build target)
	@source ../maketest.sh && test release debug
	yasm -f elf64 ../commaSeparate/$(EXT_PROG).asm -o $(EXT_PROG).obj
	gcc -z noexecstack -D $(DEF) factorial.c $(EXT_PROG).obj -o factorialc
	c++ -z noexecstack -D $(DEF) factorial.cpp $(EXT_PROG).obj -o factorialcpp

debug: $(DEPENDS)
	$(info debug __COMMA__ build target)
	@source ../maketest.sh && test debug release
	yasm -f elf64 -g dwarf2 ../commaSeparate/$(EXT_PROG).asm -o $(EXT_PROG).obj
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
	rm -f factorialc factorialcpp *.obj debug release
#############################################################################
