load('./data/matrix_data_ft_complete_season_all2.RData')


# 1. Model with random effects gamma----------

library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_por_partido, 
             dist = distance_matrix, ft = ft)


inits_HMM <- list( beta0.p = runif(2, -10, 10))


parameters <- c("beta0", "PCH", "PHC", "bCH", "bHC", "sigmaCH", "sigmaHC", 
                "sigmab", "beta_d", 
                "b", "delta0",  'betaft')


result <- jags.model("model/longitudinal_model_ft_re2.txt", data, inits_HMM, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 30000)

rsamps_hot_hand_ft_re_all2 <- coda.samples(result, parameters, n.iter = 30000, 
                                           thin = 30)

DIC_MIA<- dic.samples(result, 50000, thin = 50, type='pD') # penalized

WAIC_MIA <- jags.samples(result, c("deviance", "WAIC"), type="mean", 
                         n.iter=50000, thin=50)

MIA_WAIC <- sum(WAIC_MIA$deviance) + sum(WAIC_MIA$WAIC)


save(MIA_WAIC, rsamps_hot_hand_ft_re_all2, file = './results/rsamps_hot_hand_ft_re_all2_v2.RData')
# load('./results/rsamps_hot_hand_ft_re_all2_v2.RData')

mcmcplot(rsamps_hot_hand_ft_re_all2)

summary(rsamps_hot_hand_ft_re_all2)$statistics[-(c(3 : 317)),]
summary(rsamps_hot_hand_ft_re_all2)$quantiles[-(c(3 : 317)),]

