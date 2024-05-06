## ----chapter7_init,echo=FALSE,eval=TRUE,rlst=FALSE----------------------------
opts_knit$set(self.contained=FALSE)


## ----chapter7_ObtainingOriginalRecordings, eval=FALSE-------------------------
## # HRVData structure containing the heart beats
## OriginDir <-
##   "http://www.physionet.org/physiobank/database/ltstdb/"
## items = c("s20011", "s20021", "s20031", "s20041",
##           "s20071", "s20091", "s20111", "s20121",
##           "s20131", "s20141")
## for (i in 1:length(items)) {
##   headerFile <- paste(items[[i]], ".hea", sep = "")
##   annotationFile <- paste(items[[i]], ".atr", sep = "")
## 
##   files <- c(headerFile, annotationFile)
##   OriginFiles <- paste(OriginDir, files, sep = "")
##   for (j in 1:2)
##     download.file(OriginFiles[j], files[j])
## }


## ----chapter7_HRVAnalysis, eval=FALSE-----------------------------------------
## # hrv.data structure creation and preprocessing
## 
## # Index for the record to be analyzed:
## # from 1 (s20011) to 10 (s20141)
## i = 1
## 
## hrv.data <- CreateHRVData()
## hrv.data <- SetVerbose(hrv.data, TRUE)
## 
## hrv.data <- LoadBeat("WFDB", HRVData, "s20011",
##                     annotator = "atr")
## 
## hrv.data <- BuildNIHR(hrv.data)
## hrv.data <- FilterNIHR(hrv.data)
## hrv.data <- InterpolateNIHR(hrv.data)
## 
## # Intervals definition and HRVData structures created
## 
## duration <- 10800
## initAfternoon <- 1320
## initNight <- 24720
## initMorning <- 49920
## 
## hrv.data.morning <-
##   ExtractTimeSegment(hrv.data,
##                      starttime = initMorning,
##                      endtime = initMorning + duration)
## hrv.data.afternoon <-
##   ExtractTimeSegment(hrv.data,
##                      starttime = initAfternoon,
##                      endtime = initAfternoon + duration)
## hrv.data.night <-
##   ExtractTimeSegment(hrv.data,
##                      starttime = initNight,
##                      endtime = initNight + duration)
## 
## # Spectral analysis
## 
## hrv.data.morning <-
##   CreateFreqAnalysis(hrv.data.morning)
## hrv.data.morning <-
##   CalculatePowerBand(hrv.data.morning,
##                      indexFreqAnalysis = 1,
##                      shift = 30)
## 
## hrv.data.afternoon <-
##   CreateFreqAnalysis(hrv.data.afternoon)
## hrv.data.afternoon <-
##   CalculatePowerBand(hrv.data.afternoon,
##                      indexFreqAnalysis = 1,
##                      shift = 30)
## 
## hrv.data.night <-
##   CreateFreqAnalysis(hrv.data.night)
## hrv.data.night <-
##   CalculatePowerBand(hrv.data.night,
##                      indexFreqAnalysis = 1,
##                      shift = 30)
## 
## # Time analysis
## 
## hrv.data.morning <- CreateTimeAnalysis(hrv.data.morning,
##                                        size = 300)
## hrv.data.afternoon <- CreateTimeAnalysis(hrv.data.afternoon,
##                                          size = 300)
## hrv.data.night <- CreateTimeAnalysis(hrv.data.night,
##                                      size = 300)
## 
## # Nonlinear analysis
## 
## hrv.data.morning <-
##   CreateNonLinearAnalysis(hrv.data.morning)
## hrv.data.morning <-
##   CalculateCorrDim(hrv.data.morning,
##                    indexNonLinearAnalysis = 1,
##                    minEmbeddingDim = 2,
##                    maxEmbeddingDim = 8, timeLag = 1,
##                    minRadius = 1, maxRadius = 15,
##                    pointsRadius = 20, theilerWindow = 10,
##                    corrOrder = 2, doPlot = FALSE)
## hrv.data.morning <- CalculateSampleEntropy(hrv.data.morning)
## hrv.data.morning <- EstimateSampleEntropy(hrv.data.morning)
## hrv.data.morning <- PoincarePlot(hrv.data.morning)
## 
## hrv.data.afternoon <-
##   CreateNonLinearAnalysis(hrv.data.afternoon)
## hrv.data.afternoon <-
##   CalculateCorrDim(hrv.data.afternoon,
##                    indexNonLinearAnalysis = 1,
##                    minEmbeddingDim = 2,
##                    maxEmbeddingDim = 8, timeLag =1 ,
##                    minRadius = 1, maxRadius = 15,
##                    pointsRadius = 20, theilerWindow = 10,
##                    corrOrder = 2, doPlot = FALSE)
## hrv.data.afternoon <- CalculateSampleEntropy(hrv.data.afternoon)
## hrv.data.afternoon <- EstimateSampleEntropy(hrv.data.afternoon)
## hrv.data.afternoon <- PoincarePlot(hrv.data.afternoon)
## 
## hrv.data.night <-
##   CreateNonLinearAnalysis(hrv.data.night)
## hrv.data.night <-
##   CalculateCorrDim(hrv.data.night,
##                    indexNonLinearAnalysis = 1,
##                    minEmbeddingDim=2,
##                    maxEmbeddingDim = 8, timeLag = 1,
##                    minRadius = 1, maxRadius = 15,
##                    pointsRadius = 20, theilerWindow =10,
##                    corrOrder = 2, doPlot = FALSE)
## hrv.data.night <- CalculateSampleEntropy(hrv.data.night)
## hrv.data.night <- EstimateSampleEntropy(hrv.data.night)
## hrv.data.night <- PoincarePlot(hrv.data.night)
## 
## 
## # new morning, afternoon and data strcutures creation
## 
## MorningData[[i]] <- hrv.data.morning
## AfternoonData[[i]] <- hrv.data.afternoon
## NightData[[i]] <- hrv.data.night


