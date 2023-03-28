# 1. Reading parameters---------------
library(MCMCvis)
library(rjags)

load('./results/rsamps_hot_hand_ft_re_all2.RData')
source('./functions/Gamma_t.R')



betaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PCH', ISB = F)))


betaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PHC', ISB = F)))

sigmaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaCH', ISB = F)))



sigmaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaHC', ISB = F)))

deltaC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'delta0[1]', ISB = F)))

alphaC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[1]', ISB = F)))

alphaH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[2]', ISB = F)))

alphad <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta_d', ISB = F)))

alphaFT <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'betaft', ISB = F)))

sigmaa <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'sigmab', ISB = F)))

# install.packages("posterior")
library(posterior)

rhat_basic(matrix(betaCH, ncol = 3))
rhat_basic(matrix(betaHC, ncol = 3))
rhat_basic(matrix(deltaC, ncol = 3))
rhat_basic(matrix(sigmaCH, ncol = 3))
rhat_basic(matrix(sigmaHC, ncol = 3))

rhat_basic(matrix(alphaC, ncol = 3))
rhat_basic(matrix(alphaH, ncol = 3))
rhat_basic(matrix(alphad, ncol = 3))
rhat_basic(matrix(alphaFT, ncol = 3))
rhat_basic(matrix(sigmaa, ncol = 3))



