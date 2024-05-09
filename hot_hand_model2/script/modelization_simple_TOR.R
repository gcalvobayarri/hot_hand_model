load('./data/matrix_data_TOR.RData')


# 1. Model with random effects gamma----------
set.seed(529363)
library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_TOR_partido, 
             dist = distance_matrix, ft = ft)


inits <- function() {
  list( beta0 = runif(1, -10, 10))}


parameters <- c("beta0", "sigmab", "beta_d", "b", 'betaft')


result <- jags.model("./model/simple_model.txt", data, inits, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 30000)

rsamps_simple_TOR <- coda.samples(result, parameters, n.iter = 30000, 
                                 thin = 30)

DIC_TOR_simple <- dic.samples(result, 50000, thin = 50, type='pD') # penalized


WAIC_TOR_simple <- jags.samples(result, c("deviance", "WAIC"), type="mean", 
                                n.iter=50000, thin=50)

TOR_simple_WAIC <- sum(WAIC_TOR_simple$deviance) + sum(WAIC_TOR_simple$WAIC)

save(TOR_simple_WAIC, rsamps_simple_TOR, file = './results/rsamps_simple_TOR.RData')
#load('./results/rsamps_simple_TOR.RData')

mcmcplot(rsamps_simple_TOR)

summary(rsamps_simple_TOR)$statistics[-c(5:48),]
summary(rsamps_simple_TOR)$quantiles[-c(5:48),]