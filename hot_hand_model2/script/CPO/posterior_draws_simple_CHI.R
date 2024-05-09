library(rjags)
library(MCMCvis)
library(boot)

load('./results/rsamps_simple_CHI.RData')
load('./data/matrix_data_CHI.RData')

# summary(rsamps_simple_CHI_CHI)$statistics


I <- 1000
C <- 3
n <- length(tiros_CHI_partido)

rm(distance_matrix, ft, matrix_tiros, tiros_CHI_partido)

b <- matrix(data = NA, nrow = n, ncol = C * I)
for(i in 1 : n){
  b[i, ] <- as.vector(unlist(MCMCchains(rsamps_simple_CHI, 
                                        params = paste("b","[",i,"]", sep = ''), 
                                        ISB = F)))
  
}



beta0 <- as.vector(unlist(MCMCchains(rsamps_simple_CHI,
                                     params = "beta0", ISB = F)))

betaft <- as.vector(unlist(MCMCchains(rsamps_simple_CHI,
                                      params = "betaft", ISB = F)))
beta_d <- as.vector(unlist(MCMCchains(rsamps_simple_CHI,
                                      params = "beta_d", ISB = F)))



draws_posterior <- cbind(beta0, beta_d, betaft, t(b))

#draws_posterior
# beta0 column 1
# beta_d column 2
# betaft column 3

# b columns 4-87


rm(b, rsamps_simple_CHI, beta_d, beta0,betaft, C, i, I, n)
