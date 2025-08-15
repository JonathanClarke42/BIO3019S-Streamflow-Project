data {
  real Y[10]; //an array of 10 elements, each an unbounded continuous variable
}

parameters {
  real mu; //unbounded continuous variable
  real <lower=0> sigma; //bounded continuous variable
}

model {
  for (i in 1:10){
    Y[i] ~ normal(mu,sigma); //sampling statement, based on our assumption of where Y is drawn from
  }
  mu ~ normal(1.5,0.1); // prior for mu
  sigma ~ gamma(1,1); // prior for sigma
}