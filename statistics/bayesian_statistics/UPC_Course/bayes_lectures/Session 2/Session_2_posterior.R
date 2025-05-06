
# Exercise 2.1 ------------------------------------------------------------

## ------------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(tidyr)

sepiaverda <- read.table("~/Downloads/sepiaverda.txt", quote="\"", comment.char="")

# a) Prior definition -----------------------------------------------------
set.seed(123456)

prior <- c(90, 4) # debido a que 40+5/2 = 22.5, que es la media de la disstribución
# y se ajusta para la variabilidad, es una heurística
l_sim <- rgamma(10000, shape = prior[1], rate = prior[2])
ggplot(tibble(l_sim), aes(l_sim)) +
  geom_density()

# Simulate 10000 draws from the predictive density: y_sim
y_sim <- rpois(10000, l_sim)

# Plot the prior predictive density

ggplot(tibble(y_sim), aes(y_sim)) +
  geom_bar()

# Se pasa a ffrecuencias relativas, aunque no es muy relevante

prior_pred_sim <- ggplot(tibble(y_sim), aes(y_sim)) +
  geom_bar(aes(y = (..count..)/sum(..count..)))
prior_pred_sim

# Compute the probability of less than 5 (para comprobar)
mean(y_sim < 5)

# Compute the probability of more than 40 (para comprobar)
mean(y_sim > 40)

# b) Likelihood calculation -----------------------------------------------

y <- c(21, 17, 17, 19, 16, 18, 15, 10, 17, 16)

delta_l <- 0.01

lambda <- seq(0, 60, delta_l)
likelihood <- map_dbl(lambda, ~ prod(dpois(y, .x)))
df <- tibble(lambda, likelihood)

# Likelihood graph
ggplot(df) +
  geom_line(aes(x = lambda, y = likelihood))

# Standardized likelihood
coef <- sum(likelihood)*delta_l
df$likelihood <- df$likelihood/ coef

# Prior + likelihood graph
ggplot(tibble(l_sim), aes(l_sim)) +
  geom_density(col="blue") +
  geom_line(data = df, 
            aes(x = lambda, y = likelihood), col="green")

# c) Draw the prior predictive distribution (conjugated) ------------------

x <- 0:60
prior <- c(____, ____)
pred <- dnbinom(x, prior[1], prior[2]/(1 + prior[2]))
df2 <- tibble(x, pred) 
ggplot(df2) +
  geom_bar(aes(x, pred), stat = "identity")



# d) Posterior calculation (conjugated) -----------------------------------

# Simulate 10000 draws from posterior density: l_post_sim
n <- length(y)

posterior <- c(_____, _____)
l_post_sim <- _____
ggplot(tibble(l_post_sim), aes(l_post_sim)) +
  geom_density()


# Simulate 10000 draws from the posterior predictive density: y_sim



# Plot the posterior predictive density




## d) Posterior calculation (revisited)

y <- c(21, 17, 17, 19, 16, 18, 15, 10, 17, 16)
delta_l <- 0.01

df <- tibble(
  lambda = seq(0, 60, delta_l),
  likelihood = map_dbl(lambda, ~ prod(dpois(y, .x))),
  prior = dgamma(____, shape = ____, rate = ____),
  product = ____,
  posterior = ____
)

#  Use ggplot() to create a figure with the prior, the likelihood and the posterior
# distributions





# e) Probability that the number of visitors next week will be lower than 10





# f) Draw the posterior predictive distribution ---------------------------





# g) For what option will you bet? ----------------------------------------





# h) Flat prior -----------------------------------------------------------


