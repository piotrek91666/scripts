#!/bin/bash

# Builds: http://download.eclipse.org/eclipse/downloads/
# Need: curl, tar, sed, unzip
eclipse_letter="S"
eclipse_ver="4.7RC2"
eclipse_build="201705242000"
eclipse_platform="linux-gtk"
eclipse_release="oxygen"
eclipse_arch="x86_64"
eclipse_dlurl="http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/${eclipse_letter}-${eclipse_ver}-${eclipse_build}/eclipse-platform-${eclipse_ver}-${eclipse_platform}-${eclipse_arch}.tar.gz&r=1"
eclipse_dloutput="eclipse-platform-${eclipse_ver}-${eclipse_build}-${eclipse_platform}-${eclipse_arch}.tar.gz"
installation_path="$HOME/Apps/eclipse"

### END OF CONFIG ###

if [[ -d "$installation_path" ]]; then
  echo -ne "Current installation exists in $installation_path.\nDo you want reinstall it? "
  read -p "[y/n]" -n 1 -r; echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Bye!"
    [[ "$0" = "${BASH_SOURCE[0]}" ]] && exit 1 || return 1
  else
    echo "Removing old installation..."
    rm -rf "${installation_path:?}/"*
  fi
else
  echo "Creating new $installation_path."
  mkdir -p ~/Apps/eclipse
fi

echo "Downloading eclipse..."
mkdir -p "${installation_path}/downloads"
curl -L -o "${installation_path}/downloads/${eclipse_dloutput}" "${eclipse_dlurl}"

echo "Extracting..."
tar --strip-components=1 -xf "${installation_path}/downloads/${eclipse_dloutput}" -C "${installation_path}/"

# Disable GTK2
sed -i 's/.*launcher\.appendVmargs.*/--launcher.GTK_version\n3\n&/' "${installation_path}/eclipse.ini"

# Install stuff
echo "Installing..."
${installation_path}/eclipse \
-noSplash -purgeHistory -application org.eclipse.equinox.p2.director \
-repository \
"http://download.eclipse.org/releases/${eclipse_release}",\
"http://avr-eclipse.sourceforge.net/updatesite",\
"http://winterwell.com/software/updatesite",\
"http://dadacoalition.org/yedit" \
-installIUs \
org.eclipse.epp.mpc.feature.group,\
org.eclipse.cdt.feature.group,\
org.eclipse.cdt.build.crossgcc.feature.group,\
org.eclipse.cdt.autotools.feature.group,\
org.eclipse.cdt.managedbuilder.llvm.feature.group,\
org.eclipse.php.feature.group,\
org.eclipse.php.composer.feature.group,\
org.eclipse.dltk.sh.feature.group,\
org.eclipse.tm.terminal.feature.feature.group,\
org.eclipse.rse.feature.group,\
org.eclipse.egit.feature.group,\
org.eclipse.team.svn.feature.group,\
de.innot.avreclipse.feature.group,\
markdown.editor.feature.feature.group,\
org.dadacoalition.yedit.feature.feature.group

# PyDev needs this trick
echo "Installing... PyDev"
curl -L -o "${installation_path}/downloads/PyDev.zip" "https://sourceforge.net/projects/pydev/files/latest/download?source=typ_redirect"
unzip -q "${installation_path}/downloads/PyDev.zip" -d "${installation_path}/dropins/pydev/"
