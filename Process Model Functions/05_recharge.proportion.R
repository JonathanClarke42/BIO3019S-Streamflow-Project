##' Function to calculate the proportion of rainfall which becomes recharge during each time step, i.e. equation 5.
##' 
##' @param c unitless scaling coefficient.
##' @param r_i an array containing the rainfall during each time-step.
##' @param k_i an array containing the effects of antecedent rainfal (adjusted for temperature) for each time-step.
##' @param s_i an array containg the proportion of rainfall which becomes recharge for each time step.
##' @return an array with the value of s for each time step.

compute.s_i <- function(c,r_i,k_i,s_i){
  return(s_i)
}