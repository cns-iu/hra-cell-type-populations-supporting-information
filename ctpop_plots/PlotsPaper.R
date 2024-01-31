# if needed, install required libraries
source("InstallDependencies.R")

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

# global variables
hra_pop_version = "0.5.1"

# set up color palettes
# extend Brewer color palettes
nb.cols <- 16
cat_colors <- colorRampPalette(brewer.pal(12, "Paired"))(nb.cols)

# or extend Brewer color palettes
# cat_colors = c(brewer.pal(name="Paired", n = 12), brewer.pal(name="Dark2", n = 3))

# Fig. ASpop bar graph for CTPop (AS) 
# load data
cells_raw = read_csv("data/cell_locations_ctpop_VH_F_Kidney_L_0603.csv")

# rename AS
cells_raw = cells_raw %>%rename(anatomical_structure =  `anatomical structure`) %>%  mutate(
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_renal_pyramid_L_a', 'Renal Pyramid A'),
  anatomical_structure  = str_replace(anatomical_structure , 'VH_F_outer_cortex_of_kidney_L', 'Cortex'),
)

# draw plot
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

# Fig. ASpop ALTERNATIVE with outlines, bar graph for CTPop (AS) 

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



# Fig. SankeyScatter Sankey diagram

# reformat data we we get portal|donor_sex|organ
# need two tibbles: 
# NODES with NodeId
# LINKS with Source, Target, Value

# NEEDS TO BE UPDATED TO USE HRA-POP REPORT TABLE-S1 INSTEAD
table_s1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/table-s1.csv", sep = ""))

subset_sankey = table_s1 %>% 
  select(portal, donor_sex, organ_name, cell_type_annotation_tool, omap_id) %>% 
  replace_na(list(donor_sex = "unknown")) %>% 
  # unify left and right kidney
  mutate(organ_name = ifelse(organ_name == "left kidney" | organ_name == "right kidney", "kidney", organ_name))


p = subset_sankey %>% 
  group_by(portal) %>% summarize()

d = subset_sankey %>% 
  group_by(donor_sex) %>% summarize()

o = subset_sankey %>% 
  group_by(organ_name) %>% summarize()

