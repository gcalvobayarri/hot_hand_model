# 1. Probabilities of shots depending on distances--------------
library(MCMCvis)
library(rjags)
library(scales)

load('./results/rsamps_hot_hand_ft_re_all2_V2.RData')
load('./data/matrix_data_ft_complete_season_all2.RData')
N <- length(tiros_por_partido)


beta0C <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[1]', ISB = F)))


beta0H <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[2]', ISB = F)))

sigmab <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'sigmab', ISB = F)))

betad <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                     params = 'beta_d', ISB = F)))

distance <- 25


betaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PCH', ISB = F)))


betaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PHC', ISB = F)))

sigmaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaCH', ISB = F)))



sigmaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaHC', ISB = F)))

niter <- length(betaCH)


b <- matrix(data = NA, nrow = N, ncol = niter)
bCH <- matrix(data = NA, nrow = N, ncol = niter)
bHC <- matrix(data = NA, nrow = N, ncol = niter)
pCH <- matrix(data = NA, nrow = N, ncol = niter)
pHC <- matrix(data = NA, nrow = N, ncol = niter)
DeltaC <- matrix(data = NA, nrow = N, ncol = niter)
DeltaH <- matrix(data = NA, nrow = N, ncol = niter)
for(i in 1 : N){
  b[i,] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                        params = paste('b[', i, ']', sep = ''), ISB = F)))
  
  bCH[i,] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = paste('bCH[', i, ']', sep = ''), ISB = F)))
  
  bHC[i,] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = paste('bHC[', i, ']', sep = ''), ISB = F)))
  
  pCH[i,] <- (1 + exp(-(betaCH + bCH[i,])))^(-1)
  pHC[i,] <- (1 + exp(-(betaHC + bHC[i,])))^(-1)
  
  DeltaC[i,] <- pHC[i,] / (pHC[i,] + pCH[i,])
  DeltaH[i,] <- pCH[i,] / (pHC[i,] + pCH[i,])
  
}


# 2. Probalities of success-----------

library(boot)
suc_cold <- matrix(NA, nrow = niter, ncol = N)
suc_hot <- matrix(NA, nrow = niter, ncol = N)
suc <- matrix(NA, nrow = niter, ncol = N)

for(i in 1 : niter){
  for(n in 1 : N){
    suc_cold[, n] <- inv.logit(beta0C + betad * distance + b[n,])
    suc_hot[, n] <- inv.logit(beta0H + betad * distance + b[n, ])

    suc[, n] <- DeltaC[n, ] * suc_cold[, n] + DeltaH[n, ] * suc_hot[, n]
  }
}


# 3. Plots-----------------

plot(1 : N, apply(suc, 2, mean), type = 'l', ylim = c(0.2,0.5),
     lty = 2, ylab = '25-foot three-point probability', xlab = 'Match', 
     cex.lab=1.5, cex.axis=1.5)
polygon(c(1 : N,rev(1 : N)), 
        c(apply(suc, 2, quantile, probs = 0.025), rev(apply(suc, 2, quantile, probs = 0.975))), 
        col = alpha("#1F968BFF",0.8), lwd=4, border=NA)
lines(1 : N, apply(suc, 2, mean), type = 'l', lty = 2)

