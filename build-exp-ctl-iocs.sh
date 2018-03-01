#!/bin/sh
set -e -x
# Build experiment control IOCs.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Run after the following scripts have been run:
# - build-epics.sh
# - build-exp-ctl-support.sh
#

# Clean up
rm -rf iocs/scan iocs/scan7

DEPTH="--depth 5"

# Build scan IOC against EPICS Base 3
git clone $DEPTH https://github.com/waynelewis/ioc_scan.git iocs/scan

# Set up scan IOC RELEASE file
cat <<EOF > iocs/scan/configure/RELEASE
TEMPLATE_TOP=\$(EPICS_BASE)/templates/makeBaseApp/top
SUPPORT=$PWD/support_tmp
SSCAN=\$(SUPPORT)/sscan
AUTOSAVE=\$(SUPPORT)/autosave
CALC=\$(SUPPORT)/calc
EPICS_BASE=$PWD/base3
EOF

# Build scan IOC
(cd iocs/scan && make "$@")

# Build scan IOC against EPICS Base 7
git clone $DEPTH https://github.com/waynelewis/ioc_scan.git iocs/scan7

# Set up scan IOC RELEASE file
cat <<EOF > iocs/scan7/configure/RELEASE
TEMPLATE_TOP=\$(EPICS_BASE)/templates/makeBaseApp/top
SUPPORT=$PWD
SSCAN=\$(SUPPORT)/sscan
AUTOSAVE=\$(SUPPORT)/autosave
CALC=\$(SUPPORT)/calc
EPICS_BASE=$PWD/epics-base
EOF

# Build scan IOC
(cd iocs/scan7 && make "$@")

# Create symbolic links in iocs directory for convenience
mkdir -p iocs
(cd iocs \
  && ln -sfn ../motorsim
)

