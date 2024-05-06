## ----chapter6_init,echo=FALSE,eval=TRUE,rlst=FALSE----------------------------
opts_knit$set(self.contained=FALSE)


## ----chapter6_episodes,echo=FALSE---------------------------------------------
library(RHRV)
data(HRVData)
hrv.data <- HRVData
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- AddEpisodes(hrv.data,
                        InitTimes = c(700, 2000, 5000),
                        Tags = c("Before", "During", "After"),
                        Durations = c(900, 2000, 600), 
                        Values = c(0, 0, 0))

ListEpisodes(hrv.data)


## ----chapter6_Rinit2,echo=FALSE,results='hide'--------------------------------
remove(hrv.data)


## ----chapter6_loadascii-------------------------------------------------------
library(RHRV)
data(HRVData)
hrv.data <- HRVData
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- LoadEpisodesAscii(hrv.data, "apnea_ascii.txt")
ListEpisodes(hrv.data)


## ----chapter6_Rinit5,echo=FALSE,results='hide'--------------------------------
remove(hrv.data)


## ----chapter6_wfdb,results='hide'---------------------------------------------
dirorig <-
  "http://www.physionet.org/physiobank/database/apnea-ecg/"
files <- c("a01.hea", "a01.apn", "a01.qrs")
filesorig <- paste(dirorig, files, sep = "")
for (i in 1:length(files))
  download.file(filesorig[i], files[i])
library(RHRV)
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatWFDB(hrv.data, "a01")
hrv.data <- LoadApneaWFDB(hrv.data, "a01")


## ----chapter6_text,results='hide'---------------------------------------------
# dirorig <- "http://www.milegroup.net/files/rhrv/"
dirorig <- "https://raw.githubusercontent.com/milegroup/ghrv/master/tmp/"
files <- c("a01.beats.txt", "a01.tags.txt")
filesorig <- paste(dirorig, files, sep = "")
for (i in 1:length(files))
  download.file(filesorig[i], files[i])
library(RHRV)
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatAscii(hrv.data, "a01.beats.txt")
hrv.data <- LoadEpisodesAscii(hrv.data, "a01.tags.txt")


## ----chapter6_addepisodes-----------------------------------------------------
hrv.data <- AddEpisodes(hrv.data,
                        InitTimes = c(5000, 15000),
                        Durations = c(2000, 2000),
                        Tags = c("Tag1", "Tag2"),
                        Values = c(0, 0))
ListEpisodes(hrv.data)


## ----chapter6_generateepisodes------------------------------------------------
hrv.data <- GenerateEpisodes(hrv.data, NewBegFrom = "Beg",
   NewEndFrom = "Beg", DispBeg = -70, DispEnd = -10,
  OldTag = "APNEA", NewTag = "Pre-APNEA")
ListEpisodes(hrv.data)


## ----chapter6_removeepisodes--------------------------------------------------
hrv.data <- RemoveEpisodes(hrv.data, Tags = "APNEA", 
                           Indexes = c(1, 6))
ListEpisodes(hrv.data)


## ----chapter6_modifyepisodes--------------------------------------------------
hrv.data <- ModifyEpisodes(hrv.data, Tags = "Tag1",
                           Indexes = 3,
                           NewDurations = c(300, 400),
                           NewValues = 8.5)
ListEpisodes(hrv.data)


## ----chapter6_episodes2,echo=FALSE--------------------------------------------
remove(hrv.data)
hrv.data <- CreateHRVData()
hrv.data <- LoadBeatRR(hrv.data, "rr.txt")
hrv.data <- AddEpisodes(hrv.data, InitTimes = 3920, Durations = 2000, Tags = "Pre-apnea", Values = 0)
hrv.data <- AddEpisodes(hrv.data, InitTimes = 9140, Durations = 1840, Tags = "Post-apnea", Values = 0)
hrv.data <- AddEpisodes(hrv.data, InitTimes = 6270, Durations = 2520, Tags = "Apnea", Values = 0)
#hrv.data <- AddEpisodes(hrv.data, InitTimes = c(750, 6270, 11130), Durations = c(2820, 2520, 2580),Tags= "APNEA", Values = 0)
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)

ListEpisodes(hrv.data)


