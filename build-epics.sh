#!/bin/sh
set -e -x
# Build epics-base (a la 7.0)
# and p4p.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Required debian packages to build
#  libreadline6-dev libncurses5-dev perl
#  python-dev python-nose python-numpy
#  python3-dev python3-nose python3-numpy

rm -rf epics-base calc recsync autosave busy asyn motor motorsim p4p masarService

DEPTH="--depth 5"

git clone --branch core/master https://github.com/epics-base/epics-base.git
(cd epics-base \
  && git checkout R7.0.1.1-48-g57acac8fb \
  && git submodule update --init --reference . \
)
git clone $DEPTH https://github.com/ChannelFinder/recsync.git
git clone $DEPTH --branch R5-9 https://github.com/epics-modules/autosave.git
git clone $DEPTH --branch R3-7 https://github.com/epics-modules/calc.git
git clone $DEPTH --branch R1-7 https://github.com/epics-modules/busy.git
git clone $DEPTH --branch R4-33 https://github.com/epics-modules/asyn.git
git clone $DEPTH https://github.com/epics-modules/motor.git
git clone $DEPTH https://github.com/mdavidsaver/motorsim.git
git clone $DEPTH https://github.com/mdavidsaver/p4p.git
git clone $DEPTH https://github.com/mdavidsaver/masarService.git

# epics-base
cat <<EOF > epics-base/configure/CONFIG_SITE.local
CROSS_COMPILER_TARGET_ARCHS=\$(EPICS_HOST_ARCH)-debug
EOF

# recsync
cat <<EOF > recsync/client/configure/RELEASE
EPICS_BASE=$PWD/epics-base
EOF

# autosave
cat <<EOF > autosave/configure/RELEASE
EPICS_BASE=$PWD/epics-base
EOF

# calc
cat <<EOF > calc/configure/RELEASE
EPICS_BASE=$PWD/epics-base
EOF

# asyn
cat <<EOF > asyn/configure/RELEASE
EPICS_BASE=$PWD/epics-base
EOF

# busy
cat <<EOF > busy/configure/RELEASE
ASYN=$PWD/asyn
EPICS_BASE=$PWD/epics-base
EOF

# motor
cat <<EOF > motor/configure/RELEASE
BUSY=$PWD/busy
ASYN=$PWD/asyn
EPICS_BASE=$PWD/epics-base
EOF

# motorsim
cat <<EOF > motorsim/configure/RELEASE
MOTOR=$PWD/motor
BUSY=$PWD/busy
CALC=$PWD/calc
ASYN=$PWD/asyn
AUTOSAVE=$PWD/autosave
EPICS_BASE=$PWD/epics-base
EOF

cat <<EOF > p4p/configure/RELEASE.local
EPICS_BASE=$PWD/epics-base
EOF

# masarService
cat <<EOF > masarService/configure/RELEASE.local
EPICS_BASE=$PWD/epics-base
EOF

(cd epics-base && make "$@")
(cd recsync/client && make "$@")
(cd autosave && make "$@")
(cd calc && make "$@")
(cd asyn && make "$@")
(cd busy && make "$@")
(cd motor && make "$@")
(cd motorsim && make "$@")

(cd p4p && make "$@" nose PYTHON=python2)
(cd p4p && make "$@" nose PYTHON=python2 sh OUTPUT=$PWD/setup.sh)
(cd p4p && make clean)
(cd p4p && make "$@" nose PYTHON=python3)
(cd p4p && make clean)

. p4p/setup.sh

(cd masarService && make)
