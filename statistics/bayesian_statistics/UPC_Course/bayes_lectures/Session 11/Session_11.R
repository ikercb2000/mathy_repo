library(rstan)


# Generative model - time series ------------------------------------------

# Generative model
n <- 100
a <- -0.9

sigma <- 0.3

y <- rep(0, n)
y[1] <- rnorm(1, 0, 1)
for (i in 2:n)
  y[i] <- rnorm(1, a * y[i-1], sigma)

df <- tibble(
  x = 1:length(y), 
  y = y
)

# Plot data
ggplot(df) +
  geom_point(aes(x, y)) +
  geom_line(aes(x, y))

# Stan model
stan_data <- list(
  n = n, 
  y = y
)

fit <- stan("stan_models/ts_0.stan", data = stan_data, chains = 1, 
            iter = 5000, warmup = 2000, thin = 10)

print(fit)






# GLMs --------------------------------------------------------------------

library(tidyverse)

theme_set(theme_bw())


icecream <- data.frame(
  # http://www.statcrunch.com/5.0/viewreport.php?reportid=34965&groupid=1848
  temp=c(11.9, 14.2, 15.2, 16.4, 17.2, 18.1, 
         18.5, 19.4, 22.1, 22.6, 23.4, 25.1),
  units=c(185L, 215L, 332L, 325L, 408L, 421L, 
          406L, 412L, 522L, 445L, 544L, 614L)
)

ggplot(icecream) +
  geom_point(aes(temp, units), shape = 1) +
  xlab("Temperatur (Celsius)") +
  ylab("Units sold")


#' Linear regression:
#' 
#' y_i ~ Normal(mu_i, sigma)
#' E[y_i] = mu_i = alpha + beta * x_i
lin.mod <- glm(units ~ temp, data=icecream, 
               family=gaussian(link="identity"))
summary(lin.mod)


#' Log-transformed linear regression:
#' 
#' log(y_i) ~ Normal(mu_i, sigma)
#' E[log(y_i)] = mu_i = alpha + beta * x_i
#' 
#' y_i ~ logNormal(mu_i, sigma)
#' E[y_i] = exp(mu_i + sigma^2 / 2)

log.lin.mod <- glm(log(units) ~ temp, data=icecream, family=gaussian(link="identity"))
summary(log.lin.mod)

log.lin.sig <- summary(log.lin.mod)$dispersion
icecream$log.lin.pred <- exp(predict(log.lin.mod) + log.lin.sig / 2)

ggplot(icecream) +
  geom_point(aes(temp, units), shape = 1) +
  xlab("Temperatur (Celsius)") +
  ylab("Units sold") + 
  geom_line(aes(temp, log.lin.pred))


#' Poisson regression:
#' 
#' y_i ~ Poisson(mu_i)
#' log(mu_i) = alpha + beta * x_i
#' 
#' E[y_i] = exp(alpha + beta * x_i)
pois.mod <- glm(units ~ temp, data=icecream, 
                family=poisson(link="log"))
summary(pois.mod)

icecream$pois.pred <- predict(pois.mod, type="response")
ggplot(icecream) +
  geom_point(aes(temp, units), shape = 1) +
  xlab("Temperatur (Celsius)") +
  ylab("Units sold") + 
  geom_line(aes(temp, pois.pred))



# brms --------------------------------------------------------------------

#  response | addition ~ fixed + (random | group)

#' Families: 
#' gaussian, student, cauchy, binomial, bernoulli, beta, categorical, poisson, 
#' negbinomial, geometric, gamma, inverse.gaussian, exponential, weibull, 
#' cumulative, cratio, sratio, acat, hurdle_poisson, hurdle_negbinomial, 
#' hurdle_gamma, zero_inflated_poisson, and zero_inflated_negbinomial

#' Reference: https://www.r-bloggers.com/bayesian-regression-models-using-stan-in-r/

temp <- icecream$temp
units <- icecream$units
log_units <- log(units)
n <- length(units)
market.size <- rep(800, n)


library(brms)

# Linear Gaussian model
lin.mod <- brm(units ~ temp, family="gaussian")

# Log-transformed Linear Gaussian model
log.lin.mod <- brm(log_units ~ temp, family="gaussian")

# Poisson model
pois.mod <- brm(units ~ temp, family="poisson")

# Binomial model
bin.mod <- brm(units | trials(market.size) ~ temp, family="binomial")



plot(log.lin.mod)


# Prediction credible interval
modelData <- data.frame(
  Model=factor(c(rep("Linear model", n), 
                 rep("Log-transformed LM", n),
                 rep("Poisson (log)",n),
                 rep("Binomial (logit)",n)),  
               levels=c("Linear model", 
                        "Log-transformed LM",
                        "Poisson (log)",
                        "Binomial (logit)"), 
               ordered = TRUE),
  Temperature=rep(temp, 4),
  Units_sold=rep(units, 4),
  rbind(predict(lin.mod),
        exp(predict(log.lin.mod) + 
              0.5 * mean(extract(log.lin.mod$fit)[["sigma_log_units"]])),
        predict(pois.mod),
        predict(bin.mod)
  ))

library(lattice)
key <- list(
  rep=FALSE, 
  lines=list(col=c("#00526D", "blue"), type=c("p","l"), pch=1),
  text=list(lab=c("Observation","Estimate")),
  rectangles = list(col=adjustcolor("yellow", alpha.f=0.5), border="grey"),
  text=list(lab="95% Prediction credible interval"))
xyplot(l.95..CI + u.95..CI + Estimate + Units_sold ~ Temperature | Model, 
       data=modelData, as.table=TRUE, main="Ice cream model comparision",
       xlab="Temperatures (C)", ylab="Units sold", 
       scales=list(alternating=1), key=key,
       panel=function(x, y){
         n <- length(x)
         k <- n/2
         upper <- y[(k/2+1):k]
         lower <- y[1:(k/2)]
         x <- x[1:(k/2)]
         panel.polygon(c(x, rev(x)), c(upper, rev(lower)),
                       col = adjustcolor("yellow", alpha.f = 0.5), 
                       border = "grey")
         panel.lines(x, y[(k+1):(k+n/4)], col="blue")
         panel.points(x, y[(n*3/4+1):n], lwd=2, col="#00526D")
       })





