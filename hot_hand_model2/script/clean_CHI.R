#1. Extracting data for CHI----------
library(sqldf)

load('./data/shots_CHI.RData')

data_shots_CHI$id <- 1 : length(data_shots_CHI[,1])

df_ft <- sqldf("SELECT * FROM data_shots_CHI WHERE type  LIKE '%Free Throw%'")

data_shots_CHI$ft <- 0

for(i in 1 : length(df_ft[,1])){
  data_shots_CHI$ft[df_ft$id[i]] <- 1 # variable ft indicates free throw -> 1
}

# 2. Matrix-----------

games <- sqldf('SELECT COUNT(game_id), match_id FROM data_shots_CHI GROUP BY game_id
               ORDER BY match_id')

tiros_CHI_partido <- games$`COUNT(game_id)`

matrix_tiros <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_CHI_partido))

ft <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_CHI_partido))

distance_matrix <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_CHI_partido))


numero_tiros <- 0
for(i in 1 : length(games[,1])){
  for(t in 1 : tiros_CHI_partido[i]){
    matrix_tiros[i, t] <- data_shots_CHI$numeric_res[numero_tiros + t]
    
    ft[i, t] <- data_shots_CHI$ft[numero_tiros + t]
    
    distance_matrix[i, t] <- as.numeric(data_shots_CHI$shot_distance[numero_tiros + t])
    
  }
  numero_tiros <- numero_tiros + tiros_CHI_partido[i]
}



save(matrix_tiros, ft, distance_matrix, tiros_CHI_partido, 
     file = './data/matrix_data_CHI.RData')
