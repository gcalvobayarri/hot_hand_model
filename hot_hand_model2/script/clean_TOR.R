#1. Extracting data for TOR----------
library(sqldf)

load('./data/shots_TOR.RData')



data_shots_TOR$shot_distance[is.na(data_shots_TOR$shot_distance)] <- 15

# with blocks
data_shots_TOR$id <- 1 : length(data_shots_TOR[,1])

df_ft <- sqldf("SELECT * FROM data_shots_TOR WHERE type  LIKE '%Free Throw%'")

data_shots_TOR$ft <- 0

for(i in 1 : length(df_ft[,1])){
  data_shots_TOR$ft[df_ft$id[i]] <- 1
}


#2. Matrix-----------

games <- sqldf('SELECT COUNT(game_id), match_id FROM data_shots_TOR GROUP BY game_id
               ORDER BY match_id')

tiros_TOR_partido <- games$`COUNT(game_id)`

matrix_tiros <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_TOR_partido))

ft <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_TOR_partido))

distance_matrix <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_TOR_partido))


numero_tiros <- 0
for(i in 1 : length(games[,1])){
  for(t in 1 : tiros_TOR_partido[i]){
    matrix_tiros[i, t] <- data_shots_TOR$numeric_res[numero_tiros + t]
    
    ft[i, t] <- data_shots_TOR$ft[numero_tiros + t]
    
    distance_matrix[i, t] <- as.numeric(data_shots_TOR$shot_distance[numero_tiros + t])
    
  }
  numero_tiros <- numero_tiros + tiros_TOR_partido[i]
}



save(matrix_tiros, ft, distance_matrix, tiros_TOR_partido, 
     file = './data/matrix_data_TOR.RData')
