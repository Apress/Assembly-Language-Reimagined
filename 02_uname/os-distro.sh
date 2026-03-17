#!/bin/bash
#############################################################################
# os-distro - utility to display uname and distro information
#	John Schwartzman
#	04/05/2023
#   Forte Systems, Inc.
#############################################################################
printf "\nOS:\n"
/usr/bin/un
printf "DISTRO:\n   "
cat /etc/os-release | \
    sed -n 's/.*PRETTY_NAME=\"/PRETTY_NAME: /p' | sed -n 's/\"//p'
printf "   "
cat /etc/os-release | \
    sed -n 's/.*VERSION=\"/VERSION:     /p' | sed -n 's/\"//p'
printf "\n"

