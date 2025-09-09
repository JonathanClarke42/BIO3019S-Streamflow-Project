//This model is a more efficient version of 01. This is done by vectorizing some loops, and applying the fast fourier transform to the convolution.
data {
 int N;                    //discrete variable of sample size 
 real<lower=0> S[N];       //matrix of streamflow for each time step.
 vector<lower=0>[N] R;       //matrix for rainfall for each time step.
 real<lower=0> p[N];       //matrix proportion of rainfall which enters the watershed for each time step.
}

parameters {  
  real<lower=0> lambda;     
  real<lower=0> eta;
  //the standard deviation of measurements, i.e. measurement error.
  real<lower=0> sigma_obs; 
}

transformed parameters{
  //Some calculations are performed in log space for numerical stability.
  //The fast Fourier transform is used to avoid having a costly nested loop.
  //calculate the unnormalized impulse response function values for each time step.
  vector[N] log_IRF_unnormalized;
    for(i in 1:N){
      log_IRF_unnormalized[i] = exp(gamma_lpdf(i|lambda,eta));
    }
    
  //calculate the normalization constant.
  real log_sum_IRF = log_sum_exp(log_IRF_unnormalized);
  
  //calculate the normalized IRF values for each time step.
  vector[N] IRF = exp(log_IRF_unnormalized - log_sum_IRF);
  
  //Perform the convolution in the frequency domain using the fast Fourier transform.
  complex_vector[N] inv_fft_product = inv_fft(elt_multiply(fft(IRF),fft(R)));
  
  //Initialise a vector to store the predicted streamflow values.
  vector[N] y;
  
  //Extract the real component of the inverse transform to y.
  for(i in 1:N){
    y[i] = get_real(inv_fft_product[i]);
  }
}

model {
  //priors
  sigma_obs ~ normal(475162.5,393.9);
  lambda ~ normal(127.3,2.2);
  eta ~ normal(127.3,2.3);

  //likelihood.
  S ~ normal(y, sigma_obs);
}
