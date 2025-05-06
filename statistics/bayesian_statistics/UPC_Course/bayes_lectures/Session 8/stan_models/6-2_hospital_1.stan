data{ 
  int N;
  int y[N];
  int n[N];
  real a;
  real b;
}

parameters{
  real<lower=0, upper=1> p; // mean height in population
}

model{
  for(i in 1:N){
    y[i] ~ binomial(n[i],p);
  }
  // y ~ binomial(n,p)
  
  p ~ beta(a,b);
  
}