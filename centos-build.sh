#!/bin/sh
set -e -x

PKG=yum
if dnf --version
then
    dnf -y install epel-release dnf-plugins-core
    dnf -y config-manager --set-enabled PowerTools
    PKG=dnf
else
    yum -y install epel-release
fi

if ! python --version
then
    $PKG -y install python2
    alternatives --set python /usr/bin/python2
fi

$PKG -y install perl gcc-c++ make git \
    glibc-devel make readline-devel ncurses-devel perl-devel \
    pkg-config pcre-devel re2c GraphicsMagick-c++-devel libjpeg-turbo-devel \
    libtiff-devel libXext-devel hdf5-devel libaec-devel netcdf-devel \
    libxml2-devel tar autoconf automake libtool python3 rpcgen libtirpc-devel

./build-epics.sh -j2

./build-testapp.sh
