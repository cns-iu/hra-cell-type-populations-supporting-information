## Environment set-up
library(tidyr)
library(dplyr)
library(stringr)
#library(umap)
library(uwot)
library(ggplot2)
library(gridExtra)

# Get path to working directory
dir <- getwd()
# Sets path for saving to data directory
path <- paste0(dir,"/data/")

## Data Load
data <- read.csv("https://raw.githubusercontent.com/x-atlas-consortia/hra-pop/main/output-data/v0.5/reports/atlas/validation-v5.csv",
                  header=T, sep=",")

## Update to data strings
# Organs
data$organ <- stringr::str_to_title(data$organ)
data$organ <- stringr::str_replace(data$organ,"Set Of ","")
data$organ <- stringr::str_replace(data$organ,"In","in")
data$organ <- stringr::str_replace(data$organ,"Of","of")

# Tools
data$tool <- stringr::str_to_title(data$tool)

# Optional updates
# data$organ <- stringr::str_replace(data$organ,"Left Kidney","Kidney")
# data$organ <- stringr::str_replace(data$organ,"Right Kidney","Kidney")
data$organ <- stringr::str_replace(data$organ,"Left ","")
data$organ <- stringr::str_replace(data$organ,"Right ","")

## Factoring data
data$consortium_name <- factor(data$consortium_name)
data$dataset <- factor(data$dataset)
#data$tool <- as.factor(data$tool)
data$modality <- factor(data$modality)
# Organ levels may change with updates to data.
org_levels <- 
    c("Heart","Respiratory System",
      "Skin of Body","Lactiferous Glands in Breast",
      "Liver","Spleen","Small intestine","Large intestine","Mesenteric Lymph Node",
      "Kidney","Ureter","Urinary Bladder","Male Reproductive System") 
data$organ <- factor(data$organ, levels=org_levels)
data$organId <- factor(data$organId)
data$reported_organ <- factor(data$reported_organ)
data$cell_id <- factor(data$cell_id)
data$cell_label <- factor(data$cell_label)

## Extract Data Set - Unique features
# Includes the dataset identifier, consortium_name, organ, and organID, 
# modality, and rui_location_volume
dataB <- unique(data[,c(2,1,5:7,4,8)]) 

## Creates a concatenated string of tools used in cell type analysis
dataT <- data %>% 
  select(dataset, tool) %>%
  unique() %>%
  group_by(dataset) %>%
  summarise(tools = str_flatten_comma(tool)) %>%
  ungroup()

# Factor tool sets in data (may change with updates to data)
dataT$tools <- factor(dataT$tools, 
                      levels=c("Azimuth, Celltypist, Popv",
                               "Celltypist, Popv",
                               "Azimuth","Popv","Spatial"))

## Join dataB set features with tool lists
dataB <- left_join(dataB,dataT,by="dataset")
# Re-order columns
dataB <- dataB[,c(1:5,8,6,7)]

## Creates wide pivot data frame using cell type identifiers
## with values taken from percentage
dataP <- pivot_wider(data[, c(2,9,12)], 
                    names_from = c(cell_id), 
                    values_from=percentage, 
                    values_fn = min,
                    values_fill=0)

## Join dataB with pivot results
dataB <- left_join(dataB,dataP,by="dataset")

## Clean up
rm(dataP,dataT)

## Save results of data processing
write.csv(dataB,file=paste0(path,"hra-celltypepops_dataset_wide.csv"),
          row.names = F)

## UMAP Analysis
# UMAP package
# dataW.UMAP <- umap::umap(dataB[,-c(1:7)], 
#                          method="naive",
#                          config = umap.defaults)
# UWOT Package
dataB.UMAP <- uwot::umap(dataB[,-c(1:7)],
                         n_neighbors = 10,
                         n_components = 2,
                         metric="manhattan",
                         init="agspectral",
                         verbose=T)

# Extract layout
dataW.U.L <- dataW.UMAP$layout %>%
                as.data.frame()%>%
                rename(UMAP1="V1",
                       UMAP2="V2") # %>%
  # mutate(ID=row_number())%>%        #Example of adding back categorical data
  # inner_join(penguins_meta, by="ID")#variables for cluster identification

dataW.U.L <- cbind(dataB,dataW.U.L)

p1 <- dataW.U.L %>%
        ggplot(aes(x = UMAP1, 
                   y = UMAP2)) +
        geom_jitter(width=.75,
                    height=.75,
                    aes(color=organ)) +
        labs(x = "UMAP1",
             y = "UMAP2",
             subtitle = "UMap Plot") +
        theme_bw() +
        theme(legend.position = "none")

p2 <- dataW.U.L %>%
        ggplot(aes(x = UMAP1, 
                 y = UMAP2)) +
          geom_jitter(width=.75,
                      height=.75,
                      aes(color=organ)) +
          facet_wrap(organ ~ .) +
          labs(x = "UMAP1",
               y = "UMAP2",
               color="Organ",
               subtitle = "Faceted by Organ") +
          theme_bw()

# Combines plots into a single figure
grid.arrange(p1,                               # umap w/o facets
             p2,                               # facet plot + legend
             ncol = 6, nrow = 1, 
             layout_matrix = rbind(c(1,1,2,2,2,2)))
