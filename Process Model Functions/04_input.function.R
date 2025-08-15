##' Function to compute the recharge for each time step, i.e. equation 4.
##' 
##' @param r_i array containing the rainfall of each time step.
##' @param s_i array containing the proportion of rainfall which becomes recharge each time step.
##' @return array containing the recharge for each time step.

input.function <- function(r_i,s_i){
  u_i <- r_i*s_i
  return(u_i)
}