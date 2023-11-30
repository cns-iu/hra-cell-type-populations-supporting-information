# load required libraries
library(tidyverse)
library(scales) #for scatter graph and bar graph
library(ggrepel) # to jitter labels
library(networkD3) #for Sankey
library(RColorBrewer) # for plots
library(ggcorrplot) # for tissue block similarity matrix
library(lsa) # for tissue block similarity matrix

#load themes
source("Themes.R")

# load other scripts
# load Table S1
source("DataPreparation.R")

# Fig. 2a bar graph for CTPop (AS) 
# load data
cells_raw = read_csv("data/cell_locations_ctpop_VH_F_Kidney_L_0603.csv")

# rename AS
cells_raw = cells_raw %>%rename(anatomical_structure =  `anatomical structure`) %>%  mutate(
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_renal_pyramid_L_a', 'Renal Pyramid A'),
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_renal_pyramid_L_b', 'Renal Pyramid B'),
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_renal_pyramid_L_h', 'Renal Pyramid H'),
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_outer_cortex_of_kidney_L', 'Cortex'),
)

p = ggplot(cells_raw, aes(x = cell_type, fill=cell_type))+
  geom_bar(stat = "count")+
  facet_wrap(~anatomical_structure, ncol=1)+
  scale_y_continuous(trans = "log10", labels=scales::number_format(big.mark = ",", decimal.mark = '.'))+
  # scale_fill_brewer(palette = "Spectral")+
  scale_fill_viridis_d(option = "turbo")+
  labs(x = "Cell Type", y = "Cell Count", title = "Cell type distribution for four AS in female, left kidney", fill="Cell Type")+
  guides(fill="none")

p + bar_graph_theme

# get colors assigned by scale_fill_viridis_d
colors = viridis_pal(option = "turbo")(length(unique(cells_raw$cell_type)))
cells = cells_raw %>% group_by(cell_type) %>% tally()
mapping = cells %>% mutate(colors = colors)
mapping
mapping %>% write_csv("color_mapping.csv")

# frequency per top 10 most frequent cell type
# top_10 = cells_raw %>% group_by(cell_type, `anatomical structure`) %>% tally()
top_10 = cells_raw %>% group_by(cell_type) %>% tally()
top_10 = top_10[order(top_10$n, decreasing = TRUE),] %>% head(10) %>% arrange(cell_type) %>% mutate(outline="red")
top_10

top_10_with_colors = top_10 %>% left_join(mapping, by="cell_type")
top_10_with_colors

# cc <- with_frequency %>% count (cell_frequency) %>% filter (n<30) 
# cc

p = ggplot(top_10_with_colors, aes(x = cell_type, y=n.x, fill=colors))+
  geom_bar(stat = "identity", linewidth=3)+
  scale_fill_identity()+
  scale_color_identity()+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  # scale_fill_brewer(type="qual", palette = "Paired")+
  labs(x = "Cell Type", y = "Cell Count", title = "Top 10 cell types in cortex of female, left kidney", fill="Cell Type")

p+ bar_graph_theme+
  theme(axis.text.x = element_text(size=15), legend.text = element_text(size=15))

# Fig. 2a ALTERNATIVE with outlines, bar graph for CTPop (AS) 

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
  labs(x = "Cell Type", y = "Cell Count", title = "Cell type distribution for four AS in female, left kidney", fill="Cell Type")+
  guides(fill="none")

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



# Fig. 3a Sankey diagram

# reformat data we we get portal|donor_sex|organ
# need two tibbles: 
# NODES with NodeId
# LINKS with Source, Target, Value

# NEEDS TO BE UPDATED TO USE HRA-POP REPORT TABLE-S1 INSTEAD
subset_sankey = table_s1 %>% 
  select(portal, donor_sex, organ_name, cell_type_annotation_tool, omap_id) %>% 
  replace_na(list(donor_sex = "unknown")) %>% 
  replace_na(list(omap_id = "not_spatial"))

p = subset_sankey %>% 
  group_by(portal) %>% summarize()

