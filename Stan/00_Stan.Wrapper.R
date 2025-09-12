##' This file is the wrapper from which all model components are called. Detailed descriptions of these components are found in their respective files. 
##' @Requirements Data is downloaded from Github, i.e. internet connection is needed to run this.
##' @Dependencies Data Preprocessing/01_Data.Import.R, Stan/01_Streamflow.model.stan
##' @Output This file only produces the posterior samples and writes them into a local file.

####Optionals####
setwd("C:/Users/jonat/Desktop/BIO3019S/Jasper Slingsby/BIO3019S-Streamflow-Project") #Set working directory to a local file.
rm(list=ls());cat("\014") #Clears environment and console.
#save.image("00_Stan.Wrapper.RData") #Saves environment image.
#load("00_Stan.Wrapper.RData") #Loads a saved environment image.

####Import data####
if(file.exists("Data Preprocessing/01_Data.Import.R")) source("Data Preprocessing/01_Data.Import.R") #calls a script to download data from Github

data <- dataChoice(resolution = "hourly",
                   timeframe = c("2023-01-01","2024-01-01"),
                   metadata = F)

####Initial values####
#Initial values for 4-chain model runs, designed to reduce burn-in.
# init <- list( #Recommended initial values when for model 01.
#   list(lambda = 100, eta = 100, sigma_obs = 150000),
#   list(lambda = 125, eta = 125, sigma_obs = 175000),
#   list(lambda = 150, eta = 150, sigma_obs = 200000),
#   list(lambda = 175, eta = 175, sigma_obs = 225000)
# )

####Compile and run the Stan model####
library(rstan)
set.seed(12345)

options(mc.cores = parallel::detectCores()) #parallelizes the the number of cores your computer has.

rstan_options(auto_write = T) #Avoids recompilation of unchanged Stan programs.
model <- stan_model('Stan/01.4_Streamflow.model.stan')

fit <- sampling(model,
                data = list(N=nrow(data), 
                            S = data[,2], 
                            R = data[,3]),
                control = list(adapt_delta = 0.99),
                iter = 6000,
                chains = 4)

####Extract the posterior samples and write them to the working directory in local storage####
saveRDS(fit, file = "Stan fits/01.4_fit.rds")

plotResults(results = fit, 
            names = c("lambda","sigma_obs","eta"),
            data = data)
