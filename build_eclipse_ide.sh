#!/bin/bash

# Builds: http://download.eclipse.org/eclipse/downloads/
# Need: curl, tar, sed, unzip
eclipse_letter="R"
eclipse_ver="4.7"
eclipse_build="201706120950"
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

# Set GTK2 or GTK3
sed -i 's/.*launcher\.appendVmargs.*/--launcher.GTK_version\n3\n&/' "${installation_path}/eclipse.ini"

# Common
# Get it from
# for t in $(pacman -Fl eclipse-common | cut -d' ' -f2 | grep "usr/lib/eclipse/features/" | cut -d'/' -f5 | uniq); do str="$t"; echo ${str%_*}.feature.group,\\; done
echo "Installing... (common)"
${installation_path}/eclipse \
-noSplash -purgeHistory -application org.eclipse.equinox.p2.director \
-repository \
"http://download.eclipse.org/releases/${eclipse_release}" \
-installIUs \
org.eclipse.e4.rcp.feature.group,\
org.eclipse.ecf.core.feature.feature.group,\
org.eclipse.ecf.core.ssl.feature.feature.group,\
org.eclipse.ecf.filetransfer.feature.feature.group,\
org.eclipse.ecf.filetransfer.httpclient4.feature.feature.group,\
org.eclipse.ecf.filetransfer.httpclient4.ssl.feature.feature.group,\
org.eclipse.ecf.filetransfer.ssl.feature.feature.group,\
org.eclipse.egit.feature.group,\
org.eclipse.emf.common.feature.group,\
org.eclipse.emf.ecore.feature.group,\
org.eclipse.epp.logging.aeri.feature.feature.group,\
org.eclipse.epp.mpc.feature.group,\
org.eclipse.epp.package.common.feature.feature.group,\
org.eclipse.equinox.p2.core.feature.feature.group,\
org.eclipse.equinox.p2.discovery.feature.feature.group,\
org.eclipse.equinox.p2.extras.feature.feature.group,\
org.eclipse.equinox.p2.rcp.feature.feature.group,\
org.eclipse.equinox.p2.user.ui.feature.group,\
org.eclipse.help.feature.group,\
org.eclipse.jgit.feature.group,\
org.eclipse.mylyn.bugzilla_feature.feature.group,\
org.eclipse.mylyn.commons.identity.feature.group,\
org.eclipse.mylyn.commons.notifications.feature.group,\
org.eclipse.mylyn.commons.repositories.feature.group,\
org.eclipse.mylyn.commons.feature.group,\
org.eclipse.mylyn.context_feature.feature.group,\
org.eclipse.mylyn.discovery.feature.group,\
org.eclipse.mylyn.ide_feature.feature.group,\
org.eclipse.mylyn.monitor.feature.group,\
org.eclipse.mylyn.tasks.ide.feature.group,\
org.eclipse.mylyn.team_feature.feature.group,\
org.eclipse.mylyn.wikitext_feature.feature.group,\
org.eclipse.mylyn_feature.feature.group,\
org.eclipse.oomph.p2.feature.group,\
org.eclipse.oomph.setup.core.feature.group,\
org.eclipse.oomph.setup.feature.group,\
org.eclipse.platform.feature.group,\
org.eclipse.rcp.feature.group

