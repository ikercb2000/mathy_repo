data {
  int<lower=1> N; // Number of observations
  int<lower=1> p; // Number of covariates
  matrix[N,p] X;
  real y[N];
}

parameters {
  vector[p] beta;
  real<lower=0> sigma;
}

model {
  beta ~ double_exponential(0,41.6); // non-local sparsity
  sigma ~ normal(0, 2);
  
  y ~ normal(X * beta, sigma);
}
