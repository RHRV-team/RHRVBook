## ----chapter8_RHRVEasy-prototype, eval=FALSE, rlst=TRUE-----------------------
## # Prototype of the main RHRVEasy function.
## RHRVEasy <-
##   function(folders,
##            verbose = FALSE,
##            format = "RR",
##            typeAnalysis = "fourier",
##            correctionMethod = "bonferroni",
##            significance = 0.05,
##            nonLinear = FALSE,
##            doRQA = FALSE,
##            nJobs = 1,
##            saveHRVIndicesInPath = NULL,
##            ...)


## ----chapter8_RHRVEasy-output, eval=FALSE, rlst=TRUE--------------------------
## # Fragment of the output of a RHRVEasy object when
## # displayed on the console. The text output format
## # has been adapted to enhance its readability in the book.
## 
## ## Significant differences in SDNN (Kruskal-Wallis rank
## ## sum test, bonferroni p-value = 1.117154e-07):
## ##   chf's mean95% CI: (62.17953, 93.58125)
## ##                    [Bootstrap CI without adjustment]
## ##   normal's mean95% CI: (131.7343, 148.0405)
## ##                    [Bootstrap CI without adjustment]
## ##
## ## Significant differences in SDANN (Kruskal-Wallis rank
## ## sum test, bonferroni p-value = 3.799696e-07):
## ##   chf's mean95% CI: (48.07725, 80.67042)
## ##                    [Bootstrap CI without adjustment]
## ##   normal's mean95% CI: (121.2193, 137.836)
## ##                    [Bootstrap CI without adjustment]


## ----chapter8_RHRVEasy-setup, eval=TRUE---------------------------------------
# Variables that contain the paths of the NSR_DB 
# and the CHF_DB databases.
library(RHRV)
basePath <- "data/Chapter8"
NSR_DB <- file.path(basePath, "normal")
CHF_DB <- file.path(basePath, "chf")


## ----chapter8_RHRVEasy_NSR_CHF, eval=TRUE, warning=FALSE, message=FALSE, cache=TRUE----
# Analysis of the NSR_DB and the CHF_DB databases 
# using RHRVEasy.
easyAnalysis <- RHRVEasy(folders = c(NSR_DB, CHF_DB))


## ----chapter8_to_tibble, rlst=FALSE, echo=FALSE-------------------------------
easyAnalysis$HRVIndices  <- tibble::as_tibble(easyAnalysis$HRVIndices)


## ----chapter8_RHRVEasy_NSR_CHF_results, eval=TRUE, rlst=TRUE, out.lines=10----
# Print output adapted for brevity
print(easyAnalysis)
# The analysis results can also be accessed using the 
# slots $HRVIndices and $stats. For HRVIndices, show only
# the first 6 columns
head(easyAnalysis$HRVIndices[, 1:6])
head(easyAnalysis$stats)


## ----chapter8_RHRVEasy_NSR_CHF_results_wavelet, warning=FALSE, message=FALSE, cache=TRUE----
# Analysis of the NSR_DB and the CHF_DB databases using 
# the wavelet transform for frequency indices calculation.
easyAnalysisWavelet <- RHRVEasy(folders = c(NSR_DB, CHF_DB), 
                                typeAnalysis = "wavelet")


## ----chapter8_RHRVEasy_NSR_CHF_results_excel, message=FALSE, warning=FALSE, cache=TRUE----
# When specifying a value for the argument saveHRVIndicesInPath, 
# an Excel file with the HRV indices is created at the path 
# specified by the argument
spreadsheetPath <- basePath
easyAnalysis <- RHRVEasy(folders = c(NSR_DB, CHF_DB), 
                         saveHRVIndicesInPath = spreadsheetPath)


## ----chapter8_RHRVEasy_NSR_CHF_results_excel2, message=FALSE, warning=FALSE, cache=TRUE----
# The HRV indices contained in a RHRVEasy object called 
# easyAnalysis are saved in an Excel file at the specified path
SaveHRVIndices(easyAnalysis,
               saveHRVIndicesInPath = spreadsheetPath)