## ----chapter7_HRVStatistics, eval=FALSE---------------------------------------
## 
## Morning <- list()
## # One index for each of the values of each analyzed record
## for (i in 1:10) {
##   Morning$HRV[[i]] <-
##     mean(MorningData[[i]]$FreqAnalysis[[1]]$HRV)
##   Morning$LF[[i]] <-
##     mean(MorningData[[i]]$FreqAnalysis[[1]]$LF)
##   Morning$HF[[i]] <-
##     mean(MorningData[[i]]$FreqAnalysis[[1]]$HF)
##   Morning$LFHF[[i]] <-
##     mean(MorningData[[i]]$FreqAnalysis[[1]]$LFHF)
## 
##   Morning$pNN50[[i]] <-
##     MorningData[[i]]$TimeAnalysis[[1]]$pNN50
##   Morning$rMSSD[[i]] <-
##     MorningData[[i]]$TimeAnalysis[[1]]$rMSSD
##   Morning$HRVi[[i]] <-
##     MorningData[[i]]$TimeAnalysis[[1]]$HRVi
## 
##   Morning$SampleEntropy[[i]] <-
##     MorningData[[i]]$NonLinearAnalysis[[1]]$sampleEntropy$statistic
##   Morning$PoincareSD1[[i]] <-
##     MorningData[[i]]$NonLinearAnalysis[[1]]$PoincarePlot$SD1
##   Morning$PoincareSD2[[i]] <-
##     MorningData[[i]]$NonLinearAnalysis[[1]]$PoincarePlot$SD2
## }
## 
## 


## ----chapter7_StatisticalExample, eval=FALSE----------------------------------
## HRVMorningAfternoon <- t.test(Morning$HRV,
##                               Afternoon$HRV,
##                               paired = TRUE)
## HFMorningAfternoon <- t.test(Morning$HF,
##                              Afternoon$HF,
##                              paired = TRUE)
## LFMorningAfternoon <- t.test(Morning$LF,
##                              Afternoon$LF,
##                              paired = TRUE)
## LFHFMorningAfternoon <- t.test(Morning$LFHF,
##                                Afternoon$LFHF,
##                                paired = TRUE)
## pNN50MorningAfternoon <- t.test(Morning$pNN50,
##                                 Afternoon$pNN50,
##                                 paired = TRUE)
## rMSDMorningAfternoon <- t.test(Morning$rMSD,
##                                Afternoon$rMSD,
##                                paired = TRUE)
## HRViMorningAfternoon <- t.test(Morning$HRVi,
##                                Afternoon$HRVi,
##                                paired = TRUE)
## MorningAfternoon <- t.test(Morning$SampleEntropy,
##                            Afternoon$SampleEntropy,
##                            paired = TRUE)
## PoincareSD1MorningAfternoon <-
##   t.test(Morning$PoincareSD1, Afternoon$PoincareSD1,
##          paired = TRUE)
## PoincareSD2MorningAfternoon <-
##   t.test(Morning$PoincareSD2, Afternoon$PoincareSD2,
##          paired = TRUE)

