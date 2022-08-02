TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application


PROD_IOC = everything
# everything.dbd will be created and installed
DBD += everything.dbd

# Add all the support libraries needed by this IOC
everything_LIBS += devIocStats
everything_LIBS += simDetector
everything_LIBS += URLDriver
everything_LIBS += pvaDriver

# commonDriverMakefile appends to everything_LIBS and initializes everything_DBD
DBD_NAME = everything
include $(ADCORE)/cfg/commonDriverMakefile

everything_LIBS += stream
##everything_LIBS += sscan
everything_LIBS += modbus
##everything_LIBS += calc
##everything_LIBS += busy
##everything_LIBS += seq pv
everything_LIBS += ether_ip
everything_LIBS += reccaster
##everything_LIBS += asyn
##everything_LIBS += autosave

everything_SYS_LIBS += pcre

# everything_registerRecordDeviceDriver.cpp derives from everything.dbd
everything_SRCS += everything_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
everything_SRCS_DEFAULT += everythingMain.cpp
everything_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#everything_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
##everything_LIBS += $(EPICS_BASE_IOC_LIBS)

# everything.dbd will be made up from these files:
##everything_DBD += base.dbd
everything_DBD += system.dbd
##everything_DBD += asSupport.dbd
##everything_DBD += asyn.dbd
everything_DBD += reccaster.dbd
everything_DBD += ether_ip.dbd

##everything_DBD += busySupport.dbd
##everything_DBD += calcSupport.dbd
everything_DBD += modbusSupport.dbd
##everything_DBD += sscanSupport.dbd
everything_DBD += stream.dbd
everything_DBD += simDetectorSupport.dbd
everything_DBD += URLDriverSupport.dbd
everything_DBD += pvaDriverSupport.dbd
everything_DBD += devIocStats.dbd

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

