#!/bin/bash
#############################################################################
# os-distro - utility shell script to display uname and distro information
#	John Schwartzman
#	05/20/2023
#   Forte Systems, Inc.
#############################################################################
printf "\nDATE:\n   "		# prins 1st title
/usr/bin/date | sed -n 'P'	# display date up to newline
printf "OS:\n"    			# print 2nd title  
/usr/local/bin/uname2		# invoke uname2
printf "DISTRO:\n   "		# print 3rd title
cat /etc/os-release | \
	sed -n 's/.*PRETTY_NAME=\"/PRETTY_NAME: /p' | sed -n 's/\"//p'
printf "   "
cat /etc/os-release | \
	sed -n 's/.*VERSION=\"/VERSION:     /p' | sed -n 's/\"//p'
printf "\n"					# print blank line
