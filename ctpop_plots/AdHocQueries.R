# load libraries
library(tidyverse) 

# global vars
hra_pop_version = "0.8.1"
reports = paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/", sep = "")

# for dataset IDs from Application2, get publications from non-atlas-dataset-graph

# get application2p1 report (computes cosine sim between dataset and AS)
application1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/application-a1.csv", sep=""))
application1%>% select(sample) %>% unique()

application2p1 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/application-a2p1.csv", sep=""))
application2p1%>% select(dataset) %>% unique()

application2p3 = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/reports/atlas/application-a2p3.csv", sep=""))
application2p3%>% select(dataset) %>% unique()


# get non-atlas datasets (many have publications)
non_atlas_dataset_graph = read_csv("../../hra-pop/output-data/v0.5/non-atlas-dataset-graph.csv") 
non_atlas = non_atlas_dataset_graph %>% select(hasPublication,dataset_id, publication, consortium_name) %>% unique()
non_atlas

# create combined tibble with dataset_id and publications
pub_pred = non_atlas %>% mutate(
  has_prediction = ifelse(dataset_id %in% app$dataset, TRUE, FALSE)
)
pub_pred %>% view()

# unique publications in non-atlas-dataset-graph
non_atlas_dataset_graph$publication %>% unique() %>% length() #141
unique_pubs = non_atlas_dataset_graph %>% select(consortium_name,publication) %>% filter(!is.na(publication)) %>% unique() %>% as.tibble()

# count how often pubs are mentioned
unique_pubs %>% group_by(publication) %>% tally() %>% view()

# unique publications in final (for which we made predictions)
pub_pred$publication %>% unique() %>% length() #141

# group
final = pub_pred %>% group_by(consortium_name,hasPublication,has_prediction) %>%tally() %>% rename(number_of_datasets = n)

# save counts to file
write_csv(final, "r_output/publications.csv")

# save unique publications to file
write_csv(unique_pubs, "r_output/unique_pubs.csv")

# Marker Paper Queries
non_atlas = read_csv(paste("../../hra-pop/output-data/v",hra_pop_version,"/non-atlas-dataset-graph.csv", sep = ""))
non_atlas

# total number of non-atlas datasets
non_atlas %>% filter(hasExtractionSite==FALSE) %>% nrow()
non_atlas %>% filter(hasExtractionSite==FALSE) %>% nrow()
non_atlas %>% group_by(hasExtractionSite==FALSE, hasCellSummary==FALSE) %>% tally()

# more split up
non_atlas %>% filter(hasCellSummary == TRUE) %>% view()
  
# datasets for which we predict RUI or biomarker
a1 = read_csv(paste(reports,"application-a1.csv", sep=""))
a1$sample %>% unique() %>% length()
a1$rui_location %>% unique() %>% length()

a2p1 = read_csv(paste(reports,"application-a2p1.csv", sep=""))
a2p2 = read_csv(paste(reports,"application-a2p2.csv", sep=""))
a2p3 = read_csv(paste(reports,"application-a2p3.csv", sep=""))

unique_values_1 = a2p1$dataset %>% unique()
unique_values_1 %>% length()

unique_values_2 = a2p2$dataset %>% unique()
unique_values_2 %>% length()

unique_values_3 = a2p3$dataset %>% unique()
unique_values_3 %>% length()

# all datasets for which we predict
total = c(a2p1$dataset,a2p3$dataset)
total %>% unique() %>% length()

a2p3$corridor %>% unique() %>% length()

all_unique = c(unique_values_1, unique_values_2, unique_values_3)
all_unique %>% length

unique_tibble = tibble(union(a2p1$dataset, a2p2$dataset, a2p3$dataset))
unique_tibble %>% length()

# Number of universe datasets
full_dataset_graph = read_csv("ad_hoc_data/full-dataset-graph.csv")
full_dataset_graph$dataset_id %>% length()

# universe by portal
universe_sc_bulk_by_consortium = full_dataset_graph %>% filter()%>% group_by(consortium_name) %>% tally()
write_csv(universe_sc_bulk_by_consortium, "r_output/universe_by_consortium.csv")

# atlas datasets by modality
atlas_datasets = read_csv(paste(reports,"table-s1.csv", sep=""))
atlas_datasets %>% group_by(dataset_id, bulk_or_spatial) %>% tally()
atlas_datasets %>% group_by(dataset_id, cell_type_annotation_tool) %>% tally()

data = read_csv(paste(reports,"dataset-info.csv", sep=""))
data$dataset %>% unique() %>% length()

# donors for sample_id
sample_ids = a1$sample %>% unique()
sample_ids

sample_ids %in% non_atlas_dataset_graph$block_id %>% unique() %>% sum()
# create tibble of donor and  block_id
non_atlas_dataset_graph %>% group_by(donor_id, block_id) %>% tally()

non = non_atlas_dataset_graph %>% rename(sample = block_id) %>% select(sample, donor_id) %>% unique()
non
app = a1 %>% select(sample) %>% unique()
app

result_tibble <- inner_join(app, non, by = "sample")
result_tibble %>% group_by(sample, donor_id) %>% tally()
result_tibble$donor_id %>% unique() %>% length()

# counts datasets atlas and non atlas with modality and organ
all_datasets = read_csv(paste(reports,"spatial-and-bulk-datasets-breakdown.csv", sep=""))
all_datasets

all_datasets %>% filter(status=="Atlas") %>% group_by(organ, dataset_cnt) %>% tally() 

# hra-pop donor overview
donors = read_csv("../ad_hoc_queries/input/donor-info.csv")
donors

donors %>% filter(age<18) %>% view()

# mean age
donors$age %>% mean()
donors$age[!is.na(donors$age)] %>% mean()

# sex
donors %>% group_by(sex) %>% tally()

# race
donors %>% group_by(race) %>% tally()


# CTpop for kidney
data = read_csv("../ad_hoc_queries/input/hra-pop-kidney.csv")

data = data %>% filter(cell_percentage >= .2)

g = ggplot(data, aes(x=as_label, y=cell_percentage, fill=cell_label))+
  geom_bar(stat = "identity", position = "stack")+
  facet_grid(organ~sex)+
theme(
  legend.position = "bottom"
)

g                

# histogram for percentages
p = ggplot(data, aes(x=cell_percentage, fill=cell_label))+
  geom_histogram(binwidth = .01)+
  facet_wrap(~as_label)+
  theme(
    legend.position = "bottom"
  )

p

hist(data$cell_percentage)
