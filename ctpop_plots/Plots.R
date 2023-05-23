#Load the required libraries
library(googlesheets4)
library("tidyverse")
library(scales) #for scatter graph
library(ggrepel) # to jitter labels
library(networkD3) #for Sankey
library(RColorBrewer) # for plots

# load data
# raw = read_sheet('https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/edit#gid=0', skip=1)
raw=read_sheet("https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/edit#gid=1529271254", sheet="Training/Prediction",skip=0)

# rename columns
cols_renamed = raw %>% 
  rename(
    tissue_block_volume= `tissue_block_volume (if registered) [millimeters^3]`,
    # cta = `cta... (Azimuth, popV, Ctypist)`,
    rui_organ = `rui_organ (if registered)`
  )
cols_renamed

# number of tissue blocks with RUI but without CT info; 643 on March 9, 2023
cols_renamed %>%
  # select(-cta, -omap_id) %>%
  select(-omap_id) %>%
  filter(!is.na(tissue_block_volume), is.na(number_of_cells_total)) %>% 
  group_by(HuBMAP_tissue_block_id)

# replace NA in excluded col with FALSE
vars.to.replace <- c("excluded")
df2 <- cols_renamed[vars.to.replace]
df2[is.na(df2)] <- FALSE
cols_renamed[vars.to.replace] <- df2

# format data for scatter graph
# Hubmap: 128
scatter_hubmap = cols_renamed%>% 
  select(source,paper_id,organ,excluded,sample_id, rui_organ, HuBMAP_tissue_block_id, number_of_cells_total, tissue_block_volume, omap_id, unique_CT_for_tissue_block) %>% 
  filter(excluded!="TRUE", source=="HuBMAP") %>% 
  group_by(
    source,
    HuBMAP_tissue_block_id, 
    sample_id,
    tissue_block_volume, 
    unique_CT_for_tissue_block,
    paper_id,
    organ
    ) %>% 
  summarise(total_per_tissue_block = sum(as.double(unlist(number_of_cells_total))))

# NEED DIFFERENT PROCESS TO GET COUNTS FOR NON-HUBMAP TISSUE BLOCKS, needs to be 25 TOTAL!
scatter_cxg = cols_renamed%>% 
  select(source,dataset_id,paper_id,organ,excluded,sample_id, rui_organ, HuBMAP_tissue_block_id, number_of_cells_total, tissue_block_volume, non_hubmap_donor_id, omap_id, unique_CT_for_tissue_block, CxG_dataset_id_donor_id_organ, unique_CT_for_tissue_block) %>% 
  filter(excluded!="TRUE", source=="CxG") %>% 
  group_by(
    # dataset_id,
    # non_hubmap_donor_id,
    # organ,
    CxG_dataset_id_donor_id_organ,
    unique_CT_for_tissue_block,
    tissue_block_volume,
    organ
  ) %>% 
  # unique()
  summarise(total_per_tissue_block = sum(as.double(unlist(number_of_cells_total)))) %>% 
  add_column(source="CxG")

scatter_gtex = cols_renamed%>% 
  select(source,paper_id,organ,excluded,sample_id, rui_organ, HuBMAP_tissue_block_id, number_of_cells_total, tissue_block_volume, dataset_id, omap_id, unique_CT_for_tissue_block) %>% 
  filter(excluded!="TRUE", source=="GTEx") %>% 
  group_by(
    dataset_id,
    unique_CT_for_tissue_block,
    tissue_block_volume,
    organ
  ) %>% 
  summarise(total_per_tissue_block = sum(as.double(unlist(number_of_cells_total))))%>% 
  add_column(source="GTEx")

scatter = bind_rows(scatter_hubmap, scatter_gtex, scatter_cxg)

# scatter[scatter$organ%in%c("Kidney (Left)", "Kidney (Right)"),]$organ = "Kidney"
# scatter[scatter$organ%in%c("Lung (Left)", "Lung (Right)"),]$organ = "Lung"

