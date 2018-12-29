#!/bin/sh
set -e -x

mkdir root
ROOTDIR="$PWD/root"

trap 'rm -rf "$ROOTDIR"' TERM KILL HUP EXIT

tar -C "$ROOTDIR" -xaf epics-*.tar.*

ls "$ROOTDIR"

EPICSDIR=`ls -1d "$ROOTDIR"/epics-*`

echo "EPICSDIR=$EPICSDIR"

"$EPICSDIR"/prepare.sh

sed -i -e 's|$(TOP)/..|'"$EPICSDIR"'|' testapp/configure/RELEASE

cat testapp/configure/RELEASE

cd testapp
make

make distclean

make STATIC_BUILD=YES
