## ----chapter4_init,echo=FALSE,message=FALSE,rlst=FALSE------------------------
opts_knit$set(self.contained = FALSE)


## ----chapter4_readM2,echo=TRUE,rlst=T,fig.cap='Heart rate series from a volunteer breathing at a constant rate. Note the sinusal pattern.',fig.height=4,fig.width=7----
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data,RecordName = "M2", 
                         RecordPath = "sampleData",
                         annotator = "qrs")
hrv.data <- BuildNIHR(hrv.data)
PlotNIHR(hrv.data, xlim = c(200, 400))


## ----chapter4_creatingFreq,eval=TRUE, rlst=TRUE-------------------------------
hrv.data <- SetVerbose(hrv.data, TRUE)
hrv.data <- CreateFreqAnalysis(hrv.data)


## ----chapter4_periodogramLomb,echo=TRUE,rlst=T,fig.cap='PSD estimate obtained with the \\index{Periodogram!Lomb-Scargle}Lomb-Scargle periodogram.',cache=TRUE,fig.height=5,fig.width=7----
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data, RecordName = "M2", 
                         RecordPath = "sampleData",
                         annotator = "qrs")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- SetVerbose(hrv.data,TRUE)
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "lomb", doPlot = FALSE)
PlotPSD(hrv.data, indexFreqAnalysis = 1)


## ----chapter4_periodogramLomb2,echo=TRUE,rlst=T,fig.cap='Non-default options with the \\textit{PlotPSD} function.',cache=TRUE,fig.height=4,fig.width=7----
PlotPSD(hrv.data, indexFreqAnalysis = 1,
        usePalette = c("black", "darkorchid3",
                       "darkolivegreen4",
                       "dodgerblue4", "goldenrod1"),
        ULFmin = NULL, ULFmax = NULL, VLFmin = 0, VLFmax = 0.05,
        main = "PSD estimate using Lomb-Scargle method",
        log = "")


## ----chapter4_periodogramAR,echo=TRUE,rlst=T,fig.cap='\\index{Periodogram!Parametric}AR-based \\index{PSD}PSD estimation. Note the smooth periodogram that is obtained with this method.',cache=TRUE,fig.height=3.5,fig.width=7----
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data, RecordName = "M2", 
                         RecordPath = "sampleData",
                         annotator = "qrs")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
# AR methods do need interpolated data!!
hrv.data <- InterpolateNIHR(hrv.data)
hrv.data <- SetVerbose(hrv.data, TRUE)
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "ar", doPlot = TRUE, log = "")


## ----chapter4_tuningAR,echo=TRUE,rlst=T,fig.cap='Periodogram obtained using a fixed AR model of order 16.',cache=TRUE,fig.height=3.5,fig.width=7----
# ... load, filter and interpolated data
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "ar", order = 16, n.freq = 1000, 
                         doPlot = TRUE, log = "")


## ----chapter4_pgram,echo=TRUE,rlst=T,fig.cap='Periodogram \\index{Periodogram} obtained using the \\index{FT!DFT}DFT (no smoothing is applied).',cache=TRUE,fig.height=5.5,fig.width=7----
# ... load, filter and interpolated data
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "pgram")


## ----chapter4_tuningPgram,echo=TRUE,rlst=T,fig.cap='Periodogram obtained using the \\index{FT!DFT}DFT and two passes of a Daniell smoother of length 9.',cache=TRUE,fig.height=5,fig.width=7----
# ... load, filter and interpolated data
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "pgram", spans = c(9, 9),
                         ULFmin = NULL)


## ----chapter4_tuningPgram2,echo=TRUE,rlst=T,fig.cap='Illustration of the effect of detrending in the \\index{PSD}PSD estimation. Compare this figure with Figure \\ref{fig:chapter4_tuningPgram}. Since the time series has not been detrended, the energy in the \\index{Frequency Bands!ULF}ULF band dominates the \\index{Periodogram}periodogram.',cache=TRUE,fig.height=4,fig.width=7----
# ... load, filter and interpolated data
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "pgram", spans = c(9, 9),
                         detrend = FALSE)


## ----chapter4_several,echo=TRUE,rlst=T,fig.cap='Comparison of the different \\index{PSD}PSD estimation methods.',cache=TRUE----
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data, RecordName = "M2", 
                         RecordPath = "sampleData",
                         annotator = "qrs")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- SetVerbose(hrv.data, TRUE)
# Lomb-Scargle does not require interpolation ...
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 1,
                         method = "lomb", doPlot = FALSE)

# ... but the others methods need equally sampled data
hrv.data <- InterpolateNIHR(hrv.data)

hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 2,
                         method = "ar", order = 16,
                         doPlot = FALSE)


hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 3,
                         method = "pgram", 
                         doPlot = FALSE)


hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePSD(hrv.data, indexFreqAnalysis = 4,
                         method = "pgram", 
                         spans = 9,
                         doPlot = FALSE)
# Plot the results
use.ylim = c(1, 1.5e+5)
layout(matrix(1:4, 2, 2, byrow = TRUE))
PlotPSD(hrv.data, 1, addLegend = FALSE,
        addSigLevel = FALSE, ylim = use.ylim)
PlotPSD(hrv.data, 2, addLegend = FALSE, 
        ylim = use.ylim)
PlotPSD(hrv.data, 3, addLegend = FALSE,
        ylim = use.ylim)
PlotPSD(hrv.data, 4, addLegend = FALSE,
        ylim = use.ylim)


## ----chapter4_exampleFile,echo=FALSE,rlst=F,fig.cap='Heart rate series used for illustrative purposes in this chapter. Note the drop in heart rate due to the prostaglandin E1 administration.',fig.height=4,fig.width=7----
data("HRVProcessedData")
PlotNIHR(HRVProcessedData)


