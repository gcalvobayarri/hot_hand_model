# Transition probability matrix function t steps (KarlinTaylor formula)
Gamma_t <- function(pCH, pHC, t){
  
  G_t <- 1 / (pCH + pHC) * matrix(c(pHC, pHC, pCH, pCH), nrow = 2) +
    (1 - pCH - pHC)^t / (pCH + pHC) * matrix(c(pCH, -pHC, -pCH, pHC), nrow = 2)
  return(G_t)
}
