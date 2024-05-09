load('./data/matrix_data_TOR.RData')


# 1. Model with random effects ----------
set.seed(582267)
library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_TOR_partido, 
             dist = distance_matrix, ft = ft)


inits_HMM <- list( beta0.p = c(-10,30),
                   PCH = -0.5, PHC=0.5)


parameters <- c("beta0", "PCH", "PHC", "bCH", "bHC", "sigmaCH", "sigmaHC", 
                "sigmab", "beta_d", 
                "b", "delta0",  'betaft')


result <- jags.model("model/longitudinal_model_ft_re2.txt", data, inits_HMM, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 50000)

rsamps_hot_hand_TOR <- coda.samples(result, parameters, n.iter = 50000, 
                                   thin = 50)

DIC_TOR2<- dic.samples(result, 50000, thin = 50, type='pD') # penalized

WAIC_TOR <- jags.samples(result, c("deviance", "WAIC"), type="mean", 
                         n.iter=50000, thin=50)

TOR_WAIC <- sum(WAIC_TOR$deviance) + sum(WAIC_TOR$WAIC)


save(TOR_WAIC, rsamps_hot_hand_TOR, file = './results/rsamps_hot_hand_TOR.RData')
# load('./results/rsamps_hot_hand_TOR.RData')

mcmcplot(rsamps_hot_hand_TOR)

summary(rsamps_hot_hand_TOR)$statistics[-(c(3 : 248)),]
summary(rsamps_hot_hand_TOR)$quantiles[-(c(3 : 248)),]
