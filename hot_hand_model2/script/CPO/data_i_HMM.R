#1. Extracting data for MIA----------
library(sqldf)

load('./data/MIA_all.RData')
data_shots_MIA <- s2005.PbP.MIA
rm(s2005.PbP.MIA)


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

#3. numeric id match--------------- match_id <- as.vector(data_shots_MIA$date)
match_id <- as.vector(data_shots_MIA$date)
match_id <- as.factor(match_id)
match_id <- as.numeric(match_id)

data_shots_MIA <- data.frame(data_shots_MIA, match_id = match_id)

data_i_HMM <- data_shots_MIA

rm(data_shots_MIA, df_ft, i, match_id, shots_MIA)

# 4. numeric match-event id--------
load('./data/matrix_data_ft_complete_season_all2.RData')
# data_i_HMM <- sqldf("SELECT * FROM data_i_HMM ORDER BY ")

event_id <- c()
for(n in 1:length(tiros_por_partido)){
  
    event_id <- c(event_id, 1 : tiros_por_partido[n])
  
}
data_i_HMM <- data.frame(data_i_HMM, event_id = event_id)

rm(distance_matrix, ft, matrix_tiros, event_id, n, tiros_por_partido)
