#!/bin/sh
set -e -x

cat /etc/os-release
. /etc/os-release

PKG=dnf

case "$ID/$VERSION" in
centos/7*)
    yum -y install epel-release
    PKG=yum
    ;;
centos/8*)
    ls /etc/pki/rpm-gpg /etc/yum.repos.d || false
    dnf grouplist

    dnf -y install epel-release dnf-plugins-core centos-stream-repos
    dnf grouplist
    dnf provides /etc/yum.repos.d/CentOS-Stream-PowerTools.repo || true
    dnf -y config-manager --set-enabled powertools

    dnf -y install python2
    alternatives --set python /usr/bin/python2
    ;;
*)
    echo "??? $ID/$VERSION ???"
    exit 1
    ;;
esac

$PKG -y install perl gcc-c++ make git \
    glibc-devel make readline-devel ncurses-devel perl-devel \
    pkg-config pcre-devel re2c GraphicsMagick-c++-devel libjpeg-turbo-devel \
    libtiff-devel libXext-devel hdf5-devel libaec-devel netcdf-devel \
    libxml2-devel tar autoconf automake libtool python3 rpcgen libtirpc-devel

./build-epics.sh -j2 </dev/null

./build-testapp.sh
