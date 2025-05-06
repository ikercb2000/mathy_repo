data{
   int N;
   int X[N];
   real mu_prior;
   real <lower=0> sigma_prior;
}

parameters{
   real<lower=0> lambda;
}

model{
   X ~ poisson(lambda);
   lambda ~ lognormal(mu_prior,sigma_prior);
}

generated_quantities{
   int<lower=0> x_sim[N];
   for(i in 1:N){
      x_sim[i]=...
   }
}
