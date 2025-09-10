##'wrapper script to run iterative forecast cycles.
##' @dependencies functions/01;02;03
##' @dependencies Data Preprocessing/01
##' @dependencies ssome compatible stan model.
####clean Workspace####
setwd("C:/Users/jonat/Desktop/BIO3019S/Jasper Slingsby/BIO3019S-Streamflow-Project") #set working directory to a local file.
rm(list=ls());cat("\014")                                                            #clears environment and console.
set.seed(1234)                                                                       #set seed for replicability.         
library(rstan)                                                                       #load required packages.

#Add container functionality here?#

####User choices####
model <- stan_model("Stan/01.3_Streamflow.model.stan")                       #stan file path, model choice.
names <- c("eta","lambda","sigma_obs")                                       #list of strings, names of the variables in the parameter block (not transformed parameters) in any order.
cycle_width <- 7                                                             #numeric, how many observations each forecast cycle will handle.
predThreshold <- NULL                                                        #floating point, some threshold literage of what to classify as a flood.


####load data, functions####
if(file.exists("Data Preprocessing/01_Data.Import.R")) source("Data Preprocessing/01_Data.Import.R") #calls a script to download data from Github
if(file.exists("functions/01_extract.parameters.R")) source("functions/01_extract.parameters.R")     #initializes a function to extract elements of the posterior sample.
if(file.exists("functions/02_prepare.data.R")) source("functions/02_prepare.data.R")                 #initializes a function to subset the data for the forecast cycle.
if(file.exists("functions/03_forecast.flow.R")) source("functions/03_forecast.flow.R")               #initializes a function to make forecasts, evaluate success.
if(file.exists("functions/04_model.data.R")) source("functions/04_model.data.R")                     #initializes a function to convert data from the rdy.data object into a structure a stan model can ingest.

####model setup####
options(mc.cores = parallel::detectCores()) #parallelizes to all available cores.
rstan_options(auto_write = T)               #Avoids recompilation of unchanged Stan programs.
nIter <- NULL                               #some function to work out how many forecast cycles to do.
predictions <- NULL                         #some matrix to hold predicted values.

rdy.data <- prepData(data,nIter,cycle_width)    #prepares the data for the forecast and current cycle.

fit <- sampling(model,                          #runs the first model to generate a posterior for the forecast cycle.
                data = NULL,                    #some data and priors for the first model run.
                control = list(adapt_delta = 0.95),
                init = init,
                iter = 4000,
                chains = parallel::detectCores()) #this chain statement might be dangerous you are using a server.

####initiates the forecast cycle####
for (iter in rdy.data){
  #extract the priors, IRF, and suggested initial values from the previous cycle
  past <- extractParams(fit,names)
  
  #forecast based on current rain
  predictions[[iter]] <- forecastFlow(rdy.data[[i]],past[[2]],predThreshold)

  
  #model the present data
  fit <- sampling(model,                      
                  data = ingestData(rdy.data[[i]],cycle_width,past[[1]]),
                  control = list(adapt_delta = 0.95),
                  init = init,
                  iter = 4000,
                  chains = parallel::detectCores())
}