d = subset_sankey %>% 
  group_by(donor_sex) %>% summarize()

o = subset_sankey %>% 
  group_by(organ_name) %>% summarize()

c = subset_sankey %>% 
  group_by(omap_id) %>% summarize()

unique_name=list()
unique_name = unlist(append(unique_name, c(p, d, o, c)))
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
  group_by(portal, donor_sex) %>% 
  summarize(count=n()) %>% 
  rename(
    source = portal,
    target = donor_sex,
    value=count
  )

d_o = subset_sankey %>% 
  group_by(donor_sex, organ_name) %>% 
  summarize(count=n()) %>% 
  rename(
    source = donor_sex,
    target = organ_name,
    value=count
  )

c_o = subset_sankey %>% 
  group_by(organ_name, omap_id) %>% 
  summarize(count=n()) %>% 
  rename(
    source = organ_name,
    target = omap_id,
    value=count
  )

prep_links = as.data.frame(bind_rows(s_o, d_o, c_o))
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


# Fig. 3b scatter graph

scatter = read_csv("../../hra-pop/output-data/v0.3/reports/atlas-lq/validation-v5.csv")

scatter = scatter %>% mutate(organ = ifelse(organ == "right kidney", "left kidney", organ))

# show datasets, not data-CT pairs
scatter = scatter %>%  group_by(dataset) %>%
  mutate(total_cells = sum(cell_count))

scatter = scatter %>% group_by(dataset) %>% 
  mutate(distinct_cell_types = n_distinct(cell_id))

scatter = scatter %>% select(consortium_name, dataset, rui_location_volume, total_cells, distinct_cell_types, modality, organ) %>% distinct()

# KATY SHARED NEW COLORS IN EMAIL ON 11/28, SUBJECT LINE: New Fig. 3b
g = ggplot(scatter, aes(x = rui_location_volume, y=total_cells, shape = modality, color=organ,  size=distinct_cell_types))+
  geom_jitter(width=.1, alpha=.7)+
  # geom_point(alpha = .8)+
  facet_wrap(~consortium_name, ncol=1)+
  # geom_point()+
  guides(
    color = guide_legend( title = "Tissue Block Volume")
  )+
  ggtitle("Total number of cells per dataset over volume")+
  labs(y = "Total number of cells per dataset", x = "Volume of tissue block", size="Distinct Cell Types")+
  scatter_theme+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'))+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  theme(
    panel.background  = element_rect(fill = "#606060"),
    panel.grid.minor.x = element_blank(),
    legend.key = element_rect(fill = "#606060")
  )
g


# Fig. 4a (scatter graph block volume)

# plot_raw=read_sheet("https://docs.google.com/spreadsheets/d/19ZxHSkX5P_2ngredl0bcncaD0uukBRX3LxlWSC3hysE/edit#gid=0", sheet="Fig2a",skip=0)
plot_raw = read_csv("../../hra-pop/output-data/v0.3/reports/atlas/figure-f4.csv")

p = ggplot(plot_raw, aes(x=organ_as_count, y=rui_location_count, size=dataset_count, colour=sex))+
  geom_point()+
  # scatter_theme+
  geom_text_repel(aes(x=organ_as_count, y=rui_location_count, label=organ),
                  size=4,
                  color="black",
                  alpha=.5,
                  max.overlaps = getOption("ggrepel.max.overlaps", default = 10),) +
  labs(y = "Total number of tissue block registrations for the organ", x = "Total number of unique UBERON IDs in 3D model")+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'), breaks = seq(0, max(plot_raw$organ_as_count)+5, by = 20))
  # scale_y_continuous(breaks = seq(0, max(plot_raw$number_of_registrations) + 5, by = 5))+
  # scale_colour_brewer(type = "qual", palette = "Dark2")+
  # guides(size="none", colour = guide_legend(override.aes = list(size=7)))+
  # theme(legend.position = "bottom")


p + scatter_theme



# Fig 4.b (UMAP, add Michael Ginda's code)



