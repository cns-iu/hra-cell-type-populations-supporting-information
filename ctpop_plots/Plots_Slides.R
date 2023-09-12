# load required libraries
library(tidyverse)
library(scales) #for scatter graph and bar graph
library(ggrepel) # to jitter labels
library(networkD3) #for Sankey
library(RColorBrewer) # for plots
library(ggcorrplot) # for tissue block similarity matrix
library(lsa) # for tissue block similarity matrix

# load other scripts
source("Themes.R")
raw=read_sheet("https://docs.google.com/spreadsheets/d/10c6IZs2kYZj3zxaFgdbCn7P_46yCS701l4X08Ynvj3A/edit#gid=0", sheet="Bar Graph",skip=0)
raw

group.colors <- c(CT1 = "#2196F3", CT2 = "#E91E63", CT3 ="#FFEB3B", CT4 = "#e34a33", CT5 = "#00BCD4", CT6 = "#FFCDD2")

g = ggplot(raw, aes(x = as, y=count, fill=ct))
g+ geom_bar(stat = "identity")+
  labs(x="Anatomical Structure", y='Cell Count', fill='Cell Types')+
  scale_fill_manual(values=group.colors)+
  scale_x_discrete(limits = rev, labels=c("Outer Cortex", "Kidney Pyramid A", "Corridor"))+
  theme(
    axis.title = element_text(size=20),
    axis.text = element_text(size=20),
    legend.text = element_text(size = 15),
    legend.title = element_text(size = 15)
    )
