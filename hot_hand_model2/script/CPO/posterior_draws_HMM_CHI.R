library(rjags)
library(MCMCvis)
library(boot)

load('./results/rsamps_hot_hand_CHI.RData')
load('./data/matrix_data_CHI.RData')

# summary(rsamps_hot_hand_CHI)$statistics[-(c(3 : 317)),]


I <- 1000
C <- 3
n <- length(tiros_CHI_partido)

rm(distance_matrix, ft, matrix_tiros, tiros_CHI_partido)

b <- matrix(data = NA, nrow = n, ncol = C * I)
bCH <- matrix(data = NA, nrow = n, ncol = C * I)
bHC <- matrix(data = NA, nrow = n, ncol = C * I)
for(i in 1 : n){
  b[i, ] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                          params = paste("b","[",i,"]", sep = ''), 
                                          ISB = F)))
  bCH[i, ] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                        params = paste("bCH","[",i,"]", sep = ''), 
                                        ISB = F)))
  bHC[i, ] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
                                          params = paste("bHC","[",i,"]", sep = ''), 
                                          ISB = F)))
  
}

# Z <- matrix(data = NA, nrow = n, ncol = C * I)
# for(i in 1 : n){
#   for(j in 1 : tiros_CHI_partido[i])
# {  Z[i, j, ] <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI, 
#                                         params = paste("Z","[",i,",",j,"]", sep = ''), 
#                                         ISB = F)))}
#   
# }


beta0C <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                      params = "beta0[1]", ISB = F)))
beta0H <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                      params = "beta0[2]", ISB = F)))

betaft <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                      params = "betaft", ISB = F)))
beta_d <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                      params = "beta_d", ISB = F)))

delta0 <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                     params = "delta0[1]", ISB = F)))

PCH <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                   params = "PCH", ISB = F)))
PHC <- as.vector(unlist(MCMCchains(rsamps_hot_hand_CHI,
                                   params = "PHC", ISB = F)))


pCH <- matrix(data = NA, nrow = n, ncol = C * I)
pHC <- matrix(data = NA, nrow = n, ncol = C * I)
for(i in 1 : n){
  pCH[i,] <- 1 / (1 + exp(-(PCH + bCH[i,])))
  pHC[i,] <- 1 / (1 + exp(-(PHC + bHC[i,])))
}



draws_posterior <- cbind(beta0C, beta0H, beta_d, betaft, delta0,  t(b), 
                         t(pCH), t(pHC))

#draws_posterior
# beta0C column 1
# beta0H column 2
# beta_d column 3
# betaft column 4
# delta0 column 5

# b columns 6-89

# pCH columns 90-173
# pHC columns 174-257

rm(b, bCH, bHC, pCH, pHC, rsamps_hot_hand_CHI, beta_d, beta0C, beta0H,
   betaft, C, delta0, i, I, n, PCH, PHC)
