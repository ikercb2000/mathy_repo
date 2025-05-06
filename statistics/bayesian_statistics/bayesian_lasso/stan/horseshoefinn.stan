data {
  int<lower=1> N; // Number of observations
  int<lower=1> p; // Number of covariates
  matrix[N,p] X;
  real y[N];
  real<lower=0> ppar;
  
  // Validation
  int<lower=1> Nval;
  matrix[Nval,p] Xval;
}

// constants and transformations we perform inside the model
transformed data{
  real s = 3; // scale for larger slopes
  real v = 25; // effective df for larger slopes
  
  real s2 = square(2);
  real v_2 = 0.5 * v;
}

parameters {
  // finnish horseshoe
  real<lower=0> tau; // global scale
  vector<lower=0>[p] lambda; // local scale
  real<lower=0> c2; 
  
  vector[p] beta;
  real<lower=0> sigma;
}

// transformation on the parameter lambda
transformed parameters {
  vector[p] lambda_tilde = sqrt(c2 * square(lambda) ./ (c2 + square(tau) * square(lambda)));
}


model {
  // horseshoe
  tau ~ cauchy(0, ppar*sigma/sqrt(1.0*N));
  lambda ~ cauchy(0,1);
  c2 ~ inv_gamma(v_2, v_2*s2);
  beta ~ normal(0, tau*lambda_tilde); // wide weakly-informative
  sigma ~ normal(0, 2);
  
  y ~ normal(X * beta, sigma);
}

generated quantities{
  real yval[Nval];
  yval = normal_rng(Xval * beta, sigma);
}