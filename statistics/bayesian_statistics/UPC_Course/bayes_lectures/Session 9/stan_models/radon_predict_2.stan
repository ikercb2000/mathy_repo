data {
  int<lower=0> N;
  int<lower=0> J;
  vector[N] y;
  int<lower=0,upper=1> x[N];
  int county[N];
  vector[J] u;
}
parameters {
  real a[J];
  real b;
  real g_0;
  real g_1;
  real<lower=0> sigma_y;
  real<lower=0> sigma_a;
}
model {
  for (j in 1:J)
    a[j] ~ normal(g_0 + g_1 * u[j], sigma_a);
  for (n in 1:N)
    y[n] ~ normal(a[county[n]] + b * x[n], sigma_y);
}  
generated quantities {
  real u_tilde;
  real a_tilde;
  real y_tilde;
  u_tilde = mean(u);
  a_tilde = normal_rng(g_0 + g_1 * u_tilde, sigma_a);
  y_tilde = normal_rng(a_tilde + b * 1, sigma_y);
}