##' This script is used to detect changepoints in the data.
##' This script heavily uses the package Rbeast. Read more at https://github.com/zhaokg/Rbeast.
##' @Dependencies Data Preprocessing/01_Data.Import.R

####Load packages and Data####
if(file.exists("Data Preprocessing/01_Data.Import.R")) source("Data Preprocessing/01_Data.Import.R") #calls a script to download data from Github

#install.packages("Rbeast")
library(Rbeast)

####Basic analysis####
#Change point analysis without seasons.
out.none <- beast(streamflow, season = "none")
print(out.none)
plot(out.none)
