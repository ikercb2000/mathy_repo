data {
  int<lower=1> N; // Number of observations
  int<lower=1> p; // Number of covariates
  matrix[N,p] X;
  real y[N];
  real<lower=0> ppar;
}

parameters {
  // horseshoe
  real<lower=0> tau; // global scale
  vector<lower=0>[p] lambda; // local scale
  
  vector[p] beta;
  real<lower=0> sigma;
}

model {
  // horseshoe
  tau ~ cauchy(0, ppar*sigma/sqrt(1.0*N));
  lambda ~ cauchy(0,1);
  beta ~ normal(0, tau*lambda); // wide weakly-informative
  sigma ~ normal(0, 2);
  
  y ~ normal(X * beta, sigma);
}
