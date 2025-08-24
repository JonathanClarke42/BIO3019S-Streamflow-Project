//check on save highlights syntax errors whenever you save the document.

//data we pass to stan
data {
  int N; //discrete variable sample size.
  real Y[N]; //array of continuous by discrete variables, i.e. the Y for each N.
}

//parameters of our model
parameters {
  real mu; //continuous, unconstrained variable.
  real<lower=0> sigma; //continuous, constrained variable (because sigma can't be negative)
}

//declare the likelihood and priors for our model.
model {
  for(i in 1:N)
    Y[i] ~ normal(mu,sigma); //definition of the likelihood
  
  //priors
  mu ~ normal(1.7,0.3);
  sigma ~ cauchy(0,1);
} 
