//This model uses a normalized negaative binomial probability density function as the model IRF.
data {
 int N;                    //discrete variable of sample size 
 real<lower=0> S[N];       //matrix of streamflow for each time step.
 real<lower=0> R[N];       //matrix for rainfall for each time step.
 real<lower=0> p[N];       //matrix proportion of rainfall which enters the watershed for each time step.
}

parameters {  
  //shape parameters for the gamma distribution. Lower bound set to avoid floating-point issues near zero during initialization.
  real<lower=0.0001> lambda;     
  real<lower=0.0001> eta;
  //the standard deviation of measurements, i.e. measurement error.
  real<lower=0> sigma_obs;  
}

transformed parameters{
  //IRF calculates are performed in log-space to maintain numerical stability by preventing values underflowing to zero.
  //calculate the unnormalized impulse response function values for each time step.
  real log_IRF_unnormalized[N];
    for(i in 1:N){
      log_IRF_unnormalized[i] = exp(neg_binomial_lpmf(i|lambda,eta));
    }
  
  //calculate the normalization constant.
  real log_sum_IRF;
    log_sum_IRF = log_sum_exp(log_IRF_unnormalized);
  
  //calculate the normalized IRF values for each time step.
  real log_IRF[N];
    for(i in 1:N){
      log_IRF[i] = log_IRF_unnormalized[i] - log_sum_IRF;
    }
  
  //Calculate the predicted streamflow for each time step using the convolution.
  real y[N];
    for(i in 1:N){
      y[i] = 0.0; //initialize to zero.
      for(j in 1:i){
        y[i] += exp(log_IRF[i-j+1])*R[j];
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
