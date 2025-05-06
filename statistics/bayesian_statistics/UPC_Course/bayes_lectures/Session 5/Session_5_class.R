# Session 5

# Exercise: discoveries ---------------------------------------------------

# a, b, c) discoveries.stan model

# d)
library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())
setwd("/Users/ikercaballerobragagnini/Downloads/Session_5")
# e) data
df <- read_csv(file = "/Users/ikercaballerobragagnini/Downloads/Session_5/data/evaluation_discoveries.csv")

N <- nrow(df)

# Aqui se tienen que poner los nombres de los parámetros que se utilizarán en stan

data_list <- list(
  N = N,
  X = df$discoveries,
  mu_prior=2,
  sigma_prior=1
  )

# f) run the model using Stan

fit <- stan("/Users/ikercaballerobragagnini/Downloads/Session_5/stan_models/model1.stan",iter = 1000, chains = 4,
            data = data_list, seed=1)

# g) diagnose whether your model has converged by printing `fit`

print(fit)

# h) equivalent number of samples

# i) central posterior 80% credible interval for lambda
## Option 1: 
print(fit, pars = "lambda",probs=c(0.1,0.9)) # 0.9-0.1=0.8
## Option 2: extract lambda from the fit object
lambda = extract(fit,"lambda")[[1]]
quantile(lambda,c(0.1,0.9))
ggplot(tibble(lambda))+
  geom_density(aes(lambda))

# j) histogram of the lambda posterior sample

ggplot(tibble(lambda))+
  geom_histogram(aes(lambda))

# k) graph the data

ggplot(df)+
  geom_line(aes(time,discoveries),col="blue")

ggplot(df)+
  geom_histogram(aes(discoveries),fill="blue",col="lightblue")

acf(df$discoveries)

# l) posterior predictive

# Option 1: in R

lambda
post_pred <- map(lambda, ~ rpois(N,.x))

y_post_sim <-rpois(100000,lambda)

ggplot(df)+
  geom_line(aes(time,discoveries),col="blue")+
  geom_line(data=tibble(time=df$time,x=post_pred),col="red")

# Option 2: generated_quantities (modify the Stan file)



# m) negative binomial model.extract









# Exercise: hungover holiday regressions ----------------------------------

# a, b) data


# c) interpretation

# d) stan model

# Read the data


# Define data list


# Run model


# Analyze results