load('./data/MIA_all.RData')
# install.packages("viridis")
library(viridis)
library(ggplot2)
library(png)
library(ggpubr)
img <- readPNG("./documents/field.png")
shots <- na.omit(subset(s2005.PbP.MIA, select = c('result', 'xx', 'yy')))
shots <- rbind(shots, c('', 0, - 41.75))
shots$result <- as.factor(as.numeric(shots$result))
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
        legend.title = element_blank())+
annotate("point", x = 0, y = -41.75, colour = "red", size = 8, alpha = 0.5)  #+
# annotate("point", x = 0, y = 0, colour = "blue") +
# annotate("point", x = -22, y = -41.75, colour = "blue") +
# annotate("point", x = 22, y = -41.75, colour = "blue")


