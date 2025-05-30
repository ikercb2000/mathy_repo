
## ------------------------------------------------------------------------
library(ggplot2)
library(dplyr)

theme_set(theme_bw())

# 1. Statistical model

# Plot binomial distribution

sample <- rbinom(p=0.5, size=20, n=10000)
ggplot(tibble(sample))+
  geom_bar(aes(sample), fill="darkred",width = 0.2)

# Exercise 1.5

ggplot() +
  stat_function(fun = dpois, 
                args = list(lambda=1)) +
  xlim(c(0, 5))

# 3. Bayesian model

# Exercise coin

ggplot() +
  stat_function(fun = dbeta, 
                args = list(shape1 = 100, shape2 = 100)) +
  xlim(c(0, 1))

# Exercise world

ggplot() +
  stat_function(fun = dbeta, 
                args = list(shape1 = 7, shape2 = 3)) +
  xlim(c(0, 1))

## ------------------------------------------------------------------------

# 4. Likelihood function

# Exercise likelihood:

df <- tibble(
  omega = seq(0,1,0.01),
  likelihood = dbinom(12,20,omega))

ggplot(df)+
  geom_line(aes(omega,likelihood))

## ------------------------------------------------------------------------
## Predictive simulation

# Simulate 10000 draws from prior density: p_sim

p_sim <- rbeta(10000,200,200)

ggplot(tibble(p_sim))+
  geom_density(aes(p_sim))

# Simulate 10000 draws from the predictive density: y_sim

y_sim <- rbinom(10000,20,p_sim)

# Plot the prior predictive density

ggplot(tibble(y_sim))+
  geom_bar(aes(y_sim))

# Compute the probability of less than 5 tails

mean(y_sim<5)

# Find a 90 percent prediction interval for the number of tails

quantile(y_sim,c(0.05,0.95))

# Exercise 1.4

# a) Choose the parameters of a conjugate prior distribution (gamma), 
# and explain why you choose them (it might be useful to draw the 
# prior predictive distribution to back your choice up).



# b) Draw in the same graph the prior distribution and the 
# likelihood function.



# c) Draw the prior predictive distribution.



# Now, assume that the members of the association know nothing 
# about the number of weekly visitors:
# d) Choose the parameters of a conjugate prior distribution in 
# that case.

