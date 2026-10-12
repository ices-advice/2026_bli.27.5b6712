### ------------------------------------------------------------------------ ###
### Prepare fishing pressure tables for SAG
### ------------------------------------------------------------------------ ###

## Before: model/advice.rds
## After:  output/bli.27.5b67_df_lenght_based_Fishing_Pressure.rds
##         output/output/bli.27.5b67_df_inverse_f.rds

###--------------------------- Load packages -------------------------------------------
library ("tidyverse")
library("here")
library("glue")
library("icesVocab")
library("cat3advice")

###--------------------------- Create folder -------------------------------------------
mkdir("output")


###--------------------------- Load advice -------------------------------------------
advice <- readRDS("model/advice.rds")


###--------------------------- Create fishing pressure table --------------------------------------------------
##Calcul f (Lmean/LF=M) --> Length-based fishing pressure proxy 
advice@f@indicator$indicator
lenght_based_Fishing_Pressure <- advice@f@indicator$indicator
lenght_based_Fishing_Pressure
lenght_based_Fishing_Pressure <- data.frame(Year = seq(1984,2025), #NEED UPDATE 
                                            lenght_based_Fishing_Pressure = lenght_based_Fishing_Pressure) 

print(lenght_based_Fishing_Pressure)

##Save a RDS for SAG 
saveRDS(lenght_based_Fishing_Pressure, 
        glue("output/bli.27.5b67_df_lenght_based_Fishing_Pressure.rds"))

#Calcul inverse F
advice@f@indicator$inverse_indicator

inverse_f<-1/(advice@f@indicator$indicator)
inverse_f
df_inverse_f <- data.frame(Year = seq(1984, 2025), #NEED UPDATE 
                           inverse_f = inverse_f)

print(df_inverse_f)

##Save a RDS for SAG 
saveRDS(df_inverse_f,
        glue("output/bli.27.5b67_df_inverse_f.rds"))