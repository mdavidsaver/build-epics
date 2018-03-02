#!/bin/sh
set -e -x
# Build area detector support modules. Uses EPICS 7.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Requires EPICS base installation using: build-epics.sh
#

# Clean up
rm -rf areaDetector 

# Get the support module code
DEPTH="--depth 5"

git clone $DEPTH --branch R3-2 https://github.com/areaDetector/areaDetector.git
(cd areaDetector \
  && git checkout R3-2 \
  && git submodule update --init ADCore \
  && git submodule update --init ADSupport \
  && git submodule update --init ADSimDetector \
  && git submodule update --init ADCSimDetector \
  && git submodule update --init pvaDriver \
  )

(cd areaDetector/ADSimDetector \
  && git checkout R2-7 \
  )

(cd areaDetector/ADCSimDetector \
  && git checkout R2-5 \
  )

# areaDetector
## Create config files
cat <<EOF > areaDetector/configure/RELEASE_PATHS.local
SUPPORT=$PWD
AREA_DETECTOR=\$(SUPPORT)/areaDetector
EPICS_BASE=$PWD/epics-base
PVA=\$(EPICS_BASE)/modules
EOF

cat <<EOF > areaDetector/configure/CONFIG_SITE.local
WITH_BOOST=NO
WITH_PVA=YES
WITH_BLOSC=YES
BLOSC_EXTERNAL=NO
WITH_GRAPHICSMAGICK=NO
WITH_HDF5=YES
HDF5_EXTERNAL=NO
WITH_JPEG=YES
JPEG_EXTERNAL=NO
WITH_NETCDF=YES
NETCDF_EXTERNAL=NO
WITH_NEXUS=YES
NEXUS_EXTERNAL=NO
WITH_OPENCV=NO
WITH_SZIP=YES
SZIP_EXTERNAL=NO
WITH_TIFF=YES
TIFF_EXTERNAL=NO
WITH_ZLIB=YES
ZLIB_EXTERNAL=NO
XML2_EXTERNAL=NO
EOF

cat <<EOF > areaDetector/configure/RELEASE_LIBS.local
ASYN=\$(SUPPORT)/asyn
ADSUPPORT=\$(AREA_DETECTOR)/ADSupport
ADCORE=\$(AREA_DETECTOR)/ADCore
PVACCESS=\$(PVA)/pvAccess
PVDATA=\$(PVA)/pvData
PVDATABASE=\$(PVA)/pvDatabase
NORMATIVETYPES=\$(PVA)/normativeTypes
-include \$(AREA_DETECTOR)/configure/RELEASE_LIBS.local.\$(EPICS_HOST_ARCH)
EOF

cat <<EOF > areaDetector/configure/RELEASE_PRODS.local
include \$(AREA_DETECTOR)/configure/RELEASE_LIBS.local
AUTOSAVE=\$(SUPPORT)/autosave
BUSY=\$(SUPPORT)/busy
CALC=\$(SUPPORT)/calc
SSCAN=\$(SUPPORT)/sscan
-include \$(AREA_DETECTOR)/configure/RELEASE_PRODS.local.\$(EPICS_HOST_ARCH)
EOF

cat <<EOF > areaDetector/configure/RELEASE.local
ADCSIMDETECTOR=\$(AREA_DETECTOR)/ADCSimDetector
ADSIMDETECTOR=\$(AREA_DETECTOR)/ADSimDetector
ADSUPPORT=\$(AREA_DETECTOR)/ADSupport
-include \$(TOP)/configure/RELEASE.local.\$(EPICS_HOST_ARCH)
EOF

# Create symlinks for common files
(cd areaDetector/ADCore/iocBoot \
&& ln -sfn EXAMPLE_commonPlugins.cmd commonPlugins.cmd \
&& ln -sfn EXAMPLE_commonPlugin_settings.req commonPlugin_settings.req \
)

# Build support modules
(cd areaDetector && make "$@")