c = subset_sankey %>% 
  group_by(cell_type_annotation_tool) %>% summarize()

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
  group_by(organ_name, cell_type_annotation_tool) %>% 
  summarize(count=n()) %>% 
  rename(
    source = organ_name,
    target = cell_type_annotation_tool,
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


# Fig. SankeyScatter scatter graph
scatter = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/validation-v5.csv", sep=""))

# unify left vs right kidney
scatter = scatter %>% mutate(organ = ifelse(organ == "right kidney", "kidney", organ))
scatter = scatter %>% mutate(organ = ifelse(organ == "left kidney", "kidney", organ))
scatter = scatter %>% mutate(
  consortium_name = ifelse(consortium_name == "HCA", "Heart Cell Atlas v2", consortium_name)
)

# show datasets, not data-CT pairs
scatter = scatter %>%  group_by(dataset) %>%
  mutate(total_cells = sum(cell_count))

scatter = scatter %>% group_by(dataset) %>% 
  mutate(distinct_cell_types = n_distinct(cell_id))

scatter = scatter %>% select(consortium_name, dataset, rui_location_volume, total_cells, distinct_cell_types, modality, organ) %>% distinct()

g = ggplot(scatter, aes(x = rui_location_volume, y=total_cells, shape = modality, color=organ,  size=distinct_cell_types))+
  geom_jitter(width=.1, alpha=.7)+
  # scale_color_brewer(palette = "Paired")+
  scale_color_manual(values = cat_colors)+
  # geom_point(alpha = .8)+
  facet_wrap(~consortium_name, ncol=1)+
  # geom_point()+
  guides(
    color = guide_legend( title = "Tissue Block Volume")
  )+
  ggtitle("Total number of cells per dataset over volume")+
  labs(y = "Total number of cells per dataset", x = "Volume of tissue block (cubic mm)", size="Distinct Cell Types", caption = "Note that for spatial skin tissue blocks, datasets are derived from a section, with one dataset per section, aggregated to one tissue block.")+
  scatter_theme+
  scale_x_continuous(trans = "log10", labels = scales::number_format(decimal.mark = '.'))+
  scale_y_continuous(trans = "log10", labels=scales::number_format(decimal.mark = '.'))+
  guides(
    color = guide_legend(title="Organ", override.aes = list(size = 5)),
    shape = guide_legend(title = "Modality",override.aes = list(size = 5)),
    ) +
  theme(
    legend.text = element_text(size=11.5),
    panel.background  = element_rect(fill = "#606060"),
    panel.grid.minor.x = element_blank(),
    legend.key = element_rect(fill = "#606060")
  )
g


# Fig. ASCoverageTissueBlockSimilarity. (scatter graph block volume)
plot_raw = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/figure-f4.csv", sep=""))

# unify kidney
# plot_raw = plot_raw %>% mutate(organ= ifelse(organ == "left kidney" | organ == "right kidney", "kidney", organ))

# pseudo bar graph
p = ggplot(plot_raw, aes(y = organ, color=organ))+
  geom_segment(linewidth=5, aes(x=0, xend = organ_as_count_with_collisions, yend=organ))+
  geom_segment(linewidth=2, aes(x= organ_as_count_with_collisions, xend = total_organ_as_count, yend=organ))+
  geom_point(aes(x = organ_as_count_with_collisions, size=non_atlas_dataset_count), color="black")+
  geom_point(aes(x = total_organ_as_count), color="black", shape=15, size=4)+
  geom_text(aes(x=organ_as_count_with_collisions, label=non_atlas_dataset_count), color="black", vjust=-1)+
  # scale_color_brewer(palette = "Paired")+
  scale_x_continuous(trans = "log10")+
  scale_color_manual(values=cat_colors)+
  facet_grid(modality~sex)+
  labs(x="Unique UBERON IDs in Organ Model", y="Organ", size="Non-atlas datasets")+
  guides(
    color=guide_legend(
      title = "Organ"
    )
  )+
  theme(
    legend.position = "bottom",
    axis.text = element_text(size=15),
    strip.text = element_text(size=15),
    legend.text = element_text(size=15),
    axis.title = element_text(size=15)
  )
  
p

# Fig ASCoverageTissueBlockSimilarity.  (UMAP, add Michael Ginda's code, see his branch [may already be here])





# Fig. ValidationApplicationResults

# unique extraction site and tissue blocks for which we apply US#1 and US#2

a1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/application-a1.csv", sep=""))
a1$sample %>% unique() %>% length()

a2p1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/application-a2p1.csv", sep=""))
a2p1$dataset %>% unique() %>% length()

# validations
v2p1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/validation-v2p1.csv", sep=""))
v2p1

t = v2p1 %>% filter(as_in_collisions == TRUE)
f = v2p1 %>% filter(as_in_collisions == FALSE)

summary(t$similarity)
summary(f$similarity)

t.test(t$similarity,f$similarity)

vis = v2p1
vis

line = data.frame(as_in_collisions = as.character(unique(vis$as_in_collisions)), z = c(mean(t$similarity),mean(f$similarity)))

g = ggplot(vis, aes(x = organ, y=similarity))+
  geom_violin(scale="width", aes(fill=organ))+
  scale_fill_manual(values=cat_colors, guide_legend(position="bottom"))+
  # geom_jitter(shape=1, alpha=.1, aes(color=organ))+
  facet_grid(as_tool~as_in_collisions)+
  geom_hline(data=line, aes(yintercept = z))+
  theme(
    axis.text.x = element_text(angle=90)
  )+
  labs(y="Cosine Similarity", x="Organ", title = "Cosine Similarity and True/False Prediction by Organ")
  
g 

# Supplemental Fig. AS-TB-InterVolumes

intersections = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/table-s5.csv", sep=""))
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
   geom_hline(yintercept = 1, color="white", linetype="dashed", linewidth=1.5)+
   # scale_color_brewer(palette = "Paired")+
   scale_color_manual(values = cat_colors)+
   scale_y_continuous(breaks = seq(0, max(g$total_collision_percentage), by = .25))+
   labs(x = "Number of Mesh-Based Collisions with Unique Anatomical Structures", 
        y = "Total Collision Percentage", 
        title = "Total Intersection Percentage between Atlas Extraction Sites and Anatomical Structures (Jittered)", 
        color="Organ",
        caption = "Note that some tissue blocks collide with anatomical structures that are themselves intersecting, thus counting the intersection percentage of the extraction site twice.\n This leads to some extraction sites having a total collision percentage >1. Horizontal jitter has been applied"
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

# Supplemental Fig. DatasetsPerASWithModality: Bar graph for datasets per AS with modality
datasets_per_as = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/as-datasets-modality.csv", sep="")) %>% 
  arrange(as_label)


# count datasets per organ
datasets_per_as = datasets_per_as %>% group_by(organ_label) %>% unique()

p = ggplot(datasets_per_as, aes(x=as_label, fill=modality))+
  geom_bar(stat = 'count', position = "stack")+
  scale_fill_discrete(labels = c("single-cell bulk",
                                 "spatial"))+
  facet_grid(. ~ organ_label, scales = "free_x", space = "free_x")+
  scale_y_continuous(trans = "log10")+
  labs(
    title = 'Datasets per Anatomical Structure and Modality', x = "Anatomical Structure", y="Number of Datasets", fill="Modality"
    )+
  guides(
    legend
  ) + scatter_theme +
  theme(
    strip.text = element_text(size=10),
    axis.text.x = element_text(hjust=1, size=11),
    axis.text.y = element_text(hjust=1, size=11),
    strip.background = element_blank(), 
    strip.placement = "outside",
    strip.text.x = element_text(angle = 90, size=11)
  )
p

# Supplemental Fig. ASHeteroHomo: Visualizing hetero-/homogeneity
data = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/figure-as-as-sim.csv", sep=""))
data

# unify left/right kidney
data = data %>% mutate(organ = ifelse(organ == "right kidney", "kidney", organ))
data = data %>% mutate(organ = ifelse(organ == "left kidney", "kidney", organ))
data = data %>% mutate(organ = ifelse(organ == "male reproductive system", "prostate", organ))

# take subset for lung only
lung = data %>% filter(organ=="respiratory system")
# lung = data

# plot 1: as heat map
# Note: as-as cosine sims are NOT shown if:
# - no shared cell exists (cosine_sim == 0)
# - if AS is compared with itself

reverse = lung %>% group_by(as1_label, as2_label) %>% select(as1_label, as2_label, cosine_sim) %>% unique() %>% mutate(
  as1_label_TEMP= as1_label,
  as2_label_TEMP= as2_label,
  as1_label = as2_label_TEMP,
  as2_label = as1_label_TEMP
) %>% select(-contains("TEMP"))

vis =  bind_rows(lung, reverse)


# ADD COSINE SIMS FOR SAME AS IN R: https://github.com/x-atlas-consortia/hra-pop/issues/31 
unique_as = c(unique(lung$as1_label), unique(lung$as2_label)) %>% unique()
unique_as

same <- tibble(as1_label = unique_as, as2_label = unique_as, cosine_sim = 1)
colnames(same) <- c("as1_label", "as2_label", "cosine_sim")
same

vis = bind_rows(vis, same)

g = ggplot(vis, aes(as1_label, as2_label))+
  geom_tile(aes(fill=cosine_sim))+
  # scale_fill_gradientn(colours = c("yellow","pink","purple","blue"),
  #                        values = c(0, 0.31, 0.51, 0.7, 1.0),
  #                      breaks = c(0, 0.31, 0.51, 0.7, 1.0)) +
  
  # scale_fill_gradient(low = "yellow", high = "blue",breaks = c(0.3, 0.5, 0.7), labels = c("Below 0.3","0.31-0.5", "51-0.7"))+
  
  # scale_fill_gradient(low = "yellow", high = "blue", midpoint = mean(vis$cosine_sim))+
  
  scale_fill_stepsn(colors =c("yellow", "pink", "purple", "blue"),
                   breaks = c(.31, .51, .71, 1),
                   labels = c("Less than or equal to 0.30", "Between 0.31 and 0.5", "Between 0.5 and 0.7", "Greater than 0.7"),
                   limits = c(0, 1))+
  
  
  geom_text(aes(label =sprintf("%.2f", cosine_sim)), size = 3, color="black")+
  # facet_grid(modality ~ organ, scales = "free_x", space = "free_x")+
  labs(
    x = "Anatomical Structure", y = "Anatomical Structure"
  )+
  guides(
    fill = guide_legend(
      title="Cosine Similarity"
    )
  )+
  theme(
    axis.text.x = element_text(angle=90, vjust = .3),
  )
g

# plot 2: as scatter histogram
g = ggplot(lung, aes(x = cosine_sim, color=organ))+
  # geom_point()+
  geom_histogram()+
  scale_color_brewer(palette = "Paired")+
  facet_wrap(modality~organ)
g
