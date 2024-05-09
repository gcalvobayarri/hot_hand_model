load('./data/matrix_data_CHI.RData')


# 1. Model with random effects ----------
set.seed(131948)
library(rjags)
library(mcmcplots)

data <- list(Y = matrix_tiros, N = dim(matrix_tiros)[1], T = tiros_CHI_partido, 
             dist = distance_matrix, ft = ft)


inits_HMM <- list( beta0.p = runif(2, -10, 10))


parameters <- c("beta0", "PCH", "PHC", "bCH", "bHC", "sigmaCH", "sigmaHC", 
                "sigmab", "beta_d", 
                "b", "delta0",  'betaft')


result <- jags.model("model/longitudinal_model_ft_re2.txt", data, inits_HMM, n.chains = 3,
                     n.adapt = 0)

update(result, n.iter = 50000)

rsamps_hot_hand_CHI <- coda.samples(result, parameters, n.iter = 50000, 
                                    thin = 50)

DIC_CHI<- dic.samples(result, 50000, thin = 50, type='pD') # penalized

WAIC_CHI <- jags.samples(result, c("deviance", "WAIC"), type="mean", 
                                n.iter=50000, thin=50)

CHI_WAIC <- sum(WAIC_CHI$deviance) + sum(WAIC_CHI$WAIC)

save(CHI_WAIC, rsamps_hot_hand_CHI, file = './results/rsamps_hot_hand_CHI.RData')
# load('./results/rsamps_hot_hand_CHI.RData')

mcmcplot(rsamps_hot_hand_CHI)

summary(rsamps_hot_hand_CHI)$statistics[-(c(3 : 250)),]
summary(rsamps_hot_hand_CHI)$quantiles[-(c(3 : 250)),]
