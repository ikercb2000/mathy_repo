data {
  int<lower=0> N;     // sample size
  int<lower=0> x[N];  //number of invention
  real a;
  real b;
}

parameters {
  real<lower=0> lambda;
}

model {
  x ~ poisson(lambda);  	// likelihood
  
  lambda ~ lognormal(a, b); // prior for lambda
}