## ----chapter8_RHRVEasy_NSR_CHF_results_fdr, message=FALSE, warning=FALSE, cache=TRUE,results='hide'----
# The false discovery rate ("fdr") method is employed 
# to adjust for significance level
easyAnalysisFDR <- RHRVEasy(folders = c(NSR_DB, CHF_DB),  
                            correctionMethod =  "fdr")
print(easyAnalysisFDR)


## ----chapter8_RHRVEasy_NSR_CHF_results_fdr_bondf, message=FALSE, warning=FALSE----
# The "fdr" correction method is applied over the p-values 
# contained in the object easyAnalysis, (which was created 
# using the "bonferroni" correction)
easyAnalysisFDR <- RHRVEasyStats(easyAnalysis, 
                                 correctionMethod =  "fdr")
pValues <- merge(
  easyAnalysis$stats, 
  easyAnalysisFDR$stats,
  by = setdiff(names(easyAnalysis$stats), "adj.p.value"),
  suffixes = c(".bonf", ".fdr")
)
pValues <- pValues[, c("HRVIndex", "p.value", 
                       "adj.p.value.bonf", "adj.p.value.fdr")]
pValues[, 2:4] <- round(pValues[, 2:4], 4)
#A comparison of the p-values without correction, 
# and applying both corrections is shown in the console
print(head(pValues))


## ----chapter8_healthy_download, cache=TRUE------------------------------------
# paste0 is just used to split the long url
orig <- paste0(
  "https://www.physionet.org/files/",
  "rr-interval-healthy-subjects/1.0.0/"
)
dest <- file.path(basePath, "healthy_ms")
# Create folder dest if not exists 
if (!dir.exists(dest)) {
  dir.create(dest)
}
files <- c("000.txt",  "003.txt",  "005.txt",  "006.txt", 
           "007.txt", "008.txt",  "009.txt",  "010.txt", 
           "013.txt") 

for (file in files) {
  download.file(paste0(orig, file), file.path(dest, file))
}


## ----chapter8_healthy_conversion----------------------------------------------
orig <- file.path(basePath, "healthy_ms")
HEALTHY_DB <- file.path(basePath, "healthy")
# Create folder dest if not exists 
if (!dir.exists(HEALTHY_DB)) {
  dir.create(HEALTHY_DB)
}
for (file in list.files(orig)) {
  rrs_ms <- read.table(file.path(orig, file))
  rrs_ms <- rrs_ms$V1
  # Recording 008 contains an @
  rrs_ms <- as.numeric(rrs_ms[rrs_ms != "@"])
  # Convert from milliseconds to seconds
  write.table(rrs_ms / 1000, file.path(HEALTHY_DB, file), 
              row.names = FALSE, col.names = FALSE)
}


## ----chapter8_RHRVEasy_multiple_groups, warning=FALSE, message=FALSE, cache=TRUE, out.lines=10----
easyAnalysis3 <- 
  RHRVEasy(folders = c(NSR_DB, CHF_DB, HEALTHY_DB))
# Print output adapted for brevity
print(easyAnalysis3)


## ----chapter8_RHRVEasy_posthoc_df---------------------------------------------
print(head(easyAnalysis3$stats))
# Let's print the results of the post-hoc tests for 
# the SDNN index
easyAnalysis3$stats[easyAnalysis3$stats$HRVIndex == "SDNN", ]$pairwise[[1]]


## ----chapter8_RHRVEasy_non_linear, warning=F, message=FALSE, cache=TRUE, eval=FALSE, rlst=TRUE----
## # Analysis of the three databases calculating all
## # the non-linear indices
## fullAnalysis <- RHRVEasy(
##   folders = c(NSR_DB, CHF_DB, HEALTHY_DB),
##   nonLinear = TRUE,
##   doRQA = TRUE,
## )
## # Print output adapted for brevity
## print(fullAnalysis)


## ----chapter8_RHRVEasy_non_linear_parallel, eval=FALSE, rlst=TRUE-------------
## #Parallelized analysis of the four databases
## #using 8 cores
## fullAnalysis <- RHRVEasy(
##   folders = c(NSR_DB, CHF_DB, HEALTHY_DB),
##   nonLinear = TRUE,
##   doRQA = TRUE,
##   nJobs = 8
## )
## print(fullAnalysis)

