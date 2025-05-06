data{ 
  int N;
  int y[N];
  int n[N];
  real a1;
  real b1;
  real a2;
  real b2;
}

parameters{
  real<lower=0, upper=1> p[N]; // mean height in population
  real<lower=0> a;
  real<lower=0> b;
}

model{
  for(i in 1:N){
    y[i] ~ binomial(n[i],p[i]);
    p[i] ~ beta(a,b);
  }
  
  a ~ gamma(a1,a2);
  b ~ gamma(b1,b2);
}