# scatter graph
scatter_theme <-  theme(axis.text.x = element_text(angle=90, size = 15),
                        axis.text.y = element_text(size = 15),
                        plot.title = element_text(size = 25),
                        axis.title = element_text(size = 20),
                        strip.text = element_text(size=20),
                        legend.title = element_text(colour = "black", face = "bold.italic", family = "Arial", size=20),
                        legend.text = element_text(face = "italic", colour = "black", family = "Arial", size=20),
                        legend.key.size = unit(2,"line"),
)

# bar graph
bar_graph_theme <-  scatter_theme + 
  
  theme(
                        legend.text = element_text(face = "italic", colour = "black", family = "Arial", size=10),
                        legend.key.size = unit(1,"line"),
                        axis.text.x = element_text(hjust=1,vjust=0.2, size=8)
)