# CDT
echo "Installing... (CDT)"
${installation_path}/eclipse \
-noSplash -purgeHistory -application org.eclipse.equinox.p2.director \
-repository \
"http://download.eclipse.org/releases/${eclipse_release}" \
-installIUs \
org.eclipse.cdt.autotools.feature.group,\
org.eclipse.cdt.build.crossgcc.feature.group,\
org.eclipse.cdt.debug.standalone.feature.group,\
org.eclipse.cdt.debug.ui.memory.feature.group,\
org.eclipse.cdt.gdb.feature.group,\
org.eclipse.cdt.gnu.build.feature.group,\
org.eclipse.cdt.gnu.debug.feature.group,\
org.eclipse.cdt.gnu.dsf.feature.group,\
org.eclipse.cdt.launch.remote.feature.group,\
org.eclipse.cdt.mylyn.feature.group,\
org.eclipse.cdt.native.feature.group,\
org.eclipse.cdt.platform.feature.group,\
org.eclipse.cdt.feature.group,\
org.eclipse.epp.package.cpp.feature.feature.group,\
org.eclipse.linuxtools.callgraph.feature.feature.group,\
org.eclipse.linuxtools.cdt.libhover.devhelp.feature.feature.group,\
org.eclipse.linuxtools.cdt.libhover.feature.feature.group,\
org.eclipse.linuxtools.changelog.c.feature.group,\
org.eclipse.linuxtools.gcov.feature.group,\
org.eclipse.linuxtools.gprof.feature.feature.group,\
org.eclipse.linuxtools.oprofile.feature.feature.group,\
org.eclipse.linuxtools.perf.feature.feature.group,\
org.eclipse.linuxtools.profiling.feature.group,\
org.eclipse.linuxtools.rpm.feature.group,\
org.eclipse.linuxtools.systemtap.feature.group,\
org.eclipse.linuxtools.valgrind.feature.group,\
org.eclipse.remote.feature.group,\
org.eclipse.rse.core.feature.group,\
org.eclipse.rse.dstore.feature.group,\
org.eclipse.rse.ftp.feature.group,\
org.eclipse.rse.local.feature.group,\
org.eclipse.rse.ssh.feature.group,\
org.eclipse.rse.telnet.feature.group,\
org.eclipse.rse.feature.group,\
org.eclipse.tracecompass.ctf.feature.group,\
org.eclipse.tracecompass.gdbtrace.feature.group,\
org.eclipse.tracecompass.lttng2.control.feature.group,\
org.eclipse.tracecompass.lttng2.kernel.feature.group,\
org.eclipse.tracecompass.lttng2.ust.feature.group,\
org.eclipse.tracecompass.tmf.ctf.feature.group,\
org.eclipse.tracecompass.tmf.feature.group

# PHP
echo "Installing... (PHP)"
${installation_path}/eclipse \
-noSplash -purgeHistory -application org.eclipse.equinox.p2.director \
-repository \
"http://download.eclipse.org/releases/${eclipse_release}" \
-installIUs \
org.eclipse.dltk.core.index.lucene.feature.group,\
org.eclipse.dltk.core.feature.group,\
org.eclipse.dltk.mylyn.feature.group,\
org.eclipse.egit.gitflow.feature.feature.group,\
org.eclipse.egit.mylyn.feature.group,\
org.eclipse.epp.package.php.feature.feature.group,\
org.eclipse.mylyn.github.feature.feature.group,\
org.eclipse.php.mylyn.feature.group,\
org.eclipse.php.feature.group,\
org.eclipse.wst.common_core.feature.feature.group,\
org.eclipse.wst.common_ui.feature.feature.group,\
org.eclipse.wst.jsdt.feature.feature.group,\
org.eclipse.wst.jsdt.nodejs.feature.feature.group,\
org.eclipse.wst.json_core.feature.feature.group,\
org.eclipse.wst.json_ui.feature.feature.group,\
org.eclipse.wst.server_core.feature.feature.group,\
org.eclipse.wst.server_ui.feature.feature.group,\
org.eclipse.wst.server_userdoc.feature.feature.group,\
org.eclipse.wst.web_core.feature.feature.group,\
org.eclipse.wst.web_ui.feature.feature.group,\
org.eclipse.wst.web_userdoc.feature.feature.group,\
org.eclipse.wst.xml_core.feature.feature.group,\
org.eclipse.wst.xml_ui.feature.feature.group,\
org.eclipse.wst.xml_userdoc.feature.feature.group

# PyDev
echo "Installing... PyDev"
curl -L -o "${installation_path}/downloads/PyDev.zip" "https://sourceforge.net/projects/pydev/files/latest/download?source=typ_redirect"
unzip -q "${installation_path}/downloads/PyDev.zip" -d "${installation_path}/dropins/pydev/"

# Install other stuff
echo "Installing... (others)"
${installation_path}/eclipse \
-noSplash -purgeHistory -application org.eclipse.equinox.p2.director \
-repository \
"http://download.eclipse.org/releases/${eclipse_release}",\
"http://avr-eclipse.sourceforge.net/updatesite",\
"http://winterwell.com/software/updatesite",\
"http://dadacoalition.org/yedit" \
-installIUs \
org.eclipse.dltk.sh.feature.group,\
org.eclipse.tm.terminal.feature.feature.group,\
org.eclipse.tm.terminal.view.rse.feature.feature.group,\
de.innot.avreclipse.feature.group,\
markdown.editor.feature.feature.group,\
org.dadacoalition.yedit.feature.feature.group
