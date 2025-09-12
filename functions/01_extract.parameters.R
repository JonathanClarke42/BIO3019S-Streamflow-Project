##' Extracts the mean and standard deviation of each parameter in a posterior sample.
##' Extracts the impulse response function from the posterior sample.
##' @param fit a stanfit object.
##' @param names list of the names of each parameter in the model, in any order.
##' @param outList a list of the mean and standard deviation of each parameter and the impulse response function.

extractParams <- function(fit,names){
  ###Extract parameter means and standard deviations###
  extr.params <- extract(fit, pars = names)                #extracts the parameter posterior samples from the stanfit object.
  params <- matrix(nrow = length(names), ncol = 2)         #initializes an empty matrix to hold parameters means and SD.
  rownames(params) <- names
  
  for(i in 1:length(names)){
    params[i,1] <- mean(extr.params[[i]])
    params[i,2] <- sd(extr.params[[i]])
  }
  ###Extract the mean impulse response function values###
  IRF <- colMeans(data.frame(extract(fit, pars = "IRF"))) #extracts the impulse response function values from the stanfit object, converts it to mean over each iteration.
          
  y <- colMeans(data.frame(extract(fit, pars = "y")))
  
  ####Returns the results####
  outList <- list(params = params,                        #constructs a list of each result calculated above.
                  IRF = IRF,
                  y = y)
  return(outList)
}