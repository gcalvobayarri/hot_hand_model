set.seed(7654197)
# 10. 4. 1 Ntzoufras CPO
library(rjags)
library(mnormt)
library(boot)
library(expm)
source('./script/CPO/posterior_draws_simple_CHI.R') #saved in draws_posterior

source('./script/CPO/data_i_HMM_CHI.R')


#-------------------

source('./functions/suma_logaritmica_de_elementos.R') #function


log_cpo_i <- function(data_i, draws, log = TRUE) { 
  
  log_likelihood <- c()
  for(i in 1 : dim(draws)[1]){
    
    log_likelihood[i] <- dbinom(x = data_i$numeric_res, size = 1, 
                                prob = inv.logit(draws[i, 1] + 
                                                   draws[i, 3 + data_i$match_id] + 
                                                   draws[i, 3] * data_i$ft + 
                                                   draws[i, 2] * data_i$shot_distance),
                                log = log)
  }
  
  
  
  inv_loglik <- - log_likelihood
  
  mean_inv_loglik <- - log(dim(draws)[1]) + suma_logaritmica_de_elementos(inv_loglik)
  
  log_cpo <- - mean_inv_loglik
  
  return(log_cpo) 
}

log_cpo <- c()
for(s in 1 : dim(data_i_HMM)[1]){
  log_cpo[s] <- log_cpo_i(data_i =  data_i_HMM[s,], 
                          draws =  draws_posterior)
}

log_cpo_simple_CHI <- log_cpo


# hist(log_cpo)


save(log_cpo_simple_CHI, 
     file = './results/log_cpo_simple_CHI.RData')
