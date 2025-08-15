library(rstan)

options(mc.cores = parallel::detectCores())

Y <- rnorm(10,1.5,0.2)

fit <- stan('simple.stan',iter=200,chains=4,
             data=list(Y=Y))

