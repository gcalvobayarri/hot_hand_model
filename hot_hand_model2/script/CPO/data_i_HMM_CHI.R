#1. Extracting data for CHI----------
library(sqldf)

load('./data/shots_CHI.RData')


# data_shots_CHI$shot_distance[is.na(data_shots_CHI$shot_distance)] <- 15

# with blocks
data_shots_CHI$id <- 1 : length(data_shots_CHI[,1])

df_ft <- sqldf("SELECT * FROM data_shots_CHI WHERE type  LIKE '%Free Throw%'")

data_shots_CHI$ft <- 0

for(i in 1 : 3021){
  data_shots_CHI$ft[df_ft$id[i]] <- 1
}


#2. Numeric results-------------

shots_CHI <- as.vector(data_shots_CHI$result)
class(shots_CHI)
shots_CHI <- as.factor(shots_CHI)
library(plyr)
shots_CHI <- revalue(shots_CHI, c("made"=1, "missed"=0))
shots_CHI <- as.numeric(shots_CHI)
shots_CHI[shots_CHI==2] <- 0



data_shots_CHI <- data.frame(data_shots_CHI, numeric_res = shots_CHI)

#3. numeric id match--------------- match_id <- as.vector(data_shots_CHI$date)
match_id <- as.vector(data_shots_CHI$date)
match_id <- as.factor(match_id)
match_id <- as.numeric(match_id)

data_shots_CHI <- data.frame(data_shots_CHI, match_id = match_id)

data_i_HMM <- data_shots_CHI

rm(data_shots_CHI, df_ft, i, match_id, shots_CHI)

# 4. numeric match-event id--------
load('./data/matrix_data_CHI.RData')
# data_i_HMM <- sqldf("SELECT * FROM data_i_HMM ORDER BY ")

event_id <- c()
for(n in 1:length(tiros_CHI_partido)){
  
    event_id <- c(event_id, 1 : tiros_CHI_partido[n])
  
}
data_i_HMM <- data.frame(data_i_HMM, event_id = event_id)

rm(distance_matrix, ft, matrix_tiros, event_id, n, tiros_CHI_partido)

data_i_HMM$shot_distance <- as.numeric(data_i_HMM$shot_distance)
