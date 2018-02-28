#!/bin/sh
set -e -x
# Build experiment control IOCs.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Requires that EPICS base has been built using: build-epics.sh
#

# Clean up
rm -rf iocs/scan

(cd areaDetector/ADSimDetector/iocs \
  && make distclean \
  )

DEPTH="--depth 5"

# Get scan IOC
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

# Build area detector simulator IOC
(cd areaDetector/ADSimDetector \
  && make "$@" \
  )

(cd areaDetector/ADSimDetector/iocs \
  && make "$@" \
  )

# Create symbolic links in iocs directory for convenience
mkdir -p iocs
(cd iocs \
  && ln -sfn ../areaDetector/ADSimDetector/iocs/simDetectorIOC \
  && ln -sfn ../motorsim
)

(cd iocs/simDetectorIOC/iocBoot/iocSimDetector \
  && ln -sfn envPaths envPaths.linux \
)

