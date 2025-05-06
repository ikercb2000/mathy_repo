
# WHO’s reported novel disease outbreaks ----------------------------------

library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())

# 1. data
y <- c(3, 7, 4, 10, 11)

N <- length(y)

data_list <- list(
  N = N, 
  y = y,
  a = 3,
  b = 0.5)

# Stan
fit <- stan("/Users/ikercaballerobragagnini/Desktop/UPC/Bayesian Analysis/Codes/Session 10/stan_models/who.stan", iter = 5000, chains = 4,
  data = data_list, seed = 1)

# Diagnose
print(fit)


# 2. posterior predictive distribution
lambda <- extract(fit, "lambda")[[1]]
ggplot(tibble(lambda)) +
  geom_density(aes(lambda))

post_pred <- rpois(10000,lambda)
p <- ggplot(tibble(post_pred)) +
  geom_bar(aes(post_pred))
p


# 3. Compare samples with data (graphically)
p +
  geom_vline(xintercept = 3, col ="red", linetype = 2)  +
  geom_vline(xintercept = 11, col ="red", linetype = 2) 

# se coge el valor minimo y maximo de la muestra para ver por donde cawe en la muestra

# Calc probability at the left and right ends

mean(post_pred >= 11)
mean(post_pred <= 3)

# 4. better posterior predictive check 
lambda <- extract(fit, "lambda")[[1]]

# We can generate 10000 samples of size 5 (one for each lambda parameter)

y_sim <- matrix(NA,nrow=length(lambda),ncol=N) # to be more efficient

for (i in 1:length((lambda))){
  y_sim[i,] <- rpois(N,lambda[i])
}

head(y_sim) # if the model is correct, samples should be similar to the original obtained

# An option for the statistic is to consider whether maximum and minimum are above or below the ones
# in the original sample

indicator <- matrix(NA,nrow=length(lambda),ncol=1)

for (i in 1:length((lambda))){
  indicator[i,1] <- ifelse((min(y_sim[i, ])<=3)&(max(y_sim[i, ])>=11),1,0)
}

mean(indicator)

# 5. New data

mean(post_pred>=20) # el modelo no es adecuado a los datos


#' This is a test of out- of-sample predictive capability,
#' and so we would expect this p value to be more extreme than the within-sample one 
#' that we calculate below


# 6. Model update
y <- c(3, 7, 4, 10, 11, 20)

N <- length(y)

data_list <- list(
  N = N, 
  y = y,
  a = 3,
  b = 0.5)

# Stan
fit2 <- stan("/Users/ikercaballerobragagnini/Desktop/UPC/Bayesian Analysis/Codes/Session 10/stan_models/who.stan", iter = 5000, chains = 4,
  data = data_list, seed = 1)

# Diagnose
print(fit2)

lambda2 <- extract(fit2, "lambda")[[1]]
ggplot(tibble(lambda2)) +
  geom_density(aes(lambda2))

ggplot(tibble(lambda2)) +
  geom_density(aes(lambda2)) +
  geom_density(data = tibble(lambda), aes(lambda), col = "red")



# 7. PPC

# Simulate 10000 samples of 6 observations




#' This a within-sample measure of predictive capability of the model.




# By graph
str(y_sim)

n_cases <- 100
id <- sample(1:length(lambda2), n_cases)

df <- as.data.frame(t(y_sim[id, ]))
names(df) <- id
df$x <- 1:N
df$y <- y
df <- df %>% 
  gather("sample", "value", -c(x, y))

ggplot(df) +
  geom_line(aes(x, value, group = sample), col = "grey", alpha = 0.5) +
  geom_line(aes(x, y), col = "red")




# Discoveries -------------------------------------------------------------

# 1. Poisson model
# data
df <- read_csv(file = "data/evaluation_discoveries.csv")


ggplot(df) +
  geom_line(aes(time, discoveries))

N <- nrow(df)

data_list <- list(
  N = N, 
  x = df$discoveries)

# run the model using Stan
fit <- stan("stan_models/discoveries_generatedq.stan", iter = 1000, chains = 4,
  data = data_list, seed = 1)

print(fit)


# compare the maximum of your posterior predictive simulations with that of the 
# real data
pp_sim <- extract(fit, "x_sim")[[1]]
str(pp_sim)

pp_sim_max <- _______________

ggplot(tibble(pp_sim_max)) +
  geom_bar(aes(pp_sim_max)) +
  geom_vline(xintercept = 12, col ="red", linetype = 2)






# 2. negative binomial model
data_list <- list(
  N = N, 
  x = df$discoveries)

# run the model using Stan
fit <- stan("stan_models/discoveries_negbin_generatedq.stan", iter = 1000, chains = 4,
  data = data_list, seed = 1)

print(fit)


# compare the maximum of your posterior predictive simulations with that of the 
# real data
pp_sim <- extract(fit, "x_sim")[[1]]
str(pp_sim)

pp_sim_max <- _______________

ggplot(tibble(pp_sim_max)) +
  geom_bar(aes(pp_sim_max)) +
  geom_vline(xintercept = 12, col ="red", linetype = 2)

mean(pp_sim_max >= 12)






