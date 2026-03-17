#! /bin/bash
#####################################################################
# un - utility to display uname information and distro information
#      John Schwartzman
#      05/20/2023
#      Forte Systems, Inc.
#####################################################################
/usr/bin/un_
printf "DISTRO:\n    "
cat /etc/os-release | grep -w PRETTY_NAME=
printf "    "
cat /etc/os-release | grep -w VERSION_ID=
printf "\n"

