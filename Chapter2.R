## ----chapter2_HRVDataStructure, eval=TRUE-------------------------------------
# HRVData structure containing the heart beats
library(RHRV)
hrv.data <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data, TRUE)


## ----chapter2_WFDBBeatLoad, eval=TRUE-----------------------------------------
# Loading the beats in WFDB format
hrv.data1 <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data1, TRUE)
hrv.data2 <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data2, TRUE)
hrv.data1 <- LoadBeat("WFDB", hrv.data1,"sampleData/e0115", annotator = "atr")
hrv.data2 <- LoadBeatWFDB(hrv.data2, "sampleData/e0115", annotator = "atr")


## ----chapter2_ASCIIBeatLoad, eval=TRUE----------------------------------------
# Loading the beats in ASCII format
hrv.data3 <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data3, TRUE)
hrv.data3 <- LoadBeatAscii(hrv.data3, "sampleData/beat_ascii.txt")


## ----chapter2_RemoveOutliers, eval=FALSE--------------------------------------
## ULAST = 13
## LONG = 50
## UMEAN = 1.5 * ULAST
## MINIMUM = 12
## MAXIMUM = 20
## MINBMP = 25
## MAXBPM = 200
## from (i = 2 to NBEATS) {
##   if (i < LONG)
##     MEAN = mean of previous beats
##   else
##     MEAN = mean of the last long beats
##   if ((100 * abs(hr(i) – hr(i - 1)) / hr(i - 1)) < ULAST) ||
##       (100 * abs(hr(i) – hr(i + 1)) / hr(i - 1)) < ULAST) ||
##       (100 * abs(hr(i) – MEAN) / MEAN) < UMEAN) &&
##       (MINBPM <= hr(i) <= MAXBPM)) {
##       valid beat
##       SIGNALDEV = 10 + SIGNALDEV(last LONG beats)
##       if (SIGNALDEV < MINIMUM)
##         SIGNALDEV = MINIMUM
##       if (SIGNALDEV > MAXIMUM)
##         SIGNALDEV = MAXIMUM
##       update ULAST = SIGNALDEV
##       update UMEAN = 1.5 * SIGNALDEV
##   }
##   else
##     i = i + 1
## }


## ----chapter2_BuildingFunction, eval=TRUE-------------------------------------
# Building the non-interpolated heart rate signal
hrv.data3 <- BuildNIHR(hrv.data3)


## ----chapter2_FilteringFunction, eval=TRUE------------------------------------
# Filtering the non-interpolated heart rate signal
hrv.data3 <- FilterNIHR(hrv.data3)


## ----chapter2_NiHRFunction, eval=FALSE----------------------------------------
## # Manual filtering the non-interpolated heart rate signal
## hrv.data3 <- EditNIHR(hrv.data3)


## ----chapter2_InterpolatingFunction, eval=TRUE--------------------------------
#Interpolation of the instantaneous heart rate
hrv.data3 <- InterpolateNIHR(hrv.data3)


## ----chapter2_PlotHRFunction, eval=FALSE--------------------------------------
## # Plotting the interpolated heart rate signal
## PlotHR(hrv.data3, Tags = NULL, Indexes = NULL,
##         main = "Interpolated instantaneous heart rate", xlab = "time (sec.)",
##         ylab = "HR (beats/min.)", type = "l", ylim = NULL, Tag = NULL,
##         verbose = NULL)

