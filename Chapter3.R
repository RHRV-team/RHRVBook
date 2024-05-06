## ----chapter3_init,echo=FALSE,eval=TRUE,rlst=FALSE----------------------------
opts_knit$set(self.contained=FALSE)


## ----chapter3_CreateTimeAnalysis, eval=TRUE-----------------------------------

# Creating time analysis for the hrv.data3 structure created in chapter 2.

hrv.data3 <- CreateHRVData(Verbose = FALSE)
hrv.data3 <- LoadBeatAscii(hrv.data3, "sampleData/beat_ascii.txt")

# Building the non-interpolated heart rate signal
hrv.data3 <- BuildNIHR(hrv.data3)

# Filtering the non-interpolated heart rate signal
#(twice to eliminate all artifacts)
hrv.data3 <- FilterNIHR(hrv.data3)
hrv.data3 <- FilterNIHR(hrv.data3)

hrv.data3 <- SetVerbose(hrv.data3, TRUE)
hrv.data3 <- CreateTimeAnalysis(hrv.data3)

