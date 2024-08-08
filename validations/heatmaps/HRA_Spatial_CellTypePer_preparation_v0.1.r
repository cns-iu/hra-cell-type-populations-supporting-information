library(plyr)
library(dplyr)
library(magrittr)
library(stringr)

metadata <- read.csv("./heatmaps/spatial/hra-pop-spatial_dataset_meta.csv",
                 header = T)
# Data path
path <- paste0("https://raw.githubusercontent.com/cns-iu/hra-ct-summaries-mx-spatial-data/main/intestine_omap_2_0001/cell_type_counts/")

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

# Save data
write.csv(data_as_ct, file="./heatmaps/spatial/HRApop_Spatial_OASCT_CellCount_Percentage.csv", row.names = F)
