data {
 int N; //discrete variable of sample size 
 real<lower=0> S[N]; //constrained continuous matrix of streamflow.
 real<lower=0> R[N]; //constrained continuous matrix for rainfall.
}

parameters { //currently just shape parameters for a gamma distribution
  real<lower=0> lambda;
  real<lower=0> eta;
}


model {
}
