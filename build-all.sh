#!/bin/sh
set -e -x
# Build all EPICS for training.
#
# This script calls the other subscripts in the correct order.

./build-epics.sh
./build-exp-ctl-support.sh
./build-exp-ctl-support-sscan7.sh
./build-exp-ctl-support-ad7.sh
./build-exp-ctl-iocs.sh
./build-exp-ctl-ioc-ad.sh

