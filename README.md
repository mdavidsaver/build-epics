Relocatable EPICS environment
=============================

After unpacking 'prepare.sh' be run to create a file 'eactivate'
which can be sourced each time to update $PATH.  "edeactivate"
will attempt to restore the original environment.


One time setup

  $ ./prepare.sh

Each time

  $ . eactivate


Demo

  $ which softIoc
  /path/to/epics-x86_64-20181213/epics-base/bin/linux-x86_64/softIoc
  $ softIoc -m P=`whoami`: -d demo.db


Notes
-----

Building

```
./build-epics.sh -j2
```

Test building of external app.

```
./build-testapp.sh
```

Build with compressed debug.  Unpacked tree is ~30% smaller.


```
./build-epics.sh -j2 CMD_CPPFLAGS='-gz=zlib-gnu' CMD_LDFLAGS='-Wl,--compress-debug-sections=zlib-gnu'
```

Capture shared library dependencies

```sh
ls -1 {areaDetector/,}*/lib/linux-x86_64/*.so */bin/linux-x86_64/* |xargs readelf -d 2>/dev/null |grep NEEDED|sort -u
```


RHEL8 Package list
------------------

glibc-devel make readline-devel ncurses-devel perl-devel pkg-config pcre-devel re2c GraphicsMagick-c++-devel libjpeg-turbo-devel libtiff-devel libXext-devel hdf5-devel libaec-devel netcdf-devel libxml2-devel tar autoconf automake libtool python3 rpcgen libtirpc-devel
