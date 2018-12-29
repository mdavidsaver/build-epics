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

# everything.dbd will be made up from these files:
everything_DBD += base.dbd

# Include dbd files from all support applications:
#everything_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#everything_LIBS += xxx

# everything_registerRecordDeviceDriver.cpp derives from everything.dbd
everything_SRCS += everything_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
everything_SRCS_DEFAULT += everythingMain.cpp
everything_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#everything_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
everything_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