scatter_theme <- theme(
  plot.title = element_text(family = "Arial", face = "bold", size = (35)),
  legend.title = element_text(colour = "black", face = "bold.italic", family = "Arial", size=35),
  legend.text = element_text(face = "italic", colour = "black", family = "Arial", size=25),
  axis.title = element_text(family = "Arial", size = (35), colour = "black"),
  axis.text = element_text(family = "Arial", colour = "black", size = (20)),
  legend.key.size = unit(3,"line"),
  # panel.background =  element_rect(fill = 'black', color = 'black')
) 

# Fig. 1 scatter graph
# We expect to see 2 CxG dots with large unique CT for brain

clr_bg   <- "black"
clr_bg2  <- "gray10"
clr_grid <- "gray30"
clr_text <- "#d600ff"

theme_cyberpunk <- function() {
  theme(
    # Plot / Panel
    plot.background = element_rect(fill = clr_bg, colour = clr_bg),
    # plot.margin = margin(1.5, 2, 1.5, 1.5, "cm"),
    panel.background = element_rect(fill = clr_bg, color = clr_bg),
    # Grid
    panel.grid = element_line(colour = clr_grid, size = 1),
    panel.grid.major = element_line(colour = clr_grid, size = 1),
    panel.grid.minor = element_line(colour = clr_grid, size = 1),
    axis.ticks.x = element_line(colour = clr_grid, size = 1),
    axis.line.y = element_line(colour = clr_grid, size = 0.5),
    axis.line.x = element_line(colour = clr_grid, size = 0.5),
    # Text
    plot.title = element_text(colour = clr_text),
    plot.subtitle = element_text(colour = clr_text),
    axis.text = element_text(colour = clr_text),
    axis.title = element_text(colour = clr_text),
    # Legend
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.title = element_text(colour = clr_text),
    legend.text = element_text(colour = "gray80", size = 12, face = "bold"),
    # Strip
    strip.background = element_rect(fill = clr_bg2, color = clr_bg2)
  )
}

ggplot(data = scatter, aes(
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
                  size=5,
                  color="black",
                  alpha=.5,
                  max.overlaps = getOption("ggrepel.max.overlaps", default = 10),) +
  guides(
    color = guide_legend( title = "Organ", override.aes = list(size = 10)),
    shape= guide_legend( title = "Source", override.aes = list(size = 10)),
    size = guide_legend( title = "Number of unique cell \n types for tissue block")
    )+
   # scale_color_brewer(type="qual",palette=1,direction=-1)+
  scale_color_brewer(palette="Paired")+
  # scale_fill_fermenter()
  ggtitle("Total number of cells per tissue block over volume")+
 labs(y = "Total number of cells per tissue block", x = "Volume of tissue block")+
scatter_theme+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'))+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))
  # theme_cyberpunk

# Fig. 1 Sankey diagram

# reformat data we we get source|donor_sex|organ
# need two tibbles: 
# NODES with NodeId
# LINKS with Source, Target, Value

subset_sankey = cols_renamed %>% 
  select(source, donor_sex, organ) %>% 
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

# draw Sankey diagram
p <- sankeyNetwork(Links = prep_links, Nodes = nodes, Source = "source",
                   Target = "target", Value = "value", NodeID = "name",
                   units = "occurrences", fontSize = 15, nodeWidth = 30)

p


# Fig. 2a

plot_raw=read_sheet("https://docs.google.com/spreadsheets/d/19ZxHSkX5P_2ngredl0bcncaD0uukBRX3LxlWSC3hysE/edit#gid=0", sheet="Fig2a",skip=0)

ggplot(plot_raw, aes(x=number_of_anatomical_structures_as, y=number_of_registrations, size=20))+
  geom_point()+
  scatter_theme+
  geom_text_repel(aes(x=number_of_anatomical_structures_as, y=number_of_registrations, label=Organ),
                  size=5,
                  color="black",
                  alpha=.5,
                  max.overlaps = getOption("ggrepel.max.overlaps", default = 10),) +
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'))+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  scatter_theme


# Bar graph for Unity
# load data
cells_raw = read_csv("data/cell_locations_ctpop_VH_F_Kidney_L.csv")
cells_raw

ggplot(cells_raw, aes(x = cell_type, fill=cell_type))+
geom_bar(stat = "count")+
  facet_wrap(~`anatomical structure`)+
  # scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  theme(axis.text.x = element_text(angle=90))


