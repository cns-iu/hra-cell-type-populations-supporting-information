#Load the required libraries
library(googlesheets4)
library(jsonlite)

# load data
# When Table S1 is done, point to https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/edit#gid=1613620962
# table_s1=read_sheet("https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/edit#gid=858511750", sheet = "Table S1 DRAFT", skip=0)

# using hra-pop
table_s1 = read_csv("../../hra-pop/output-data/v0.3/reports/atlas/table-s1.csv")

#left-over code, needs to be cleaned
# number of tissue blocks with RUI but without CT info; 643 on March 9, 2023
# cols_renamed %>%
#   # select(-cta, -omap_id) %>%
#   select(-omap_id) %>%
#   filter(!is.na(tissue_block_volume), is.na(number_of_cells_total)) %>% 
#   group_by(HuBMAP_tissue_block_id)
# 
# # replace NA in excluded col with FALSE
# vars.to.replace <- c("excluded_from_atlas_construction")
# df2 <- cols_renamed[vars.to.replace]
# df2[is.na(df2)] <- FALSE
# cols_renamed[vars.to.replace] <- df2