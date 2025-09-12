##' forecasts the streamflow values for rainfall measurements across a date range.
##' performs a sensitivity analysis to classify forecast performance.
##' @param data a n by 3 matrix of rainfall, streamflow, and dates for each observation.
##' @param IRF an array for mean and standard deviations for each model parameter, and the impulse response function.
##' @param predThreshold a floating point value of the probability of a flood event necessary to classify an event as a flood.
##' @param outArray an array of the predicted streamflow values for each time step, a confusion matrix for flood predictions, and prediction true skill statistic.

forecastFlow <- function(data,IRF,predThreshold){
  prediction <- list()
  ###Predict streamflow, using the fast Fourier transform###
  prediction[[1]] <- fft(fft(data[,3])*fft(IRF), inverse = T)      #transform the input and IRF, multiply them, then back-transform them.
  prediction[[1]] <- lapply(prediction,Re)                         #extract the real component of the prediction.
  
  return(prediction[[1]])
}