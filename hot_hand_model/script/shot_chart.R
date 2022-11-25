load('./data/MIA_all.RData')

library(ggplot2)
library(png)
library(ggpubr)
img <- readPNG("./documents/field.png")
ggplot(data = s2005.PbP.MIA, aes(xx, yy, color = result))+ background_image(img)+ 
  geom_point(alpha=0.4)+ ylim(-45,0) + #xlim(-23,23)+
  scale_color_manual("Shot",values=c("green", "red"))+
  theme_bw() +
  theme(panel.grid=element_blank(), panel.border=element_blank(),
        axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        axis.text.y=element_blank(),  #remove y axis labels
        axis.ticks.y=element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())
# annotate("point", x = 0, y = -41.75, colour = "blue")  +
# annotate("point", x = 0, y = 0, colour = "blue") +
# annotate("point", x = -22, y = -41.75, colour = "blue") +
# annotate("point", x = 22, y = -41.75, colour = "blue")


