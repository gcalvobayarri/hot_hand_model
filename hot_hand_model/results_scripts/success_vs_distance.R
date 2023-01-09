# 1. Probabilities of shots depending on distances--------------
library(MCMCvis)
library(rjags)

load('./results/rsamps_hot_hand_ft_re_all2.RData')

beta0C <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[1]', ISB = F)))


beta0H <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'beta0[2]', ISB = F)))

sigmab <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'sigmab', ISB = F)))

betad <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                     params = 'beta_d', ISB = F)))

distance <- seq(from = 0, to = 27, by = 0.1)


betaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PCH', ISB = F)))


betaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                      params = 'PHC', ISB = F)))

sigmaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaCH', ISB = F)))



sigmaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_ft_re_all2, 
                                       params = 'sigmaHC', ISB = F)))

niter <- length(betaCH)

bCH <- c()
bHC <- c()
b <- c()
for(i in 1 : niter){
  bCH[i] <- rnorm(1, mean = 0, sd = sigmaCH[i])
  bHC[i] <- rnorm(1, mean = 0, sd = sigmaHC[i])
  b[i] <- rnorm(1, mean = 0, sd = sigmab[i])
}

pCH <- (1 + exp(-(betaCH + bCH)))^(-1)
pHC <- (1 + exp(-(betaHC + bHC)))^(-1)

DeltaC <- pHC / (pHC + pCH)

DeltaH <- pCH / (pHC + pCH)

niter <- length(pCH)


# 2. Probalities of success-----------

library(boot)
suc_cold <- matrix(NA, nrow = niter, ncol = length(distance))
suc_hot <- matrix(NA, nrow = niter, ncol = length(distance))
suc <- matrix(NA, nrow = niter, ncol = length(distance))

for(i in 1 : niter){
  for(d in 1 : length(distance)){
    suc_cold[i, d] <- inv.logit(beta0C[i] + betad[i] * distance[d] + b[i])
    suc_hot[i, d] <- inv.logit(beta0H[i] + betad[i] * distance[d] + b[i])
    
    suc[i, d] <- DeltaC[i] * suc_cold[i, d] + DeltaH[i] * suc_hot[i, d]
  }
}


# 3. Plots-----------------

plot(distance, apply(suc, 2, mean), type = 'l', ylim = c(0.0,1),
     lty = 2, ylab = 'Probability of a made shot', xlab = 'Distance', 
     cex.lab=1.5, cex.axis=1.5)
polygon(c(distance,rev(distance)), 
        c(apply(suc, 2, quantile, probs = 0.025), rev(apply(suc, 2, quantile, probs = 0.975))), 
        col = rgb(0, 0.8, .1,0.7), lwd=4, border=NA)


lines(distance, apply(suc_cold, 2, mean), type = 'l', lty = 2)
polygon(c(distance,rev(distance)), 
        c(apply(suc_cold, 2, quantile, probs = 0.025), rev(apply(suc_cold, 2, quantile, probs = 0.975))), 
        col = rgb(0, 0.1, .8,0.7), lwd=4, border=NA)

polygon(c(distance,rev(distance)), 
        c(apply(suc_hot, 2, quantile, probs = 0.025), rev(apply(suc_hot, 2, quantile, probs = 0.975))), 
        col = rgb(.8, 0.1, 0,0.7), lwd=4, border=NA)
lines(distance, apply(suc_hot, 2, mean), type = 'l', lty = 2)
