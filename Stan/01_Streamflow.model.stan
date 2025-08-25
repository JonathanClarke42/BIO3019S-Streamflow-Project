data {
 int N;                    //discrete variable of sample size 
 real<lower=0> S[N];       //matrix of streamflow for each time step.
 real<lower=0> R[N];       //matrix for rainfall for each time step.
 real<lower=0> p[N];       //matrix proportion of rainfall which enters the watershed for each time step.
}

parameters {                
  real<lower=0> lambda;     // shape parameters for a gamma distribution
  real<lower=0> eta;        // shape parameters for a gamma distribution
  real<lower=0> sigma_obs;  //the standard deviation of measurements, i.e. measurement error.
}

transformed parameters{
  real IRF[N];
    for(i in 1:N){
      IRF[i] = exp(gamma_lpdf(i|lambda,eta));
    }
  real y[N];
    for(i in 1:N){
      for(j in 1:i){
        y[i] += IRF[i-j+1]*R[j];
      }
    }
}

model {
  //priors
  sigma_obs ~ normal(1,1);
  lambda ~ normal(1,1);
  eta ~ normal(1,1);

  //likelihood
  for(i in 1:N){
    S[i] ~ normal(y[i], sigma_obs);
  }          
}
