#### Environment Set-up ####
library(plyr)
library(dplyr)
library(magrittr)
library(stringr)

options(scipen = 999)

#### Load Data ####
##### Anatomical Structure Metadata ####
# Metadata path for validation scripts
path_validation <- paste0("./validations/")

metadata <- read.csv(paste0(path_validation,"heatmaps/spatial/hra-pop-spatial_dataset_meta.csv"),
                 header = T)

##### Spatial Cell Summaries ####
# Data path
path <- paste0("https://raw.githubusercontent.com/cns-iu/hra-ct-summaries-mx-spatial-data/refs/heads/main/intestine_omap_2_0001/cell_type_counts/")

# data frame for cell counts
data <- data.frame(hubmap_id = as.character(),
                   cell_type=as.character(),
                   count=integer())

for(i in 1:nrow(metadata)){
  tmp <- read.csv(paste0(path,metadata[i,]$hubmap_id,".csv"))
  tmp$hubmap_id <- metadata[i,]$hubmap_id
  data <- rbind(data,tmp)
  rm(tmp)
}

# Combine cell type count observations with metadata.
data <- left_join(data,metadata,by="hubmap_id")
str(data)

#### Prepare Spatial Data ####
# Calculate stats across organs + as
# AS Cell Counts
data_as <-
  data %>%
  ddply(.(organ_label, uberon_id, as), summarise,
        total_cell_count = sum(count))

# AS+Cell Type Cell Counts
data_as_ct <-
  data %>%
  ddply(.(organ_label, uberon_id, as, cell_type), summarise,
        datasets = length(hubmap_id),
        cell_count = sum(count),
        mean_cell_count = mean(count))

# Combine organ + as + Cell type count results
data_as_ct <- left_join(data_as_ct,data_as, by=c("organ_label","uberon_id","as"))

# Calculate cell type percentage
data_as_ct$percentage <- round(data_as_ct$cell_count/data_as_ct$total_cell_count,5)

# Update Organ Labels
data_as_ct$organ_label <- str_replace(data_as_ct$organ_label,"LI","Large Intestine")
data_as_ct$organ_label <- str_replace(data_as_ct$organ_label,"SI","Small Intestine")
data_as_ct$tool <- "Spatial"

#### Export Data Preparation Results ####
# Save data
write.csv(data_as_ct, 
          file=paste0(path_validation,"heatmaps/spatial/HRApop_Spatial_OASCT_CellCount_Percentage.csv"), row.names = F)
