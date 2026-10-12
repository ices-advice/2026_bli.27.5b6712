### ------------------------------------------------------------------------ ###
### Apply rfb rule ####
### ------------------------------------------------------------------------ ###

## Before: data/bli_27_5b6712_BL_SurvCPUE_summer.csv
##         data/bli_27_5b6712_dataLength_1984_2025.txt

## After:  model/advice.rds

###--------------------------- Load packages -------------------------------------------
library ("tidyverse")
library("here")
library("glue")
library("icesVocab")
library("icesTAF")
library("cat3advice")

###--------------------------- Create folder -------------------------------------------
mkdir("model")

###--------------------------- set years -------------------------------------------
##DataYear: last year with data
DataYear <- 2025

##assessment_year: year of the working group
assessment_year <- 2026 


###--------------------------- Biomass index trend (ratio) r --------------------------------
## Calculate biomass trend
r <- r(biomass_index)
r

###--------------------------- Biomass safeguard b --------------------------------------------
## Use previous dataset with data of combined biomass index.
## Itrigger should only be defined once in the first year of the application of the rfb rule. (in 2026)
## In the following years, the same value should be used.
b<-b(biomass_index, yr_ref= 2002) ##2002 is the year with the lowest value defined also during the first application of the rfb-rule (2026)


###--------------------------- Fishing pressure proxy F ----------------------------------------
## Catch length data are used to approximate the fishing pressure. 
## The mean length of fish in the catch compared to a reference length is used as the indicator.

###---------------------------
############## Length at first capture Lc  
### Only length data above the length at first capture Lc are used to avoid noisy data from fish that are not fully selected. Lc is defined as the first length class
## where the abundance is at or above 50% of the mode of the length distribution and can be calculated with the function Lc().
# Lc can change from year to year. Therefore, it is recommended to pool data from several (e.g. 5) years. 

#Length at first capture (Lc) was calculated by pooling length data from the international commercial landings 
#from the five last years (2021-2025) which seems to represent well LC over the time
#The effect on the estimated mode and length at first capture (Lc) of the bin width used for the length distribution was explored 
#for bins of 1, 2 and 5 cm. WGDEEP decided to use 2 cm length bins, which smoothed properly the length distribution
#A Lc of 78 cm was defined in 2026 corresponding to a 1 cm bin or a bin of 2cm --> 2 cm bin was selected
# code 14-bli.27.5b6712_Length_Distribution_Formatted_Years_pooled.r
lc <-Lc(60)

###---------------------------
############## Mean length 
#After defining Lc , the mean (annual) catch length Lmean above Lc can be calculated.
lmean_bli<-Lmean(data = bli_length, 
                 Lc =lc, units ="cm")
lmean_bli

###---------------------------
############## Reference length
## The reference length follows the concepts of Beverton and Holt (1957) and is calculated as derived by Jardim, Azevedo, and Brites (2015).
## This simple equation assumes that fishing at F=M can be used as a proxy for MSY and that M/k=1.5 (where M is the natural mortality and k the von Bertalanffy individual growth rate).
#The reference LF=M (MSY reference length) length should only be defined once in the first year of the application of the rfb rule.In the following years, the same value 
#should be used.

#Defined in 2026. Linf based on Ehrich and Reinsch, 1985
#Once defined, lref should be kept constant and the same value used for all data years. 
lref <- Lref(Lc = 78, Linf = 125, units = "cm")
lref


###---------------------------
############## Indicator ##############

##---------
##Fishing pressure
f <- f(Lmean = lmean_bli, Lref = lref, units = "cm")
f


###--------------------------- multiplier m -------------------------------------------
## The multiplier is a tuning parameter and ensures that the catch advice is precautionary in the long term.
## The value of m is set depending on the von Bertalanffy parameter k (individual growth rate)
## Here k= 0.152, so m= 0.95

#Keep multiplier from previous year
m <- m(hcr = "rfb", k = 0.152)
rfb_m(k = 0.152)
m


###--------------------------- Application of the rfb rule -----------------------------
advice <- rfb(A = A, r = r, f = f, b = b, m = m)
advice(advice)

### ------------------------------------------------------------------------ ###
### save output ####
### ------------------------------------------------------------------------ ###
saveRDS(advice, file = "model/advice.rds")