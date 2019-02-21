#!../../bin/linux-x86_64/everything

< envPaths

# $(PREFIX)      Prefix for all records
# $(PORT)        The port name for the detector.  In autosave.
# $(QSIZE)       The queue size for all plugins.  In autosave.
# $(XSIZE)       The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin and 1-D FFT
#                   profiles in NDPluginFFT.
# $(YSIZE)       The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
# $(NCHANS)      The maximum number of time series points in the NDPluginStats, NDPluginROIStats, and NDPluginAttribute plugins
epicsEnvSet("PREFIX", "testcam:")
epicsEnvSet("PORT", "TESTCAM")
epicsEnvSet("QSIZE", "5")
epicsEnvSet("XSIZE", "1024")
epicsEnvSet("YSIZE", "768")
epicsEnvSet("NCHANS", "1024")

## Register all support components
dbLoadDatabase("../../dbd/everything.dbd",0,0)
everything_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "../../db:.")

### Simulation
simDetectorConfig("$(PORT)", $(XSIZE), $(YSIZE), 1, 0, 0)
dbLoadRecords("simDetector.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
###

### URL
#URLDriverConfig("$(PORT)", 0, 0)
#dbLoadRecords("URLDriver.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
###

### pvaDriver
#pvaDriverConfig("$(PORT)", "$(PVNAME=face)", 0, 0, 0, 0)
#dbLoadRecords("pvaDriver.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
###


# Create an HDF5 file saving plugin
NDFileHDF5Configure("FileHDF1", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileHDF5.template",  "P=$(PREFIX),R=HDF1:,PORT=FileHDF1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create a Magick file saving plugin
NDFileMagickConfigure("FileMagick1", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileMagick.template","P=$(PREFIX),R=Magick1:,PORT=FileMagick1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 4 ROI plugins
NDROIConfigure("ROI1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI1:,  PORT=ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI2:,  PORT=ROI2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI3", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI3:,  PORT=ROI3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("ROI4", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI4:,  PORT=ROI4,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 8 ROIStat plugins
NDROIStatConfigure("ROISTAT1", $(QSIZE), 0, "$(PORT)", 0, 8, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROIStat.template",   "P=$(PREFIX),R=ROIStat1:  ,PORT=ROISTAT1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:1:,PORT=ROISTAT1,ADDR=0,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:2:,PORT=ROISTAT1,ADDR=1,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:3:,PORT=ROISTAT1,ADDR=2,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:4:,PORT=ROISTAT1,ADDR=3,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:5:,PORT=ROISTAT1,ADDR=4,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:6:,PORT=ROISTAT1,ADDR=5,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:7:,PORT=ROISTAT1,ADDR=6,TIMEOUT=1,NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template",  "P=$(PREFIX),R=ROIStat1:8:,PORT=ROISTAT1,ADDR=7,TIMEOUT=1,NCHANS=$(NCHANS)")

# Create a processing plugin
NDProcessConfigure("PROC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDProcess.template",   "P=$(PREFIX),R=Proc1:,  PORT=PROC1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 5 statistics plugins
NDStatsConfigure("STATS1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats1:,  PORT=STATS1,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS1_TS", $(QSIZE), 0, "STATS1", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(PREFIX),R=Stats1:TS:, PORT=STATS1_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS1,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

NDStatsConfigure("STATS2", $(QSIZE), 0, "ROI1",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats2:,  PORT=STATS2,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS2_TS", $(QSIZE), 0, "STATS2", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(PREFIX),R=Stats2:TS:, PORT=STATS2_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS2,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

NDStatsConfigure("STATS3", $(QSIZE), 0, "ROI2",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats3:,  PORT=STATS3,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS3_TS", $(QSIZE), 0, "STATS3", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(PREFIX),R=Stats3:TS:, PORT=STATS3_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS3,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

NDStatsConfigure("STATS4", $(QSIZE), 0, "ROI3",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats4:,  PORT=STATS4,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS4_TS", $(QSIZE), 0, "STATS4", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(PREFIX),R=Stats4:TS:, PORT=STATS4_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS4,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

NDStatsConfigure("STATS5", $(QSIZE), 0, "ROI4",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats5:,  PORT=STATS5,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS5_TS", $(QSIZE), 0, "STATS5", 1, 23)
dbLoadRecords("NDTimeSeries.template",  "P=$(PREFIX),R=Stats5:TS:, PORT=STATS5_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS5,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

# Create a transform plugin
NDTransformConfigure("TRANS1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDTransform.template", "P=$(PREFIX),R=Trans1:,  PORT=TRANS1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")


# Create an overlay plugin with 8 overlays
NDOverlayConfigure("OVER1", $(QSIZE), 0, "$(PORT)", 0, 8, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDOverlay.template", "P=$(PREFIX),R=Over1:, PORT=OVER1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:1:,NAME=ROI1,   SHAPE=1,O=Over1:,XPOS=$(PREFIX)ROI1:MinX_RBV,YPOS=$(PREFIX)ROI1:MinY_RBV,XSIZE=$(PREFIX)ROI1:SizeX_RBV,YSIZE=$(PREFIX)ROI1:SizeY_RBV,PORT=OVER1,ADDR=0,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:2:,NAME=ROI2,   SHAPE=1,O=Over1:,XPOS=$(PREFIX)ROI2:MinX_RBV,YPOS=$(PREFIX)ROI2:MinY_RBV,XSIZE=$(PREFIX)ROI2:SizeX_RBV,YSIZE=$(PREFIX)ROI2:SizeY_RBV,PORT=OVER1,ADDR=1,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:3:,NAME=ROI3,   SHAPE=1,O=Over1:,XPOS=$(PREFIX)ROI3:MinX_RBV,YPOS=$(PREFIX)ROI3:MinY_RBV,XSIZE=$(PREFIX)ROI3:SizeX_RBV,YSIZE=$(PREFIX)ROI3:SizeY_RBV,PORT=OVER1,ADDR=2,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:4:,NAME=ROI4,   SHAPE=1,O=Over1:,XPOS=$(PREFIX)ROI4:MinX_RBV,YPOS=$(PREFIX)ROI4:MinY_RBV,XSIZE=$(PREFIX)ROI4:SizeX_RBV,YSIZE=$(PREFIX)ROI4:SizeY_RBV,PORT=OVER1,ADDR=3,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:5:,NAME=Cursor1,SHAPE=1,O=Over1:,XPOS=junk,                  YPOS=junk,                  XSIZE=junk,                   YSIZE=junk,                   PORT=OVER1,ADDR=4,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:6:,NAME=Cursor2,SHAPE=1,O=Over1:,XPOS=junk,                  YPOS=junk,                  XSIZE=junk,                   YSIZE=junk,                   PORT=OVER1,ADDR=5,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:7:,NAME=Box1,   SHAPE=1,O=Over1:,XPOS=junk,                  YPOS=junk,                  XSIZE=junk,                   YSIZE=junk,                   PORT=OVER1,ADDR=6,TIMEOUT=1")
dbLoadRecords("NDOverlayN.template","P=$(PREFIX),R=Over1:8:,NAME=Box2,   SHAPE=1,O=Over1:,XPOS=junk,                  YPOS=junk,                  XSIZE=junk,                   YSIZE=junk,                   PORT=OVER1,ADDR=7,TIMEOUT=1")

# Create 2 color conversion plugins
NDColorConvertConfigure("CC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDColorConvert.template", "P=$(PREFIX),R=CC1:,  PORT=CC1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDColorConvertConfigure("CC2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDColorConvert.template", "P=$(PREFIX),R=CC2:,  PORT=CC2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")


# Create 2 Codec plugins
NDCodecConfigure("CODEC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, 5)
dbLoadRecords("NDCodec.template", "P=$(PREFIX), R=Codec1:, PORT=CODEC1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")
NDCodecConfigure("CODEC2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, 5)
dbLoadRecords("NDCodec.template", "P=$(PREFIX), R=Codec2:, PORT=CODEC2, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

NDPvaConfigure("PVA1", $(QSIZE), 0, "$(PORT)", 0, $(PREFIX)Pva1:Image, 0, 0, 0)
dbLoadRecords("NDPva.template",  "P=$(PREFIX),R=Pva1:, PORT=PVA1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

## autosave/restore machinery
save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("${TOP}/autosave","/save")
set_requestfile_path("${TOP}/autosave","/req")

system("install -m 777 -d ${TOP}/autosave/save")
system("install -m 777 -d ${TOP}/autosave/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

dbLoadRecords("save_restoreStatus.db","P=$(PREFIX)")
save_restoreSet_status_prefix("$(PREFIX)")

# Load motors
cd $(TOP)
dbLoadTemplate("db/motorSim.substitutions")

# Create simulated motors: ( start card , start axis , low limit, high limit, home posn, # cards, # axes to setup)
#motorSimCreate( 0, 0, -32000, 32000, 0, 1, 6 )
motorSimCreateController("motorSim1", 6)
# Setup the Asyn layer (portname, low-level driver drvet name, card, number of axes on card)
#drvAsynMotorConfigure("motorSim1", "motorSim", 0, 6)
motorSimConfigAxis("motorSim1", 0, 20000, -20000, 500, 0)
motorSimConfigAxis("motorSim1", 1, 20000, -20000, 500, 0)
motorSimConfigAxis("motorSim1", 2, 20000, -20000, 500, 0)
motorSimConfigAxis("motorSim1", 3, 20000, -20000, 500, 0)
motorSimConfigAxis("motorSim1", 4, 20000, -20000, 500, 0)
motorSimConfigAxis("motorSim1", 5, 20000, -20000, 500, 0)

iocInit()

## more autosave/restore machinery
cd $(TOP)/autosave/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

cd $(TOP)

dbpf testcam:Pva1:EnableCallbacks 1
dbpf testcam:cam1:AcquirePeriod 1
