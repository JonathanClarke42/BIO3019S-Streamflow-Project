setwd("C:/Users/jonat/Desktop/BIO3019S/Jasper Slingsby/BIO3019S-Streamflow-Project")

#generate fake data
set.seed(12345)
N <- 100
Y <- rnorm(N,1.6,0.2)

#compile the model
library(rstan)

model <- stan_model('Stan/simple.stan.test.stan')

#pass the data to stan and run the model
options(mc.cores = 4) #tells R how many cores to parallelize to.
#pass in the model and each variable you named in the model's data block.
#by defualt, stan uses half the number of iterations for burnin.
#Returns the samples.
fit <- sampling(model, list(N = N, Y = Y), iter=200, chains=4) 

#diagnose fit.
print(fit) #basic statistics on convergence and effective sample size.

params <- extract(fit) #extract parameter posterior samples to graph.
hist(params$mu)
hist(params$sigma)

library(shinystan)
launch_shinystan(fit)
