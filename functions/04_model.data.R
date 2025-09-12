##'Turns an element of rdy.data into a format a stan model can process.
##' @param data an element of rdy.data.
##' @param priors the parameter estimates from the previous model run.
##' @param cycle_width the number of observations this function is given.
##' @param edibleData list, the processed output.

ingestData <- function(data,cycle_width,posterior){
  #Adds the streamflow, cycle width, and rainfall data to the model-edible list.
  edibleData <- list(N = cycle_width,
                     S = data[,2],
                     R = data[,3])
  
  #Adds the posterior estimates of model parameters as priors to the model-edible list.
  for(name in rownames(posterior)){
    edibleData[paste0(name,"_mu")] = as.numeric(posterior[name,1])
    edibleData[paste0(name,"_sd")] = as.numeric(posterior[name,2])
  }
  
  return(edibleData)
}