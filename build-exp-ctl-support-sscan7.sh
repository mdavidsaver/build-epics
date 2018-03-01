#!/bin/sh
set -e -x
# Build sscan support module. Uses EPICS 7.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Requires EPICS base installation using: build-epics.sh
#

# Clean up
rm -rf sscan

# Get the support module code
DEPTH="--depth 5"

git clone $DEPTH --branch R2-11-1 https://github.com/epics-modules/sscan.git sscan

# sscan
cat <<EOF > sscan/configure/RELEASE
EPICS_BASE=$PWD/epics-base
EOF

# Build support modules
(cd sscan && make "$@")
