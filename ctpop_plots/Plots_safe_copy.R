# load required libraries
library(tidyverse)
library(scales) #for scatter graph
library(ggrepel) # to jitter labels
library(networkD3) #for Sankey
library(RColorBrewer) # for plots
library(ggcorrplot) # for tissue block similarity matrix
library(lsa) # for tissue block similarity matrix

# load other scripts
source("DataPreparation.R")
source("Themes.R")

# Fig. 2 b scatter graph

g <- ggplot(data = scatter, aes(
  x = tissue_block_volume, y = total_per_tissue_block, 
  color=organ, 
  # shape=source,
  size=unique_CT_for_tissue_block*5
  ))+
  geom_point(
    alpha=.85
    )+
  facet_wrap(~source)+
  # facet_grid(vars(source), vars(organ))+
  geom_text_repel(aes(x = tissue_block_volume, y = total_per_tissue_block, label=unique_CT_for_tissue_block),
                  size=9,
                  outline="black",
                  alpha=.5,
                  max.overlaps = getOption("ggrepel.max.overlaps", default = 10),) +
  guides(
    color = guide_legend( title = "Organ", override.aes = list(size = 10)),
    shape= guide_legend( title = "Source", override.aes = list(size = 10)),
    size = guide_legend( title = "Number of \nunique cell \ntypes per \ntissue block")
    )+
   # scale_color_brewer(type="qual",palette=1,direction=-1)+
  scale_color_brewer(palette="Paired")+
  # scale_fill_fermenter()
  ggtitle("Total number of cells per tissue block over volume")+
 labs(y = "Total number of cells per tissue block", x = "Volume of tissue block")+
scatter_theme+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'))+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))
  # theme_cyberpunktheme

g + scatter_theme

# Fig. 2a Sankey diagram

# reformat data we we get source|donor_sex|organ
# need two tibbles: 
# NODES with NodeId
# LINKS with Source, Target, Value

subset_sankey = cols_renamed %>% 
  select(source, donor_sex, organ, excluded) %>% 
  filter(excluded==FALSE) %>%
  replace_na(list(donor_sex = "unknown")) 

s = subset_sankey %>% 
  group_by(source) %>% summarize()

d = subset_sankey %>% 
  group_by(donor_sex) %>% summarize()

o = subset_sankey %>% 
  group_by(organ) %>% summarize()

unique_name=list()
unique_name = unlist(append(unique_name, c(s, d, o)))
unique_name = list(unique_name)

nodes = as.data.frame(tibble(name = character()))

for(u in unique_name){
  nodes = nodes %>% 
    add_row(name=u)
}

nodes$index <- 1:nrow (nodes) 
nodes

nodes$index = nodes$index-1
nodes

s_o = subset_sankey %>% 
  group_by(source, donor_sex) %>% 
  summarize(count=n()) %>% 
  rename(
    source = source,
    target = donor_sex,
    value=count
  )

d_o = subset_sankey %>% 
  group_by(donor_sex, organ) %>% 
  summarize(count=n()) %>% 
  rename(
    source = donor_sex,
    target = organ,
    value=count
  )

prep_links = as.data.frame(bind_rows(s_o, d_o))
prep_links 

links = prep_links 

# rename node and link tables

names(nodes)[1] = "source"
prep_links = left_join(prep_links, nodes,by="source")

names(nodes)[1] = "target"
prep_links = left_join(prep_links, nodes,by="target")
prep_links

prep_links = prep_links[,c(4,5,3)]
names(prep_links)[1:2] = c("source", "target")
names(nodes)[1] = "name"

# Give a color for each group for brewer.pal(n=10,"Paired") and brewer.pal(n=3,"Dark2")
my_color <- 'd3.scaleOrdinal() .domain([

"Brain",
"Breast", 
"Heart", 
"Kidney", 
"Lung", 
"Prostate", 
"Skin", 
"CxG",
"HuBMAP",
"GTEx",
"Male",
"Female",
"unknown"

]) 

.range([
"#A6CEE3", 
"#1F78B4", 
"#B2DF8A", 
"#33A02C", 
"#FB9A99",
"#E31A1C",
"#FDBF6F",
"#FF7F00",
"#CAB2D6",
"#6A3D9A",
"#1B9E77",
"#D95F02",
"#7570B3"

])'

# draw Sankey diagram
p <- sankeyNetwork(Links = prep_links, Nodes = nodes, Source = "source",
                   Target = "target", Value = "value", NodeID = "name", colourScale = my_color,
                   units = "occurrences", fontSize = 20, nodeWidth = 40)

p


