#!/bin/sh
set -e -x

cat /etc/os-release
. /etc/os-release

rh_install() {
    $1 -y install perl gcc-c++ make git \
        glibc-devel make readline-devel ncurses-devel perl-devel \
        pkg-config pcre-devel re2c GraphicsMagick-c++-devel libjpeg-turbo-devel \
        libtiff-devel libXext-devel hdf5-devel libaec-devel netcdf-devel \
        libxml2-devel tar autoconf automake libtool python3 rpcgen libtirpc-devel
}

case "$ID/$VERSION_ID" in
centos/7*)
    yum -y install epel-release
    rh_install yum
    ;;
centos/8*)
    dnf -y install epel-release dnf-plugins-core centos-stream-repos
    dnf -y config-manager --set-enabled powertools

    dnf -y install python2
    alternatives --set python /usr/bin/python2
    rh_install dnf
    ;;
debian/*)
    PKG=apt-get
    apt-get update
    apt-get -y install git build-essential libreadline6-dev libncurses5-dev perl libpcre3-dev re2c python3-dev python3-nose \
        python3-numpy libgraphicsmagick++-dev libhdf5-dev libjpeg-dev libnetcdf-dev libtiff-dev libz-dev \
        python-is-python3
    ;;
*)
    echo "??? $ID/$VERSION_ID ???"
    exit 1
    ;;
esac

./build-epics.sh "$@" </dev/null

./build-testapp.sh
