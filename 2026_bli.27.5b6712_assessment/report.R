### ------------------------------------------------------------------------ ###
### Prepare plots and tables for report ####
### ------------------------------------------------------------------------ ###


## Before: model/advice.rds
## After:  figures in report/figures
##         tables in report/tables


###--------------------------- Load packages -------------------------------------------
library ("tidyverse")
library("here")
library("glue")
library("icesVocab")
library("icesTAF")
library("cat3advice")


###--------------------------- Create folder -------------------------------------------
mkdir("report")
mkdir("report/figures")
mkdir("report/tables")


###--------------------------- Load advice -------------------------------------------
advice <- readRDS("model/advice.rds")


###--------------------------- rfb rule - figures ------------------------------------
### A - reference catch
### no figures


### r - biomass index trend/ratio 
plot(advice@r)
ggsave("report/figures/rfb_r.png", width = 10, height = 6, units = "cm",
       dpi = 300, type = "cairo")

### b - biomass safeguard
plot(advice@b)
ggsave("report/figures/rfb_b.png", width = 10, height = 6, units = "cm",
       dpi = 300, type = "cairo")

### b & r
plot(advice@r, advice@b)
ggsave("report/figures/rfb_rb.png", width = 10, height = 6, units = "cm",
       dpi = 300, type = "cairo")


### f - annual length distributions
plot(advice@f@Lmean)
ggsave("report/figures/rfb_Lmean.png", width = 15, height = 10, units = "cm",
       dpi = 300, type = "cairo")

### f - length indicator
plot(advice@f)
ggsave("report/figures/rfb_f.png", width = 10, height = 6, units = "cm",
       dpi = 300, type = "cairo")


###--------------------------- rfb rule - advice table ------------------------------------
### create ICES advice style table
### numbers are rounded following ICES rounding rules

### print to screen
advice(advice)

capture.output(advice(advice), file = "report/tables/advice_table.txt")