# 1. Sojourn times---------------
library(MCMCvis)
library(rjags)

load('./results/rsamps_hot_hand_CHI.RData')
load('./data/matrix_data_CHI.RData')


betaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                      params = 'PCH', ISB = F)))


betaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                      params = 'PHC', ISB = F)))

sigmaCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                       params = 'sigmaCH', ISB = F)))



sigmaHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
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

pCC <- 1 - pCH
pHH <- 1 - pHC


mshot <- max(tiros_CHI_partido)
niter <- length(pCH)

tiempo_permanencia_hot <- matrix(data = NA, nrow = mshot, ncol = niter)
tiempo_permanencia_cold <- matrix(data = NA, nrow = mshot, ncol = niter)

for(n in 1 : mshot){
  tiempo_permanencia_hot[n,] <- pHH^n * pHC
  tiempo_permanencia_cold[n,] <- pCC^n * pCH
}


df_remaining_time_gr3 <- 
  data.frame(iter = c(colSums(tiempo_permanencia_cold[3:101,]), colSums(tiempo_permanencia_hot[3:101,])), 
             par = c(rep('C', 3000), rep('H', 3000)))

df_remaining_time_gr3$par <- as.factor(df_remaining_time_gr3$par)
library(ggplot2)


ggplot(df_remaining_time_gr3, aes(x = par, y = iter, fill = par)) +
  geom_violin(alpha = .7)+ 
  scale_fill_manual(values=c("#440154FF", "#FDE725FF")) +
  geom_boxplot(width=0.1, fill="white") +
  theme_minimal(base_size = 20, base_line_size = 15/20)+
  # xlim(.35,.65) + ylim(0, 40) +
  labs(x="State", y = "Probability") +
  theme(legend.position = 'none') 