## ----chapter4_dataLoad,eval=FALSE,rlst=TRUE-----------------------------------
## # hrv.data structure containing the heart beats
## data("HRVData")
## # HRVData structure storing the results of processing
## # the heart beats: the beats have been filtered,
## # interpolated, ...
## data("HRVProcessedData")


## ----chapter4_STFTanalysis,eval=TRUE,rlst=TRUE--------------------------------
hrv.data <- CreateHRVData()
hrv.data <- SetVerbose(hrv.data, FALSE)
hrv.data <- LoadBeatAscii(hrv.data, "sampleData/example.beats")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- InterpolateNIHR(hrv.data)
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- SetVerbose(hrv.data, TRUE)
hrv.data <- CalculatePowerBand(hrv.data, size = 600,
                               shift = 30)


## ----chapter4_STFTanalysis2,eval=FALSE,rlst=TRUE------------------------------
## hrv.data <-
##   CalculatePowerBand(hrv.data, indexFreqAnalysis= 1,
##                      size = 600, shift = 30,
##                      sizesp = 4096,
##                      type = "fourier",
##                      ULFmin = 0, ULFmax = 0.03,
##                      VLFmin = 0.03, VLFmax = 0.05,
##                      LFmin = 0.05, LFmax = 0.15,
##                      HFmin = 0.15, HFmax = 0.4 )


## ----chapter4_STFTanalysis3,rlst=T,fig.cap='Power Bands computed using the \\index{FT!STFT}STFT.'----
PlotPowerBand(hrv.data, ymax = 200, ymaxratio = 1.7)


## ----chapter4_STFTanalysis4,eval=FALSE, rlst=TRUE-----------------------------
## hrv.data <- CreateHRVData()
## hrv.data <- SetVerbose(hrv.data, FALSE)
## hrv.data <- LoadBeatAscii(hrv.data, "sampleData/example.beats")
## hrv.data <- BuildNIHR(hrv.data)
## hrv.data <- FilterNIHR(hrv.data)
## hrv.data <- InterpolateNIHR (hrv.data)
## hrv.data <- CreateFreqAnalysis(hrv.data)
## hrv.data <- CalculatePowerBand(hrv.data, size = 600,
##                                shift = 30)
## spectrogram <- CalculateSpectrogram(hrv.data,
##                                    size = 600,
##                                    shift = 30)


## ----chapter4_plotSpectrogram,fig.cap='Spectrogram of the RR time series.',cache=TRUE, rlst=TRUE----
spectrogram <- PlotSpectrogram(HRVData = hrv.data, 
                               size = 600, shift = 60, 
                               scale = "logaritmic", 
                               freqRange = c(0, 0.4))


## ----chapter4_removeVerbose,echo=FALSE, rlst=FALSE----------------------------
hrv.data <- SetVerbose(hrv.data, F)


## ----chapter4_plotSpectrogramNoULF,fig.cap="Spectrogram ignoring the \\index{Frequency Bands!ULF}ULF band. The presence of harmonic components is apparent.",cache=TRUE, rlst=TRUE----
spectrogram <- PlotSpectrogram(HRVData = hrv.data, 
                               size = 600, shift = 60, 
                               scale = "logaritmic", 
                               freqRange = c(0.04, 0.4))


## ----chapter4_WaveletAnalysis,eval=FALSE, rlst=TRUE---------------------------
## hrv.data <- CreateHRVData()
## hrv.data <- SetVerbose(hrv.data, FALSE)
## hrv.data <- LoadBeatAscii(hrv.data, "example.beats")
## hrv.data <- BuildNIHR(hrv.data)
## hrv.data <- FilterNIHR(hrv.data)
## hrv.data <- InterpolateNIHR (hrv.data)
## hrv.data <- CreateFreqAnalysis(hrv.data)
## hrv.data <- SetVerbose(hrv.data, TRUE)
## hrv.data <- CalculatePowerBand(hrv.data,
##                               size = 600, shift = 30)
## hrv.data <- CalculatePowerBand(hrv.data,
##                               type = "wavelet",
##                               bandtolerance = 0.01,
##                               relative = FALSE)
## 


## ----chapter4_WaveletAnalysis2,eval=FALSE,rlst=TRUE---------------------------
## hrv.data <-
##   CalculatePowerBand(hrv.data, indexFreqAnalysis= 1,
##                      type = "wavelet", wavelet = "d4",
##                      bandtolerance = 0.01,
##                      relative = FALSE,
##                      ULFmin = 0, ULFmax = 0.03,
##                      VLFmin = 0.03, VLFmax = 0.05,
##                      LFmin = 0.05, LFmax = 0.15,
##                      HFmin = 0.15, HFmax = 0.4)


## ----chapter4_bothAnalysis,cache=TRUE,fig.show='hide',rlst=TRUE---------------
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatAscii(hrv.data, "sampleData/example.beats")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- InterpolateNIHR(hrv.data, freqhr = 4)
hrv.data <- CreateFreqAnalysis(hrv.data)
# use freqAnalysis number 1 with Fourier analysis
hrv.data <- CalculatePowerBand(hrv.data,
                               indexFreqAnalysis = 1,
                               size = 600, shift = 30,
                               type = "fourier")
PlotPowerBand(hrv.data, indexFreqAnalysis = 1,
              ymax = 200, ymaxratio = 1.7)
# use freqAnalysis number 2 with wavelet analysis
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePowerBand(hrv.data,
                               indexFreqAnalysis = 2,
                               type = "wavelet",
                               wavelet = "la8",
                               bandtolerance = 0.01,
                               relative = FALSE)
PlotPowerBand(hrv.data, indexFreqAnalysis = 2,
              ymax = 800, ymaxratio = 50)

