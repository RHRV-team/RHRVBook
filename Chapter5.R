## ----chapter5_palette,echo=FALSE,rlst=FALSE-----------------------------------
palette(c("#000000", "#E69F00", "#56B4E9", "#009E73", 
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))
#palette(gray.colors(10, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL))


## ----chapter5_loading,echo=TRUE,rlst=T,fig.cap='RR time series while the patient is suffering from obstructive apnea (top) and during normal breathing (bottom).'----
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data, RecordName = "a05",  
                         RecordPath = "./sampleData/",
                         annotator = "qrs")
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- SetVerbose(hrv.data, T)
hrv.apn <- ExtractTimeSegment(hrv.data, 10500, 12300)
hrv.norm <- ExtractTimeSegment(hrv.data, 22000, 24500)
par(mfrow = c(2, 1))
PlotNIHR(hrv.apn, xlim = c(10500, 11000),
         main = "Apnea episode")
PlotNIHR(hrv.norm, main = "Normal breathing")


## ----chapter5_normalPlot,echo=FALSE,rlst=FALSE--------------------------------
par(mfrow = c(1, 1))


## ----chapter5_surrogateTest,rlst=T,fig.cap='Time asymmetry of the RR data and 199 \\index{Surrogate Data}surrogates. We can reject the null hypothesis of a linear stochastic stationary process.',cache=TRUE----
hrv.apn <- CreateNonLinearAnalysis(hrv.apn)
asymmetryStatistic <- function(x){
  x.len = length(x)
  mean(x[1:(x.len - 1)] * x[2:(x.len)] ^ 2 -
         x[1:(x.len - 1)] ^ 2 * x[2:(x.len)])
}
hrv.apn <- SurrogateTest(hrv.apn, oneSided = F,
                        significance = 0.01, K = 5,
                        useFunction = asymmetryStatistic,
                        doPlot = TRUE)


## ----chapter5_timeLagSelection,echo=TRUE,rlst=T,fig.cap='Time lag selection using the ACF. The dotted horizontal line marks the threshold value used for selecting the time lag.'----
# This call is equivalent to CalculateTimeLag(hrv.apn)
time.lag <- CalculateTimeLag(hrv.apn, technique = "acf",
                             method = "first.e.decay",
                             lagMax = 50, doPlot = TRUE)
time.lag <- CalculateTimeLag(hrv.apn, technique = "acf",
                             method = "first.zero",
                             lagMax = 20, doPlot = FALSE)
time.lag <- CalculateTimeLag(hrv.apn, technique = "acf",
                             method = "first.value",
                             value = 0.1, lagMax = 20,
                             doPlot = FALSE)
time.lag <- CalculateTimeLag(hrv.apn, technique = "acf",
                             method = "first.minimum",
                             lagMax = 20, doPlot = FALSE)


## ----chapter5_selectedTL,echo=FALSE,message=FALSE,rlst=FALSE------------------
selectedTL = 7
selectedTheiler = 30


## ----chapter5_timeLagSelectionAMI,echo=TRUE,rlst=T,fig.cap='Time lag selection using the \\index{AMI}AMI. The dotted horizontal lines mark the threshold value used for selecting the time lag. Note the different scales in the y-axis due to the use of different number of bins.'----
par(mfrow = c(1, 2))
CalculateTimeLag(hrv.apn, technique = "ami",
                 lagMax = 40, doPlot = TRUE,
                 units = "Bits")
CalculateTimeLag(hrv.apn, technique = "ami",
                 n.partitions = 18, units = "Bits",
                 lagMax = 40, doPlot = TRUE)
CalculateTimeLag(hrv.apn, technique = "ami",
                 method = "first.value", value = 0.25,
                 lagMax = 40, doPlot = FALSE)
CalculateTimeLag(hrv.apn, technique = "ami",
                 method = "first.minimum", lagMax = 40,
                 doPlot = FALSE)


## ----chapter5_embeddingDim,echo=TRUE,rlst=T,fig.cap='Estimation of the optimum \\index{Phase Space!Embedding Dimension}embedding dimension.'----
hrv.apn <- SetVerbose(hrv.apn, T)
selectedED <- CalculateEmbeddingDim(HRVData = hrv.apn,
                                    maxEmbeddingDim = 20,
                                    threshold = 0.98,
                                    timeLag = selectedTL,
                                    numberPoints = 5000)


## ----chapter5_attractor,rlst=T,fig.cap='3D projection of the attractor reconstructed from  the \\index{RR Interval}RR intervals.'----
library(plot3D)
takens <- BuildTakens(hrv.apn,
                     3, selectedTL)
