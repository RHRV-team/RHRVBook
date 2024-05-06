## ----chapter8_init,echo=FALSE,eval=TRUE,rlst=FALSE----------------------------
opts_knit$set(self.contained=FALSE)


## ----chapter8_RHRVEasy-prototype, eval=FALSE----------------------------------
## 
## #Prototype of the main RHRVEasy function.
## 
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


## ----chapter8_RHRVEasy-output, eval=FALSE-------------------------------------
## 
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


## ----chapter8_RHRVEasy-setup, eval=FALSE--------------------------------------
## 
## # Variables that contain the paths of the NSR_DB
## # and the CHF_DB databases.
## 
## basePath <- "RRData/"
## NSR_DB <- file.path(basePath, "normal")
## CHF_DB <- file.path(basePath, "chf")


## ----chapter8_RHRVEasy_NSR_CHF, eval=FALSE------------------------------------
## 
## # Analysis of the NSR_DB and the CHF_DB databases
## # using RHRVEasy.
## 
## easyAnalysis <- RHRVEasy(folders = c(NSR_DB, CHF_DB))


## ----chapter8_RHRVEasy_NSR_CHF_results, eval=FALSE----------------------------
## # The analysis results are displayed in the console,
## # including the first rows of the HRV indices,
## # and the statistical tests.
## 
## print(easyAnalysis)
## head(easyAnalysis$HRVIndices)
## head(easyAnalysis$stats)


## ----chapter8_RHRVEasy_NSR_CHF_results_wavelet, eval=FALSE--------------------
## 
## # Analysis of the NSR_DB and the CHF_DB databases using
## # the wavelet transform for frequency indices calculation.
## 
## easyAnalysisWavelet <- RHRVEasy(folders = c(NSR_DB, CHF_DB),
##                                 typeAnalysis = "wavelet")


## ----chapter8_RHRVEasy_NSR_CHF_results_excel, eval=FALSE----------------------
## 
## # When specifying a value for the argument saveHRVIndicesInPath,
## # an Excel file with the HRV indices is created at the path
## # specified by the argument
## 
## spreadsheetPath <- basePath
## easyAnalysis <- RHRVEasy(folders = c(NSR_DB, CHF_DB),
##                          saveHRVIndicesInPath = spreadsheetPath)


## ----chapter8_RHRVEasy_NSR_CHF_results_excel2, eval=FALSE---------------------
## 
## # The HRV indices contained in a RHRVEasy object called
## # easyAnalysis are saved in an Excel file at the specified path
## 
## saveHRVIndices(easyAnalysis,
##                saveHRVIndicesInPath = spreadsheetPath)
## 


## ----chapter8_RHRVEasy_NSR_CHF_results_fdr, eval=FALSE------------------------
## 
## #The false discovery rate ("fdr") method is employed
## #to adjust for significance level
## 
## easyAnalysisFDR <- RHRVEasy(folders = c(NSR_DB, CHF_DB),
##                             correctionMethod =  "fdr")
## print(easyAnalysisFDR)


## ----chapter8_RHRVEasy_NSR_CHF_results_fdr_bondf, eval=FALSE------------------
## 
## # The "fdr" correction method is applied over the p-values
## # contained in the object easyAnalysis, (which was created
## # using the "Bonferoni" correction)
## 
## easyAnalysisFDR <- RHRVEasyStats(easyAnalysis,
##                                  correctionMethod =  "fdr")
## pValues <- merge(
##   easyAnalysis$stats,
##   easyAnalysisFDR$stats,
##   by = setdiff(names(easyAnalysis$stats), "adj.p.value"),
##   suffixes = c(".bonf", ".fdr")
## )
## 
## # A comparison of the p-values without correction,
## # and applying both corrections is shown in the console
## print(
##   head(
##     pValues[, c("HRVIndex", "p.value",
##                 "adj.p.value.bonf", "adj.p.value.fdr")]
##   )
## )


## ----chapter8_chapter8_RHRVEasy-setup2, eval=FALSE----------------------------
## 
## # Variables that contain the paths of the NSR_HALF_DB
## # and the CHF_HALF_DB databases.
## 
## NSR_HALF_DB <- file.path(basePath, "normal_half")
## CHF_HALF_DB <- file.path(basePath, "chf_half")


## ----chapter8_RHRVEasy_multiple_goups, eval=FALSE-----------------------------
## # HRV analysis involving four different experimental groups
## easyAnalysis4 <-
##   RHRVEasy(folders = c(NSR_DB, CHF_DB,
##                        NSR_HALF_DB, CHF_HALF_DB))
## print(easyAnalysis4)


## ----chapter8_RHRVEasy_multiple_goups_results, eval=FALSE---------------------
## ## Significant differences in SDANN (Kruskal-Wallis rank
## ## sum test, bonferroni p-value = 1.942718e-08):
## ##   Significant differences in the post-hoc tests
## ## (Dunn's all-pairs test + bonferroni-p-value adjustment):
## ##       group1      group2   adj.p.value
## ##     1 normal      chf       0.00000297
## ##     2 normal      chf_half  0.00209
## ##     3 normal_half chf       0.0000845
## ##     4 normal_half chf_half  0.00557
## ##     ----------------------------------
## ##     chf's mean95% CI: (47.4665, 81.30389)
## ##               [Bootstrap CI without adjustment]
## ##     chf_half's mean95% CI: (36.01583, 82.96835)
## ##               [Bootstrap CI without adjustment]
## ##     normal's mean95% CI: (121.1845, 138.7499)
## ##               [Bootstrap CI without adjustment]
## ##     normal_half's mean95% CI: (116.6269, 150.1461)
## ##               [Bootstrap CI without adjustment]
## 


## ----chapter8_RHRVEasy_non_linear, eval=FALSE---------------------------------
## 
## # Analysis of the four databases calculating all
## # the non-linear indices
## 
## fullAnalysis <- RHRVEasy(
##   folders = c(NSR_DB, CHF_DB, NSR_HALF_DB, CHF_HALF_DB),
##   nonLinear = TRUE,
##   doRQA = TRUE,
## )
## print (fullAnalysis)


## ----chapter8_RHRVEasy_non_linear_parallel, eval=FALSE------------------------
## 
## #Parallelized analysis of the four databases
## #using 8 cores
## 
## fullAnalysis <- RHRVEasy(
##   folders = c(NSR_DB, CHF_DB, NSR_HALF_DB, CHF_HALF_DB),
##   nonLinear = TRUE,
##   doRQA = TRUE,
##   nJobs = 8
## )
## print(fullAnalysis)

