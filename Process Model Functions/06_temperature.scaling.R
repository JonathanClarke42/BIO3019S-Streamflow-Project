##' Function to compute the values k_i, used in equation 5, according to equation 6.
##' 
##' @param alpha unitless scaling coefficient.
##' @param T_i an array containing the temperatures measured during each time step.
##' @param f a temperature modulation factor.
##' @return an array with the value of k for each time step.


compute.k_i <- function(alpha,T_i,f){
  k_i <- alpha*exp((20-T_i)*f)
  return(k_i)
}