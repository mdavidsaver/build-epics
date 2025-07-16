#!/bin/sh
set -e -x

cat /etc/os-release
. /etc/os-release

case "$ID/$VERSION_ID" in
debian/*)
    PKG=apt-get
    apt-get update
    apt-get -y install git build-essential autoconf automake \
        libreadline6-dev libncurses5-dev perl libpcre3-dev re2c python3-dev python3-nose libsnmp-dev \
        python3-numpy cython3 libgraphicsmagick++-dev libhdf5-dev libjpeg-dev libnetcdf-dev libtiff-dev libz-dev \
        libtirpc-dev \
        python-is-python3 cmake
    ;;
*)
    echo "??? $ID/$VERSION_ID ???"
    exit 1
    ;;
esac

# docker runs as a different user than the GHA clone
git config --global --add safe.directory '*'

./build-epics.sh "$@" </dev/null

./build-testapp.sh
