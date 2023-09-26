# load required libraries
library(tidyverse)

# load other scripts
source("themes.R")

# load data
v5 = read_csv("../data/reports/validation-v5.edges.csv")

# plot
p = ggplot(v5, aes(x=similarity, y=distance, color=organB))+
  # facet_grid(organA~organB)+
  facet_wrap(~organA)+
  geom_point()+
  labs(x = "Cosine similarity", y="Distance (in mm)", )+
  guides(
    color=guide_legend(title="Target organ")
    )+
  theme(
    legend.position = "bottom",
    legend.text = element_text(size=10),
    strip.text = element_text(size=15),
    plot.title = element_text(size=15)
  )+
  ggtitle("V5: Cosine Similarity vs. Distance")
  
p
