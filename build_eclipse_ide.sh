#!/bin/bash

# Builds: http://download.eclipse.org/eclipse/downloads/
# Need: curl
eclipse_ver=4.6.2
eclipse_rel="neon"
eclipse_build="201611241400"
eclipse_dlurl="http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/R-${eclipse_ver}-${eclipse_build}/eclipse-platform-${eclipse_ver}-linux-gtk-x86_64.tar.gz&r=1"
eclipse_dloutput="downloads/eclipse-platform-${eclipse_ver}-${eclipse_build}-linux-gtk-x86_64.tar.gz"

cdt_ver=9.0

cdt_p2repo="http://download.eclipse.org/tools/cdt/releases/${cdt_ver}"
eclipse_p2repo="http://download.eclipse.org/releases/${eclipse_rel}/"
avr_p2repo="http://avr-eclipse.sourceforge.net/updatesite"
tmterminal_p2repo="http://download.eclipse.org/tm/terminal/marketplace"

### END OF CONFIG ###

mkdir -p ~/Tools/eclipse
cd ~/Tools/eclipse || exit

echo "Downloading..."
mkdir -p downloads
curl -s -L -o "${eclipse_dloutput}" "${eclipse_dlurl}"

echo "Extracting..."
tar xf "${eclipse_dloutput}" -C .
mv eclipse eclipse_dir || exit
mv eclipse_dir/* . || exit

echo "Install plugins..."
#CDT
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${eclipse_p2repo}" \
    -installIU org.eclipse.launchbar.core

./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${cdt_p2repo}" \
    -installIU org.eclipse.cdt.feature.group

#AVR
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${avr_p2repo}" \
    -installIU de.innot.avreclipse.feature.group

# tm-terminal
./eclipse -application org.eclipse.equinox.p2.director -nosplash -r "${tmterminal_p2repo}" \
    -installIU org.eclipse.tm.terminal.feature.feature.group \

# Disable GTK3
sed -i 's/.*launcher\.appendVmargs.*/--launcher.GTK_version\n2\n&/' eclipse.ini
