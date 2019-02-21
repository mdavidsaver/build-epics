#!/bin/sh
set -e -x
 
if [ -d root ]; then 
	chmod -R u+w root;
	rm -rf root; 
fi

mkdir root
ROOTDIR="$PWD/root"

trap 'chmod -R u+w "$ROOTDIR" && rm -rf "$ROOTDIR"' TERM KILL HUP EXIT

tar -C "$ROOTDIR" -xaf epics-*.tar.*

ls "$ROOTDIR"

EPICSDIR=`ls -1d "$ROOTDIR"/epics-*`

echo "EPICSDIR=$EPICSDIR"

"$EPICSDIR"/prepare.sh

chmod -R u+w testapp

sed -i -e 's|$(TOP)/..|'"$EPICSDIR"'|' testapp/configure/RELEASE

cat testapp/configure/RELEASE

cd testapp
make

make distclean

make STATIC_BUILD=YES