# Supplemental Fig. S6
intersections = read_csv("../../hra-pop/output-data/v0.3/reports/atlas/table-s5.csv")
intersections

# add sex
more_cols = intersections %>% mutate(
  sex =  case_when(
    grepl("VHF", organ, fixed = TRUE) ~ "Female",
    grepl("VHM", organ, fixed = TRUE) ~ "Male"
    ),
  intersection_ratio = intersection_volume/tissue_block_volume 
)

# add number of rui locations per AS
rui_count = more_cols %>% count (as_id) 
more_cols = merge(more_cols, rui_count, by.x = "as_id")
colnames(more_cols)[colnames(more_cols) == "n"] <- "rui_locations_per_as"

# count AS per TB
with_counts = more_cols %>%  group_by(rui_location) %>% add_count(name = "as_per_rui")

# visualize #As collided with and total intersection volume
g = with_counts %>% select(
  rui_location, as_per_rui, total_collision_percentage, organ_label
)

 p= ggplot(g, aes(x = as_per_rui, y = total_collision_percentage, color=organ_label))+
   geom_jitter(width=.2, size = 4, alpha=.6)+
   # scale_color_discrete()+
   scale_color_brewer(palette = "Set3")+
   # geom_smooth(data = g,aes(x = as_per_rui, y = total_collision_percentage),method = "lm")+
   geom_hline(yintercept = 1, color="red", linetype="dashed", linewidth=1.5)+
   scale_y_continuous(breaks = seq(0, max(g$total_collision_percentage), by = .25))+
   # facet_wrap(~organ_label)+
   labs(x = "Number of Mesh-Based Collisions with Unique Anatomical Structure", 
        y = "Total Collision Percentage", 
        title = "Total Intersection Percentage between Atlas Extraction Sites and Anatomical Structures", 
        color="Organ",
        caption = "Note that some tissue blocks collide with anatomical structures that are themselves intersecting, thus counting the intersection percentage of the extraction site twice.\n This leads to some extraction sites having a total collision percentage >1."
        )+
   theme(
     axis.text.x = element_text(size=15),
     axis.text.y = element_text(size=15),
     axis.title = element_text(size=18),
     legend.text = element_text(size=15),
     legend.title = element_text(size=20),
     panel.background  = element_rect(fill = "#606060"),
     panel.grid.minor.x = element_blank(),
     legend.key = element_rect(fill = "#606060"),
     plot.caption = element_text (hjust=0, size=12)
   )
p

p = ggplot(g, aes(x = as_per_rui, y = intersection_ratio, color=sex))+
  # geom_bar(stat = "identity")+
  geom_jitter(width=.2)+
  # geom_line()+
  # geom_point()+
  # facet_wrap(~organ_label)+
  scale_y_continuous(labels=scales::number_format(decimal.mark = '.'))+
  # scale_color_brewer()+
  scale_color_brewer(type="qual", palette = "Set1")+
  labs(x = "Anatomical Structure", y = "Intersection Volume (cubic mm)", title = "Intersection Volumes between Atlas RUI Locations and Anatomical Structures", fill="Organ", alpha = "Extraction Sites \nper Anatomical Structure")+
  theme(
    axis.text.x = element_text(angle=90, size=15),
    axis.text.y = element_text(size=15),
    axis.title = element_text(size=15),
    legend.text = element_text(size=15),
    legend.title = element_text(size=15)
  )
p


# EXTRA VIS: Bar graph for datasets per AS with modality
datasets_per_as = read_csv("../../hra-pop/output-data/v0.3/reports/atlas/as-datasets-modality.csv")

p = ggplot(datasets_per_as, aes(x=as_label, fill=modality))+
  geom_bar(stat = 'count', position = "stack")+
  facet_wrap(~organ_label, ncol=3)+
  labs(title = 'Datasets per Anatomical Structure and Modality',x = "Anatomical Structure", y="Number of Datasets")+
  guides(
    legend
  ) + scatter_theme +
  theme(
    strip.text = element_text(size=10),
    axis.text.x = element_text(hjust=1, size=10)
  )
p
