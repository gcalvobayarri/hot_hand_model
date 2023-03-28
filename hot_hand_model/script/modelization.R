load('./data/matrix_data_ft_complete_season_all.RData')


# 1. Model with random effects gamma----------

load('./data/matrix_data_ft_complete_season_all.RData')

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

save(rsamps_hot_hand_ft_re_all2, file = './results/rsamps_hot_hand_ft_re_all2.RData')
#load('./results/rsamps_hot_hand_ft_re_all2.RData')

mcmcplot(rsamps_hot_hand_ft_re_all2)

summary(rsamps_hot_hand_ft_re_all2)$statistics[-(c(3 : 317)),]
summary(rsamps_hot_hand_ft_re_all2)$quantiles[-(c(3 : 317)),]

# library(boot)
# 
# inv.logit(0.0595)
# inv.logit(-0.278)
