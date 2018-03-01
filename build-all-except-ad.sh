#!/bin/sh
set -e -x
# Build all EPICS for training.
#
# This script calls the other subscripts in the correct order.

./build-epics/build-epics.sh
./build-epics/build-exp-ctl-support.sh
./build-epics/build-exp-ctl-support-sscan7.sh
./build-epics/build-exp-ctl-iocs.sh