# Fig. 3a (scatter graph block volume)

plot_raw=read_sheet("https://docs.google.com/spreadsheets/d/19ZxHSkX5P_2ngredl0bcncaD0uukBRX3LxlWSC3hysE/edit#gid=0", sheet="Fig2a",skip=0)

s = ggplot(plot_raw, aes(x=number_of_anatomical_structures_as, y=number_of_registrations, size=20, colour=Sex))+
  geom_point()+
  scatter_theme+
  geom_text_repel(aes(x=number_of_anatomical_structures_as, y=number_of_registrations, label=Name),
                  size=4,
                  outline="black",
                  alpha=.5,
                  max.overlaps = getOption("ggrepel.max.overlaps", default = 10),) +
  labs(y = "Total number of tissue block registrations for the organ", x = "Total number of anatomical structures in 3D model")+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'), breaks = seq(0, max(plot_raw$number_of_anatomical_structures_as)+5, by = 20))+
  scale_y_continuous(breaks = seq(0, max(plot_raw$number_of_registrations) + 5, by = 5))+
  scale_colour_brewer(type = "qual", palette = "Dark2")+
  guides(size="none", colour = guide_legend(override.aes = list(size=7)))+
  theme(legend.position = "bottom")
  coord_flip()
  

s + scatter_theme

# Fig 3. b (similarity matrix)
corr <- round(cor(mtcars), 1)
ggcorrplot(corr, method = "circle")
p.mat <- cor_pmat(mtcars)
p.mat

ggcorrplot(corr,
           p.mat = p.mat, hc.order = TRUE,
           type = "lower", insig = "blank"
)

#define vectors
a <- c(23, 34, 44, 45, 42, 27, 33, 34)
b <- c(17, 18, 22, 26, 26, 29, 31, 30)

#calculate cosine similarity
cosine(a, b)



# Fig. 4a bar graph for CTPop (AS) 
# load data
cells_raw = read_csv("data/cell_locations_ctpop_VH_F_Kidney_L_0603.csv")

# rename AS
cells_raw = cells_raw %>% mutate(
  `anatomical structure`  = str_replace(`anatomical structure` , 'VH_F_renal_pyramid_L_a', 'Renal Pyramid A'),
  `anatomical structure`  = str_replace(`anatomical structure` , 'VH_F_renal_pyramid_L_b', 'Renal Pyramid B'),
  `anatomical structure`  = str_replace(`anatomical structure` , 'VH_F_renal_pyramid_L_h', 'Renal Pyramid H'),
  `anatomical structure`  = str_replace(`anatomical structure` , 'VH_F_outer_cortex_of_kidney_L', 'Cortex'),
  )

s = ggplot(cells_raw, aes(x = cell_type, fill=cell_type))+
geom_bar(stat = "count")+
  facet_wrap(~`anatomical structure`, ncol=1)+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  # scale_fill_brewer(palette = "Spectral")+
  scale_fill_viridis_d(option = "turbo")+
  labs(x = "Cell Type", y = "Cell Count", title = "Cell type distribution for four AS in female, left Kidney", fill="Cell Type")

s + bar_graph_theme

# get colors assigned by scale_fill_viridis_d
colors = viridis_pal(option = "turbo")(length(unique(cells_raw$cell_type)))
cells = cells_raw %>% group_by(cell_type) %>% tally()
mapping = cells %>% mutate(colors = colors)
mapping
mapping %>% write_csv("color_mapping.csv")
mapping %>% view()

# frequency per top 10 most frequent cell type
# top_10 = cells_raw %>% group_by(cell_type, `anatomical structure`) %>% tally()
top_10 = cells_raw %>% group_by(cell_type) %>% tally()
top_10 = top_10[order(top_10$n, decreasing = TRUE),] %>% head(10) %>% arrange(cell_type) %>% mutate(outline="red")
top_10

top_10_with_colors = top_10 %>% left_join(mapping, by="cell_type")
top_10_with_colors

# cc <- with_frequency %>% count (cell_frequency) %>% filter (n<30) 
# cc

f = ggplot(top_10_with_colors, aes(x = cell_type, y=n.x, fill=colors, color=outline))+
  geom_bar(stat = "identity", linewidth=3)+
  scale_fill_identity()+
  scale_color_identity()+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  # scale_fill_brewer(type="qual", palette = "Paired")+
  labs(x = "Cell Type", y = "Cell Count", title = "Top 10 cell types in cortex of female, left kidney", fill="Cell Type")

f+ bar_graph_theme+
  theme(axis.text.x = element_text(size=15), legend.text = element_text(size=15))





