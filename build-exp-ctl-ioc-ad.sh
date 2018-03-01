#!/bin/sh
set -e -x
# Build area detector IOCs.
#
# This script is _not_ incremental.
# Each run starts by _deleting_ the output directories.
#
# Additional script arguments are passed to 'make' (eg. '-j2')
#
# Run after the following scripts have been run:
# - build-epics.sh
# - build-exp-ctl-support.sh
# - build-exp-ctl-support-ad.sh
#

# Clean up
(cd areaDetector/ADSimDetector/iocs \
  && make distclean \
  )

# Build area detector simulator IOC
(cd areaDetector/ADSimDetector \
  && make "$@" \
  )

(cd areaDetector/ADSimDetector/iocs \
  && make "$@" \
  )

# Create symbolic links in iocs directory for convenience
mkdir -p iocs
(cd iocs \
  && ln -sfn ../areaDetector/ADSimDetector/iocs/simDetectorIOC \
)

(cd iocs/simDetectorIOC/iocBoot/iocSimDetector \
  && ln -sfn envPaths envPaths.linux \
)

