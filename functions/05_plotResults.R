##' This function produces various diagnostic plots as to model fit and sampling.
plotResults <- function(iterative = F,
                        results,
                        names,
                        data
                        ){
  #functionality for iterative models.
  if(iterative){
    #extracts model fit and observed values.
    fit <- list()
    obs <- list()
    for(i in 2:length(data)){
      fit[[i]] <- results[[i]]$y
      obs[[i]] <- data[[i]]$Streamflow.Ave
    }
    #plots the results.
    plot(obs[,1], type = "l")
    points(fit[,1], col = "blue")
    
  }
  #functionality for single cycle models.
  else{
    stan_trace(results, pars = names, inc_warmup = T)
    
    #histograms for convergence.
    stan_hist(results, pars = names)
    
    #density plots for convergence.
    stan_dens(results, pars = names, separate_chains = F, inc_warmup = F)
    
    #plot of the impulse response function
    curve(dgamma(x,mean(extract(results)$lambda),mean(extract(results)$eta)), 
          xlim = c(1,5),
          main = "Impulse response function",
          ylab = "Normalized gamma density",
          xlab = "Relative time step")
    
    #plots of the scaling coefficient, if present.
    tryCatch(expr = plot(colMeans(extract(results)$beta), 
                  type = "l",
                  main = "Scaling coefficient values",
                  ylab = "ß",
                  xlab = "Timestep"))

    #plots of observed vs. predicted values
    plot(data[,2], type = "l",
         main = "Observed streamflow (black) vs. predicted values (blue)",
         ylab = "Streamflow/L",
         xlab = "Timestep")
    points(colMeans(extract(results)$y), col = "blue")

    plot(colMeans(extract(results)$y)~data[,2],
                           main = "Fit Deviation",
         xlab = "Observed values",
         ylab = "Fitted values")
    abline(a = 0,
           b = 1,
           h = 4.076*3600*1000)
  }
}