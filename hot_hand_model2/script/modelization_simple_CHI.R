load('./data/matrix_data_CHI.RData')


# 1. Model with random effects gamma----------
set.seed(23682)
library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_CHI_partido, 
             dist = distance_matrix, ft = ft)


inits <- function() {
  list( beta0 = runif(1, -10, 10))}


parameters <- c("beta0", "sigmab", "beta_d", "b", 'betaft')


result <- jags.model("./model/simple_model.txt", data, inits, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 30000)

rsamps_simple_CHI <- coda.samples(result, parameters, n.iter = 30000, 
                              thin = 30)

# DIC_CHI_simple <- dic.samples(result, 50000, thin = 50, type='pD') # penalized

WAIC_CHI_simple <- jags.samples(result, c("deviance", "WAIC"), type="mean", 
                                n.iter=50000, thin=50)

CHI_simple_WAIC <- sum(WAIC_CHI_simple$deviance) + sum(WAIC_CHI_simple$WAIC)

save(CHI_simple_WAIC, rsamps_simple_CHI, file = './results/rsamps_simple_CHI.RData')
#load('./results/rsamps_simple_CHI.RData')

mcmcplot(rsamps_simple_CHI)

summary(rsamps_simple_CHI)$statistics[-c(5:48),]
summary(rsamps_simple_CHI)$quantiles[-c(5:48),]
