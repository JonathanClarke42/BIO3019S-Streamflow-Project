##'This file produces various plots to visualize model fit.
##' @Requirements a fitted stan model, either called from R's environment or saved to local storage.
##' @Requirements streamflow data obtained from Data Preprocessing/01_Data.Import.R

####Data Import####
setwd("C:/Users/jonat/Desktop/BIO3019S/Jasper Slingsby/BIO3019S-Streamflow-Project")
dat <- readRDS("Stan fits/01.4_fit.rds")
extracted <- extract(dat)

####ShinyStan and manual diagnostics####
library(shinystan)
launch_shinystan(dat)

#Diagnostics
#traceplots for mixing and convergence.
stan_trace(dat, c("lambda","eta","sigma_obs"),
           inc_warmup = T)

#histograms for convergence.
stan_hist(dat, c("lambda","eta","sigma_obs"))

#density plots for convergence.
stan_dens(dat, c("lambda","eta","sigma_obs"),
          separate_chains = F,
          inc_warmup = F)

####Model Fit####
#Plot the IRF
curve(dgamma(x,mean(extracted$lambda),mean(extracted$eta)), xlim = c(1,5))

#Predicted vs. Observed values
plot(streamflow, type = "l")
points(colMeans(extracted$y), col = "blue")
plot(colMeans(extracted$beta), type = "l")

#Sum of squares
sum_sq <- 0
for(i in 1:length(streamflow)){
  sum_sq <- sum_sq + (streamflow[i]-colMeans(extracted$y)[i])^2
}
print(sum_sq)

####Posterior Space####
#extract posterior samples
posterior_samples <- extract(dat, pars = c("lambda","eta","sigma_obs"))
samples_matrix <- cbind(posterior_samples$lambda, posterior_samples$eta, posterior_samples$sigma_obs)

#Compute 3d kernel density
library(ks)
kde <- kde(x = samples_matrix)

#Plot
library(plotly)
plot_ly(x = kde$estimate[[1]], 
        y = kde$estimate[[2]], 
        z = kde$estimate[[3]], 
        type = "scatter3d", 
        marker = list(size = 3, color = kde$estimate, colorscale = "Viridis"))
