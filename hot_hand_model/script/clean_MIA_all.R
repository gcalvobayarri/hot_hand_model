#1. Extracting data for MIA----------
library(sqldf)

load('./data/MIA_all.RData')
data_shots_MIA <- s2005.PbP.MIA
rm(s2005.PbP.MIA)

# pacientes$tratamiento[pacientes$tratamiento == ""] <- "No"
data_shots_MIA[is.na(data_shots_MIA)] <- ""
data_shots_MIA$shot_distance[is.na(data_shots_MIA$shot_distance)] <- 15

# with blocks
data_shots_MIA$id <- 1 : length(data_shots_MIA[,1])

df_ft <- sqldf("SELECT * FROM data_shots_MIA WHERE type  LIKE '%Free Throw%'")

data_shots_MIA$ft <- 0

for(i in 1 : 3021){
  data_shots_MIA$ft[df_ft$id[i]] <- 1
}


#2. Numeric results-------------

shots_MIA <- as.vector(data_shots_MIA$result)
class(shots_MIA)
shots_MIA <- as.factor(shots_MIA)
library(plyr)
shots_MIA <- revalue(shots_MIA, c("made"=1, "missed"=0))
shots_MIA <- as.numeric(shots_MIA)
shots_MIA[shots_MIA==2] <- 0



data_shots_MIA <- data.frame(data_shots_MIA, numeric_res = shots_MIA)

#3. numeric id match---------------
match_id <- as.vector(data_shots_MIA$game_id)
match_id <- as.factor(match_id)
match_id <- as.numeric(match_id)

data_shots_MIA <- data.frame(data_shots_MIA, match_id = match_id)

save(shots_MIA, file = './data/shots_MIA_all.RData')




# 5. Matrix-----------

games <- sqldf('SELECT COUNT(game_id) FROM data_shots_MIA GROUP BY game_id')

tiros_por_partido <- games$`COUNT(game_id)`

matrix_tiros <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_por_partido))

ft <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_por_partido))

distance_matrix <- matrix(data = NA, nrow = length(games[,1]), ncol = max(tiros_por_partido))


numero_tiros <- 0
for(i in 1 : length(games[,1])){
  for(t in 1 : tiros_por_partido[i]){
    matrix_tiros[i, t] <- shots_MIA[numero_tiros + t]
    
    ft[i, t] <- data_shots_MIA$ft[numero_tiros + t]
    
    distance_matrix[i, t] <- as.numeric(data_shots_MIA$shot_distance[numero_tiros + t])
    
  }
  numero_tiros <- numero_tiros + tiros_por_partido[i]
}


# load('./data/matricial_data_no_blocks.RData')

save(matrix_tiros, ft, distance_matrix, tiros_por_partido, 
     file = './data/matrix_data_ft_complete_season_all.RData')
