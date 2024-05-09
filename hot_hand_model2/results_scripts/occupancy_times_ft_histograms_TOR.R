# 1. Occupancy times--------------
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


oc_matrix <- array(data = NA, dim = c(2, 2, 120, niter))

for(i in 1 : niter){
  for(n in 1 : 120){
    oc_matrix[1, 1, n, i] <- 
      (n +1) / (2 - ( (1 - pCH[i]) + (1 - pHC[i])   )) * pHC[i] +
      (1 - ((1 - pCH[i]) + (1 - pHC[i]) - 1)^(n + 1)) / 
      (2 - ( (1 - pCH[i]) + (1 - pHC[i])   ))^2 * pCH[i]
    
    
    oc_matrix[1, 2, n, i] <- 
      (n +1) / (2 - ( (1 - pCH[i]) + (1 - pHC[i])   )) * pCH[i] +
      (1 - ((1 - pCH[i]) + (1 - pHC[i]) - 1)^(n + 1)) / 
      (2 - ( (1 - pCH[i]) + (1 - pHC[i])   ))^2 * (-pCH[i])
    
    
    oc_matrix[2, 1, n, i] <- 
      (n +1) / (2 - ( (1 - pCH[i]) + (1 - pHC[i])   )) * pHC[i] +
      (1 - ((1 - pCH[i]) + (1 - pHC[i]) - 1)^(n + 1)) / 
      (2 - ( (1 - pCH[i]) + (1 - pHC[i])   ))^2 * (-pHC[i])
    
    
    oc_matrix[2, 2, n, i] <- 
      (n +1) / (2 - ( (1 - pCH[i]) + (1 - pHC[i])   )) * pCH[i] +
      (1 - ((1 - pCH[i]) + (1 - pHC[i]) - 1)^(n + 1)) / 
      (2 - ( (1 - pCH[i]) + (1 - pHC[i])   ))^2 * pHC[i]
    
    
  }
}




# 2. Plot ----------------

N <- 120 # number of shots

df_C <- data.frame(m = c(oc_matrix[1, 1, N,], oc_matrix[1, 2, N,]),
                   element_matrix = c(rep('CC', niter), rep('CH', niter)),
                   color = c(rep('blue', niter), rep('red', niter)))

df_H <- data.frame(m = c(oc_matrix[2, 1, N,], oc_matrix[2, 2, N,]),
                   element_matrix = c(rep('HC', niter), rep('HH', niter)),
                   color = c(rep('blue', niter), rep('red', niter)))


library(ggplot2)
ggplot(df_C, aes(x=m, fill = element_matrix)) +
  geom_histogram(binwidth = .25, alpha=.6, position = 'identity')+ 
  theme_minimal(base_size = 20, base_line_size = 15/20) +
  xlim(35, 85) + ylim(0, 170) +
  labs(x="", y = "") +
  scale_fill_manual(values=c("#440154FF", "#FDE725FF"))+
  theme(legend.position = 'none') 

ggplot(df_H, aes(x=m, fill = element_matrix)) +
  geom_histogram(binwidth = .25, alpha=.6, position = 'identity')+ 
  theme_minimal(base_size = 20, base_line_size = 15/20) +
  xlim(35, 85) + ylim(0, 170) +
  labs(x="", y = "") +
  scale_fill_manual(values=c("#440154FF", "#FDE725FF"))+
  theme(legend.position = 'none') 
