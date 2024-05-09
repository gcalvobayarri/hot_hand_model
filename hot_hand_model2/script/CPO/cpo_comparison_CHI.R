load('./results/log_cpo_simple_CHI.RData')
load('./results/log_cpo_HMM_CHI.RData')

# 1. Gibbs sampling
# mu_d posterior------------

# suppose that prior of mu_d ~ N(mu0, sigma_0), # the mean is normal for the CLT
# and                   sigma_d ~ U(0, 10)        

# Posterior conditional density:
# (mu_d | cpo_diff, sigma_d) ~ 
# N (N * sigma_0^2 * mean(cpo_diff) / (sigma_0^2 * N + sigma_d^2) + 
# sigma_d^2 * mu0 / (sigma_0^2 + sigma_d^2),  
# sigma_d^2 * sigma_0^2 / (sigma_0^2 * N + sigma_d^2)  )
# sigma_d prop to (1/sigma_d)^(N/2) * 
# exp(-sum((cpo_diff-mu_d)^2) / (2 * sigma_d)) * U(0, 10)

cpo_diff <- exp(log_cpo_HMM_CHI)-exp(log_cpo_simple_CHI)

# cpo_diff <- rnorm(1000, 5, 0.25)



sigma_posterior <- function(yy, sigma_anterior, mmu) { # Metropolis-Hastings function
  
  N <- length(yy)
  
  # sigma
  sigma_proposal <- runif(1, max(c(sigma_anterior - 0.1, 0)), min(sigma_anterior + 0.1, 10))
  ln_pdf_proposal <- c()
  ln_pdf_anterior <- c()
  # 
  rho <- 0
  for(i in 1 : N){
    
    ln_pdf_proposal[i] <- (log(1 / (sigma_proposal * sqrt(2 * pi))) +
                             (-0.5 * (yy[i] - (mmu))^2 / sigma_proposal^2))
    
    
    
    
    # escribirlo como suma
    ln_pdf_anterior[i] <-  (log(1 / (sigma_anterior * sqrt(2 * pi))) +
                              (-0.5 * (yy[i] - (mmu))^2 / sigma_anterior^2))
    
    #   log(dnorm(yy[n, t + 1],
    # beta00 + bb0[n] + bb1[n] * t,  sigma_anterior ))
    # 
    
    rho <- rho + ((ln_pdf_proposal[i])) - (ln_pdf_anterior[i])
    
  }
  rho <- rho + 
    log(dunif(sigma_anterior, max(c(sigma_proposal - .1, 0)), max(sigma_proposal + .1, 10))) - 
    log(dunif(sigma_proposal, max(c(sigma_anterior - .1, 0)), min(sigma_anterior + .1, 10)))
  
  ssigma <- sigma_anterior + (sigma_proposal - sigma_anterior) * (runif(1)<exp(rho))
  
  
  return(ssigma)
}



N <- length(cpo_diff)

sigma_0 <- 10
mu0 <- 0

mu_d <- c(1,NA)
sigma_d <- c(1,NA)
niter <- 10000
nburning <- 1000


for(i in 2 : niter){
  mu_d[i] <- rnorm(1, # complete conditional density
                   mean = (N * sigma_0^2 * mean(cpo_diff) / (sigma_0^2 * N + sigma_d[i-1]^2) + 
                             sigma_d[i-1]^2 * mu0 / (sigma_0^2 + sigma_d[i-1]^2)),
                   sd = sqrt(sigma_d[i-1]^2 * sigma_0^2 / (sigma_0^2 * N + sigma_d[i-1]^2)) )
  sigma_d[i] <- sigma_posterior(cpo_diff, sigma_d[i-1], mu_d[i])
}


posterior <- data.frame(mu_d=mu_d[-c(1:1000)])
library(ggplot2)
ggplot(posterior, aes(x=mu_d)) + 
  geom_histogram(aes(y = ..density..), binwidth = 0.0002, col='black', 
                 fill='green', alpha=0.4, 
                 position = 'identity') + 
  theme_minimal(base_size = 20, base_line_size = 15/20) +
  labs(x="", y = "")