## ----chapter6_PlotNIHR, dev = 'pdf',echo = FALSE, rlst = FALSE, fig.height = 5,fig.cap = "Plot obtained using Tags = \``all'' in PlotNIHR."----
PlotNIHR(hrv.data, Tags = "all")


## ----chapter6_PlotHR, dev= 'pdf',echo = FALSE, rlst = FALSE, fig.height = 5, fig.cap = "Plot obtained using Indexes = c(1, 2) in PlotHR."----
hrv.data <- InterpolateNIHR(hrv.data)
PlotHR(hrv.data, Indexes = c(1, 2))


## ----chapter6_PlotPowerBand, dev = 'pdf', echo = FALSE, rlst = FALSE, fig.height = 6,fig.cap = "Plot obtained using Tags = c(\``Apnea'', \``Post-apnea'') in PlotPowerBand."----
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePowerBand(hrv.data, size = 120, shift = 10)
PlotPowerBand(hrv.data, Tags = c("Apnea", "Post-apnea"), hr = TRUE)


## ----chapter6_Spectrogram, dev = 'pdf',echo = FALSE, rlst = FALSE, fig.height = 4,fig.cap = "Plot obtained using Indexes = c(2, 3) in PlotSpectrogram."----
spctr <- PlotSpectrogram(hrv.data, size = 120, shift = 60,freqRange = c(0, 0.06),Indexes = c(2, 3), color.palette = terrain.colors)


## ----chapter6_splithrbyepisodes-----------------------------------------------
SplitData <- SplitHRbyEpisodes(hrv.data, Tag = "Apnea")
str(SplitData)


## ----chapter6_analyzehrbyepisodes---------------------------------------------
SDApnea <-
   AnalyzeHRbyEpisodes(hrv.data, Tag = "Apnea", 
                       func = sd)
SDPostapnea <-
   AnalyzeHRbyEpisodes(hrv.data, Tag = "Post-apnea", 
                       func = sd)
cat("SD within apnea:", SDApnea$resultIn, 
   "\nSD within post-apnea:", SDPostapnea$resultIn, "\n")


## ----chapter6_Rinit4,echo=FALSE,results='hide'--------------------------------
remove(HRVData)


## ----chapter6_example1,dev='pdf',fig.height=5,fig.cap="Data included in RHRV with episodes added manually."----
library(RHRV)
data(HRVData)
hrv.data <- HRVData
hrv.data <- BuildNIHR(hrv.data)
hrv.data <- FilterNIHR(hrv.data)
hrv.data <- InterpolateNIHR(hrv.data)
hrv.data <- AddEpisodes(hrv.data, 
  InitTimes = c(0, 2000, 4000), 
  Durations = c(1600, 1800, 1500),
  Tags = c("Basal", "E1", "Post-E1"),
  Values = c(0, 0, 0))
PlotHR(hrv.data,Tags = "all")


## ----chapter6_example2--------------------------------------------------------
CalPower <- function(v) {
  sumpower <- sum(v ^ 2) / length(v)
  return(sumpower)
}
rBasal <- AnalyzeHRbyEpisodes(hrv.data, Tag = "Basal",
    func= "CalPower")
rE1 <- AnalyzeHRbyEpisodes(hrv.data, Tag = "E1",
    func="CalPower")
cat("Mean power:\n  Basal situation:", rBasal$resultIn,
   "\n  After E1 prostaglandin:", rE1$resultIn,"\n")


## ----chapter6_example3, dev = 'pdf', fig.height = 5, fig.cap = "LF/HF ratios for the Basal and E1 episodes."----
hrv.data <- CreateFreqAnalysis(hrv.data)
hrv.data <- CalculatePowerBand(hrv.data, size = 120, 
                               shift = 10)
dBasal <- SplitPowerBandByEpisodes(hrv.data,
                                   Tag = "Basal")
dE1 <- SplitPowerBandByEpisodes(hrv.data,Tag = "E1")
Basal_LFHF <- 
  dBasal$InEpisodes$LF / dBasal$InEpisodes$HF
E1_LFHF <- dE1$InEpisodes$LF / dE1$InEpisodes$HF
boxplot(Basal_LFHF, E1_LFHF, outline = FALSE, 
    col = c("blue", "red"),
    names = c("Basal", "E1"),
    main = "Basal vs prostaglandin E1",
    ylab = "LF/HF ratio")

