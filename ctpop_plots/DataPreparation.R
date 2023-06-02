#Load the required libraries
library(googlesheets4)

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