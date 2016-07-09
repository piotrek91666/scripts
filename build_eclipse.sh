#!/bin/bash

# Builds: http://download.eclipse.org/eclipse/downloads/
# Need: curl
eclipse_ver=4.6
eclipse_rel="neon"
eclipse_build="201606061100"
eclipse_dlurl="http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/R-${eclipse_ver}-${eclipse_build}/eclipse-platform-${eclipse_ver}-linux-gtk-x86_64.tar.gz&r=1"
eclipse_dloutput="downloads/eclipse-platform-${eclipse_ver}-${eclipse_build}-linux-gtk-x86_64.tar.gz"

cdt_ver=9.0

cdt_p2repo="http://download.eclipse.org/tools/cdt/releases/${cdt_ver}"
eclipse_p2repo="http://download.eclipse.org/releases/${eclipse_rel}/"
avr_p2repo="http://avr-eclipse.sourceforge.net/updatesite"
tmterminal_p2repo="http://download.eclipse.org/tm/terminal/marketplace"

### END OF CONFIG ###

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

#NOPE!
mkdir -p ~/Develop/eclipse
cd ~/Develop/eclipse

if [ -d "downloads" ]; then
    rm -rf downloads
fi
mkdir downloads

if [ -d "eclipse" ]; then
    rm -rvf eclipse
fi

curl -L -o "${eclipse_dloutput}" "${eclipse_dlurl}"

tar xvf "${eclipse_dloutput}"

cd eclipse

#CDT
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${eclipse_p2repo}" \
    -installIU org.eclipse.launchbar.core

./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${cdt_p2repo}" \
    -installIU org.eclipse.cdt.feature.group

#AVR
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${avr_p2repo}" \
    -installIU org.eclipse.cdt.feature.group

# tm-terminal
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${tmterminal_p2repo}" \
    -installIU org.eclipse.tm.terminal.feature.feature.group \

cd ..