scatter3D(takens[, 1], takens[, 2], takens[, 3],
          main = "3D projection of the HR attractor",
          phi = 20, theta = 30,
          type = "l", col = 1)


## ----chapter5_copyData,echo=FALSE,rlst=FALSE----------------------------------
hrv.apn0 = hrv.apn


## ----chapter5_corrDimRHRV,rlst=T,fig.cap='Correlation sum from the ``a05" recording. The ``staircase" behavior is due to the discretization error.'----
hrv.apn <- 
  CalculateCorrDim(hrv.apn, timeLag = selectedTL,
                   theilerWindow = selectedTheiler,
                   minEmbeddingDim = selectedED,
                   maxEmbeddingDim = selectedED + 5,
                   minRadius = 10, maxRadius = 300,
                   pointsRadius = 100,
                   doPlot = FALSE)
# magnify axis
PlotCorrDim(hrv.apn,
            cex.lab = 1.4, cex.axis = 1.4,
            cex.main = 1.4, cex.legend = 1.4)


## ----chapter5_nonlinearNoiseReduction,rlst=T----------------------------------
hrv.apn <- 
  NonLinearNoiseReduction(HRVData = hrv.apn,
                          embeddingDim = selectedED,
                          radius = NULL)


## ----chapter5_nonlinearNoiseReductionFigure,echo=FALSE,message=F,rlst=F,fig.cap='Illustration of the nonlinear noise reduction algorithm and the impact of the radius parameter.'----
hrv.apn0 <- SetVerbose(hrv.apn0, FALSE)
par(mfrow = c(2, 2))
PlotNIHR(hrv.apn0, main = "Original niHR (detail)",
         xlim = c(10500, 11000))

PlotNIHR(NonLinearNoiseReduction(HRVData = hrv.apn0,
                                  embeddingDim = selectedED,
                                  radius = NULL),
         main = "niHR after noise reduction\n (NULL radius)",
         xlim = c(10500, 11000))

PlotNIHR(NonLinearNoiseReduction(HRVData = hrv.apn0,
                                  embeddingDim = selectedED,
                                  radius = 50),
         main = "niHR after noise reduction\n (radius=50)",
         xlim = c(10500, 11000))

PlotNIHR(NonLinearNoiseReduction(HRVData = hrv.apn0,
                                  embeddingDim = selectedED,
                                  radius = 100),
         main = "niHR after noise reduction\n (radius=100)",
         xlim = c(10500, 11000))
par(mfrow = c(1, 1)) 


## ----chapter5_corrDimSmoothed,rlst=F,echo=F,message=F,results='hide',fig.cap='Correlation sum \\index{Fractal Dimension!Correlation Dimension} of the  ``a05" recording after applying a noise reduction algorithm. The ``staircase" behavior has disappeared.'----
hrv.apn <- CalculateCorrDim(hrv.apn, timeLag = selectedTL,
                            theilerWindow = selectedTheiler,
                            minEmbeddingDim = selectedED,
                            maxEmbeddingDim = selectedED + 5,
                            minRadius = 10, maxRadius = 300,
                            pointsRadius = 100,
                            doPlot = FALSE)
# magnify axis
PlotCorrDim(hrv.apn,
            cex.lab = 1.4, cex.axis = 1.4,
            cex.main = 1.4, cex.legend = 1.4)


## ----chapter5_corrDimEstimate,rlst=T,fig.cap='Estimation of the \\index{Fractal Dimension!Correlation Dimension}correlation dimension through regression.'----
HRVData <- EstimateCorrDim(hrv.apn,
                           regressionRange = c(120, 145),
                           useEmbeddings = 15:17,
                           doPlot = FALSE)


## ----chapter5_sampleEntropy,rlst=T,fig.cap='Estimation of the \\index{Entropy!Sample Entropy}sample entropy.'----
hrv.apn <- CalculateSampleEntropy(hrv.apn, doPlot = FALSE)
hrv.apn <- EstimateSampleEntropy(hrv.apn,
                                 regressionRange = c(130, 150),
                                 useEmbeddings = 15:17)


## ----chapter5_maxLyapEstimate,rlst=T,fig.cap='Estimation of the maximal \\index{Maximal Lyapunov Exponent}Lyapunov exponent.'----
hrv.apn <- 
  CalculateMaxLyapunov(hrv.apn, minRefPoints = 1000,
                       numberTimeSteps = 25,
                       minEmbeddingDim = selectedED,
                       maxEmbeddingDim = selectedED + 2,
                       timeLag = selectedTL,
                       radius = 60,
                       theilerWindow = selectedTheiler,
                       doPlot = FALSE) 
