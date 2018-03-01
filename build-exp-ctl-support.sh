#!/bin/sh
set -e -x
# Build experiment control support modules using EPICS Base 3.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#

SUPPORT=support_tmp
# Clean up
rm -rf base3 $SUPPORT/sscan $SUPPORT/autosave $SUPPORT/calc

# Get the support module code
DEPTH="--depth 5"

git clone $DEPTH --branch R3.14.12.7 https://github.com/epics-base/epics-base.git base3

mkdir -p $SUPPORT
git clone $DEPTH --branch R5-9 https://github.com/epics-modules/autosave.git $SUPPORT/autosave
git clone $DEPTH --branch R3-7 https://github.com/epics-modules/calc.git $SUPPORT/calc

git clone $DEPTH --branch R2-11-1 https://github.com/epics-modules/sscan.git $SUPPORT/sscan

# calc
cat <<EOF > $SUPPORT/calc/configure/RELEASE
EPICS_BASE=$PWD/base3
EOF

# autosave
cat <<EOF > $SUPPORT/autosave/configure/RELEASE
EPICS_BASE=$PWD/base3
EOF

# sscan
cat <<EOF > $SUPPORT/sscan/configure/RELEASE
EPICS_BASE=$PWD/base3
EOF

# Build support modules
(cd base3 && make "$@")
(cd $SUPPORT/sscan && make "$@")
(cd $SUPPORT/calc && make "$@")
(cd $SUPPORT/autosave && make "$@")
