#!/bin/bash
#############################################################################
# maketest.sh
# John Schwartzman, Forte Systems, Inc. 06/03/2019
#
# A makefile helper script to manage debug and release makefiles 
# using the same source, object and executable files.
# In Makefile use:  @source ../maketest.sh && test release debug
#					@source ../maketest.sh && test debug release
# Invoke Makefile with make release, make debug
#
#############################################################################
function test()
{
	if [[ ! -f $1 ]]; then
		touch $1;	
		rm -f $2;
    else
        touch $2;
		rm -f $1
	fi
}
#############################################################################
