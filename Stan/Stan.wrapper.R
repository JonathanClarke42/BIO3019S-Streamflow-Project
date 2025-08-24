##' This file is the wrapper from which all model components are called. Detailed descriptions of these components are found in their respective files. 
##' @Requirements Data is downloaded from Github, i.e. internet connection is needed to run this.
##' @Output This file only produces the posterior samples and writes them into a local file.

setwd("C:/Users/jonat/Desktop/BIO3019S/Jasper Slingsby/BIO3019S-Streamflow-Project")

####Import data####
if(file.exists("Data Preprocessing/01_Data.Import.R")) source("Data Preprocessing/01_Data.Import.R") #downloads data from Github

####Compile and run the Stan model####
library(rstan)

options(mc.cores = 4)
model <- stan_model('Stan/Streamflow.model.stan')
fit <- sampling(model,
                list(N=N, S = streamflow, R = rainfall),
                iter = 10, chains = 4)

####Extract the posterior samples and write them to the working directory in local storage####
params <- extract(fit)
file.path <- "Streamflow.posterior.samples"
write.csv(params, file = file.path)

