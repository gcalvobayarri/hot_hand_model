#1. Extracting data for TOR----------
library(sqldf)

load('./data/shots_TOR.RData')



# with blocks
data_shots_TOR$id <- 1 : length(data_shots_TOR[,1])

df_ft <- sqldf("SELECT * FROM data_shots_TOR WHERE type  LIKE '%Free Throw%'")

data_shots_TOR$ft <- 0

for(i in 1 : 3021){
  data_shots_TOR$ft[df_ft$id[i]] <- 1
}


#2. Numeric results-------------

shots_TOR <- as.vector(data_shots_TOR$result)
class(shots_TOR)
shots_TOR <- as.factor(shots_TOR)
library(plyr)
shots_TOR <- revalue(shots_TOR, c("made"=1, "missed"=0))
shots_TOR <- as.numeric(shots_TOR)
shots_TOR[shots_TOR==2] <- 0



data_shots_TOR <- data.frame(data_shots_TOR, numeric_res = shots_TOR)

#3. numeric id match--------------- match_id <- as.vector(data_shots_TOR$date)
match_id <- as.vector(data_shots_TOR$date)
match_id <- as.factor(match_id)
match_id <- as.numeric(match_id)

data_shots_TOR <- data.frame(data_shots_TOR, match_id = match_id)

data_i_HMM <- data_shots_TOR

rm(data_shots_TOR, df_ft, i, match_id, shots_TOR)

# 4. numeric match-event id--------
load('./data/matrix_data_TOR.RData')
# data_i_HMM <- sqldf("SELECT * FROM data_i_HMM ORDER BY ")

event_id <- c()
for(n in 1:length(tiros_TOR_partido)){
  
    event_id <- c(event_id, 1 : tiros_TOR_partido[n])
  
}
data_i_HMM <- data.frame(data_i_HMM, event_id = event_id)

rm(distance_matrix, ft, matrix_tiros, event_id, n, tiros_TOR_partido)

data_i_HMM$shot_distance <- as.numeric(data_i_HMM$shot_distance)
