#1. Extracting data for CHI----------
load('./data/shots_CHI.RData')

data_shots_CHI$original_x[is.na(data_shots_CHI$original_x)] <- ""
data_shots_CHI$original_y[is.na(data_shots_CHI$original_y)] <- ""

data_shots_CHI$xx <- as.numeric(data_shots_CHI$original_x)/10
data_shots_CHI$yy <- as.numeric(data_shots_CHI$original_y)/10-41.75

data_shots_CHI[is.na(data_shots_CHI)] <- ""
data_shots_CHI$shot_distance[data_shots_CHI$shot_distance == ""] <- 15

#2. Numeric results-------------

shots_CHI <- as.vector(data_shots_CHI$result)
class(shots_CHI)
shots_CHI <- as.factor(shots_CHI)
library(plyr)
shots_CHI <- revalue(shots_CHI, c("made"=1, "missed"=0))
shots_CHI <- as.numeric(shots_CHI)
shots_CHI[shots_CHI==2] <- 0

#save(shots_CHI, file = 'shots_CHI.RData')

data_shots_CHI <- data.frame(data_shots_CHI, numeric_res = shots_CHI)

#3. numeric id match---------------
match_id <- as.vector(data_shots_CHI$game_id)
match_id <- as.factor(match_id)
match_id <- as.numeric(match_id)

data_shots_CHI <- data.frame(data_shots_CHI, match_id = match_id)

# 2. Plot------------------
# install.packages("viridis")
library(viridis)
library(ggplot2)
library(png)
library(ggpubr)
img <- readPNG("./documents/field_CHI.png")
shots <- na.omit(subset(data_shots_CHI, select = c('result', 'xx', 'yy')))
shots <- rbind(shots, c('', 0, - 41.75))
shots$result <- as.factor(shots$result)
shots$result <- factor(shots$result, labels = c('Basket', 'Shot made', 'Shot missed'))
shots$xx <- as.numeric(shots$xx)
shots$yy <- as.numeric(shots$yy)
ggplot(data = shots, aes(xx, yy))+ background_image(img) +
  geom_point(alpha=0.5, aes(colour = result))+ ylim(-45,0) +  #xlim(-23,23)+
  # scale_color_viridis(discrete=TRUE, labels = c('Shot made', 'Shot missed', 'Basket'))+
  scale_color_discrete(labels = c('Shot made', 'Shot missed', 'Basket'))+
  scale_color_manual(values = c("red", "#440154FF", "#FDE725FF"))+
  theme_bw(base_size = 20, base_line_size = 15/20) +
  theme(panel.grid=element_blank(), panel.border=element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.text.y=element_blank(),  #remove y axis labels
        axis.ticks.y=element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.title = element_blank(),
        legend.position="right")+
  annotate("point", x = 0, y = -41.75, colour = "red", size = 8, alpha = 0.5)  #+
# annotate("point", x = 0, y = 0, colour = "blue") +
# annotate("point", x = -22, y = -41.75, colour = "blue") +
# annotate("point", x = 22, y = -41.75, colour = "blue")

