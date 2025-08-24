##'visaulize the datasets to identify observations which should be discarded according to "rule of thumb." This discardings are implemented in 01_Data.Import.R
##' Download Appropriate Datasets loads the data in from Github.
##' Visualize Data visualizes the data.
##' @Dependencies this file has no dependent code.

setwd("C://Users//jonat/Desktop//BIO3019S//Jasper Slingsby/BIO3019S-Streamflow-Project")

####Download Appropriate Datasets####
if(file.exists("Data Preprocessing/01_Data.Import.R")) source("Data Preprocessing/01_Data.Import.R")

plot(dat.daily_ly.fr$Streamflow.Ave,type = "l")
plot(dat.daily_ly.fr$Rainfall.Total, type = "l")