hrv.apn <- EstimateMaxLyapunov(hrv.apn,
                               useEmbeddings = 13:15,
                               regressionRange = c(1, 8))


## ----chapter5_RQA_silent,rlst=F,cache=T,echo=FALSE,fig=FALSE,message=FALSE,warning=FALSE----
hrv.apn <-  RQA(hrv.apn,
                indexNonLinearAnalysis = 1,
                embeddingDim = selectedED,
                timeLag = selectedTL,
                lmin = 5,
                vmin = 5,
                radius = 73, doPlot = FALSE)
rqa_pars = hrv.apn$NonLinearAnalysis[[1]]$rqa


## ----chapter5_RQA,rlst=T,fig.cap='\\index{Recurrence Plot}RP of the ``a05" recording. The harmonic behavior of the \\index{RR Interval}RR intervals is evident from this plot.',cache=T----
hrv.apn <-  RQA(hrv.apn,
                indexNonLinearAnalysis = 1,
                embeddingDim = selectedED,
                timeLag = selectedTL,
                lmin = 5, vmin = 5,
                radius = 73, doPlot = TRUE)
# print the RQA parameters
str(hrv.apn$NonLinearAnalysis[[1]]$rqa[2:12])


## ----chapter5_recRate,rlst=T,fig.cap='t-recurrence rate\\index{RQA!t-recurrence Rate} of the signal. The harmonic behavior of the RP can be quantified using this measure.'----
recRate <- hrv.apn$NonLinearAnalysis[[1]]$rqa$recurrenceRate
plot(1:length(recRate), recRate, type = "l",
     main = "Recurrence Rate",
     xlab = "Distance to main diagonal",
     ylab = "Rate of recurrent point",
     xlim = c(0, 500))


## ----chapter5_poincare,rlst=T,fig.cap='\\index{Poincar{\\\'e} Plot}Poincar\\\'{e} plot of the ``a05" register with $\\tau=1$.',fig.height=5,fig.width=10----
par(mfrow = c(1, 2))
hrv.apn <- PoincarePlot(hrv.apn,
                        confidence = 0.95,
                        timeLag = 1, doPlot = TRUE)
hrv.apn <- CreateNonLinearAnalysis(hrv.apn)
hrv.apn <- PoincarePlot(hrv.apn,
                        confidenceEstimation = T, 
                        confidence = 0.95, timeLag = 1, 
                        doPlot = TRUE,
                        main = "Poincare plot \n(Covariance approach)")
par(mfrow = c(1, 1))


## ----chapter5_dfa,rlst=T,fig.cap='DFA \\index{DFA} of the \\index{RR Interval}RR intervals from recording ``a05" during normal breathing. It should be noted the existence of two different scaling exponents: one for $n<20$ and another one for $n>20$.',cache=T----
hrv.norm <- CreateNonLinearAnalysis(hrv.norm)
hrv.norm <- CalculateDFA(hrv.norm,
                         windowSizeRange = c(5, 300),
                         npoints = 100, doPlot = TRUE)


## ----chapter5_estimateDFA,rlst=T,fig.cap=''-----------------------------------
hrv.norm <- EstimateDFA(hrv.norm,
                        regressionRange = c(5, 20),
                        doPlot = FALSE)
hrv.norm <- EstimateDFA(hrv.norm,
                        regressionRange = c(20, 200),
                        doPlot = FALSE)


## ----chapter5_restorePlots,echo=F,rlst=FALSE----------------------------------
par(mfrow = c(1, 1))


## ----chapter5_spectralIndex,rlst=T,fig.cap='Estimation of the \\index{Spectral Index}spectral index.'----
hrv.norm <- SetVerbose(hrv.norm, F)
hrv.norm <- InterpolateNIHR(hrv.norm)
hrv.norm <- CreateFreqAnalysis(hrv.norm)
hrv.norm <- CalculatePSD(hrv.norm, indexFreqAnalysis = 1,
                        method = "pgram", doPlot = FALSE)
hrv.norm <- SetVerbose(hrv.norm, T)
hrv.norm <- 
  EstimatePSDSlope(hrv.norm, indexFreqAnalysis = 1,
                   indexNonLinearAnalysis = 1,
                   regressionRange = c(5e-04, 3e-02))

