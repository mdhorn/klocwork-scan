kwpython requires 32-bit support
dnf install glibc.i686

# Tools installed in /opt
kwbuildtools.20.1.0.97.linux64.zip
kwciagent.20.1.0.97.linux64.zip

User bashrc changes
if [ -d /opt/kwciagent/bin ]; then
    path_append "/opt/kwciagent/bin"
fi
if [ -d /opt/kwbuildtools/bin ]; then
    path_append "/opt/kwbuildtools/bin"
fi
export KW_SERVER_URL="https://klocwork-jf22.devtools.intel.com:8180"
