data {
  int n;
  vector[n] y;
}

parameters {
  real<lower = -1, upper = 1> a;
  real<lower = 0> sigma;
}

model {
  y[1] ~ normal(0, sigma);
  for (i in 2:n)
    y[i] ~ normal(a * y[i-1], sigma);
}


