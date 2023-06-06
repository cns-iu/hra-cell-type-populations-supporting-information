# load required libraries
library(tidyverse)
library(scales) #for scatter graph
library(ggrepel) # to jitter labels
library(networkD3) #for Sankey
library(RColorBrewer) # for plots
library(ggcorrplot) # for tissue block similarity matrix
library(lsa) # for tissue block similarity matrix

# load other scripts
source("Plots_basic.R")

# Fig. 4a ALTERNATIVE with outlines, bar graph for CTPop (AS) 

all = cells_raw%>% group_by(cell_type, anatomical_structure) %>% tally() %>% mutate(outline="black") 
only_top = all %>% arrange(desc(n)) %>% head(10)%>% mutate(outline="red")

all
only_top

plot = all %>% left_join(only_top, by=c("cell_type", "anatomical_structure"))

color_array = viridis_pal(option = "turbo")(length(unique(plot$cell_type)))
color_array

mapping = tibble(color_array, unique(plot$cell_type)) %>% rename(cell_type=`unique(plot$cell_type)`)
mapping
mapping %>% write_csv("color_mapping.csv")

p = ggplot(plot, aes(x = cell_type, y=n.x, fill=cell_type, color=outline.y))+
  geom_bar(stat = "identity", linewidth=1.5)+
  facet_wrap(~anatomical_structure, ncol=1)+
  scale_color_identity()+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  # scale_fill_brewer(palette = "Spectral")+
  scale_fill_viridis_d(option = "turbo")+
  labs(x = "Cell Type", y = "Cell Count", title = "Cell type distribution for four AS in female, left Kidney", fill="Cell Type")

p+
  bar_graph_theme

# var graph showing frequency per top 10 most frequent cell type (all in cortex)
# top_10 = cells_raw %>% group_by(cell_type, `anatomical structure`) %>% tally()
top_10 = cells_raw %>% group_by(cell_type) %>% tally()
top_10 = top_10[order(top_10$n, decreasing = TRUE),] %>% head(10) %>% arrange(cell_type) %>% mutate(outline="red")
top_10

top_10_with_colors = top_10 %>% left_join(mapping, by=c("cell_type"))
top_10_with_colors

p = ggplot(top_10_with_colors, aes(x = cell_type, y=n, fill=color_array, color=outline))+
  geom_bar(stat = "identity", linewidth=2)+
  scale_fill_identity()+
  scale_color_identity()+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  # scale_fill_brewer(type="qual", palette = "Paired")+
  labs(x = "Cell Type", y = "Cell Count", title = "Top 10 cell types in cortex of female, left kidney", fill="Cell Type")

p+ bar_graph_theme+
  theme(axis.text.x = element_text(size=15), legend.text = element_text(size=15))





