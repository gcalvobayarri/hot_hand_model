# 1. Stationary distribution--------------
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

niter <- length(betaCH)

bCH <- c()
bHC <- c()
for(i in 1 : niter){
  bCH[i] <- rnorm(1, mean = 0, sd = sigmaCH[i])
  bHC[i] <- rnorm(1, mean = 0, sd = sigmaHC[i])
}

pCH <- (1 + exp(-(betaCH + bCH)))^(-1)
pHC <- (1 + exp(-(betaHC + bHC)))^(-1)


# 1.1. Calculations------------

D1 <- pHC / (pHC + pCH); mean(D1); sd(D1); quantile(D1, 0.025); quantile(D1, 0.975)

D2 <- pCH / (pHC + pCH); mean(D2); sd(D2); quantile(D2, 0.025); quantile(D2, 0.975)

# extra
# mean(pHC)
# mean(pCH)
