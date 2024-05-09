# 1. Reading parameters---------------
library(MCMCvis)
library(rjags)

load('./results/rsamps_hot_hand_TOR.RData')


betaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'PCH', ISB = F)))


betaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'PHC', ISB = F)))

sigmaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                       params = 'sigmaCH', ISB = F)))



sigmaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                       params = 'sigmaHC', ISB = F)))

deltaC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'delta0[1]', ISB = F)))

alphaC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'beta0[1]', ISB = F)))

alphaH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'beta0[2]', ISB = F)))

alphad <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                      params = 'beta_d', ISB = F)))

alphaFT <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
                                       params = 'betaft', ISB = F)))

sigmaa <- as.vector(unlist(MCMCchains(rsamps_hot_hand_TOR, 
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
