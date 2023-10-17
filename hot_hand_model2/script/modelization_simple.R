load('./data/matrix_data_ft_complete_season_all2.RData')


# 1. Model with random effects gamma----------

library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_por_partido, 
             dist = distance_matrix, ft = ft)


inits <- function() {
  list( beta0 = runif(1, -10, 10))}


parameters <- c("beta0", "sigmab", "beta_d", "b", 'betaft')


result <- jags.model("./model/simple_model.txt", data, inits, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 30000)

rsamps_simple <- coda.samples(result, parameters, n.iter = 30000, 
                                           thin = 30)

save(rsamps_simple, file = './results/pruebas/rsamps_simple.RData')
#load('./results/rsamps_hot_hand_ft_re_all2.RData')

mcmcplot(rsamps_simple)

summary(rsamps_simple)$statistics[-c(5:48),]
summary(rsamps_simple)$quantiles[-c(5:48),]
