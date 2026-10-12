### ------------------------------------------------------------------------ ###
## Preprocess data, write TAF data tables
### ------------------------------------------------------------------------ ###


## Before: bootstrap/data/bli_27_5b6712_BL_SurvCPUE_summer.csv
##         bootstrap/data/bli_27_5b6712_Catch_adviced_TAC_Landings.csv
##         bootstrap/data/bli_27_5b6712_dataLength_1984_2025.txt
## After: data/bli_27_5b6712_BL_SurvCPUE_summer.csv
##         data/bli_27_5b6712_Catch_adviced_TAC_Landings.csv
##         data/bli_27_5b6712_dataLength_1984_2025.txt


###--------------------------- Load packages -------------------------------------------
library("icesTAF")
library("tidyr")
library("dplyr")
library("glue")
library("cat3advice")


###--------------------------- Run bootstrap -------------------------------------------
#icesTAF::taf.bootstrap() Not working in 2026

taf.boot()
###--------------------------- create folder to store data -----------------------------
### create folder to store data
mkdir("data")


###--------------------------- set years -------------------------------------------
##DataYear: last year with data
DataYear <- 2025

##assessment_year: year of the working group
assessment_year <- 2026 


###--------------------------- Landings table -------------------------------------------
#Load table
table_summary_landings_TAC<-read.csv(file=glue("bootstrap/data/bli_27_5b6712_Catch_adviced_TAC_Landings.csv"),
                               header = TRUE, sep=";", dec = ".")

#Arrange data
bli_5bb6712_landings <- table_summary_landings_TAC %>%
                        select(Year, ICES_landings) %>%
                        rename(year=Year, catch=ICES_landings)
tail(bli_5bb6712_landings)

###--------------------------- Reference catch Ay -------------------------------------------
#The reference catch Ay is usually the most recently advised catch
#The ICES Technical Guidelines (ICES 2025b) specify that if the realised catch is very different from the
#advised catch, the reference catch could be replaced by an average of recent catches:
#In case of blue ling it is very different, so I will use the average
### use 3-year average
A <- A(bli_5bb6712_landings, units = "tonnes", basis = "average catch", avg_years = 3)
A


###--------------------------- Biomass index trend (ratio) r --------------------------------
## Load combined biomass index from CGFS et UK-BTS
biomass_index<-read.csv(file=glue("bootstrap/data/bli_27_5b6712_BL_SurvCPUE_summer.csv"),
                        header = TRUE, sep=",", dec = ".")
#Arrange data
biomass_index<-biomass_index %>%
                select("year", "stratified") %>%
                rename("index"="stratified")


###--------------------------- Length data  ---------------------------------------------------
## The fishing pressure proxy requires length data from the catch. Ideally, length data for several years are 
## provided in a data.frame with columns year, length and numbers. An additional column catch_category specifying 
## the catch category, such as discards and landings, is optional.

## Length table from ICES is available. This table is reviewed during the data prep meeting
## To avoid to load all the data, partly confidential, the data are arranged to select only interesting data for syt.27.67 
## and are available in the table below.
lgt<-read.csv(file=glue("bootstrap/data/bli_27_5b6712_dataLength_1984_{DataYear}.txt"), 
              header = TRUE, sep=";", dec = ".")

## Set column format
str(lgt)
lgt$year <- as.numeric(lgt$year)

## Select interesting columns for using the package cat3advice and
bli_length<- lgt %>%
              select(year = year, length = flength, numbers = number) %>%  ## Columns' name renamed according to the needs of R package cat3advice
              group_by(length, year) %>% 
              summarise(numbers = sum(numbers, na.rm = TRUE))