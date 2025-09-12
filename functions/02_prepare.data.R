##'Subsets the main dataset to produce a matrix of streamflow and rainfall values for each time step.
##' @param data a data frame containing a record of streamflow and rainfall values with dates.
##' @param cycle_width integer, the number of observations each cycle should model.
##' @param rdy.data n by 3 matrix of rain, flow, and dates for n observations.

prepData <- function(data,cycle_width){
  groupings_start <- seq(from = 1, to = nrow(data), by = cycle_width)            #defines the starting index of each data group.
  groupings_end <- seq(from = cycle_width, to = nrow(data), by = cycle_width)    #defines the terminal index of each data group.
  length(groupings_start) <- length(groupings_end)                               #ensures each grouping start has a corresponding end.
  
  rdy.data <- vector(mode = "list", length =  nrow(data)/cycle_width)            #initializes a list to hold each data group.
  
  for(i in 1:length(groupings_end)){                                             #subsets the main data frame by specified cycle width.
    rdy.data[[i]] <- data[c(groupings_start[i]:groupings_end[i]),]
  }

 return(rdy.data)
}