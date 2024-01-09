# for dataset IDs from Application2, get publications from non-atlas-dataset-graph

# get application2p1 report (computes cosine sim between dataset and AS)
application2p1 = read_csv("../../hra-pop/output-data/v0.5/reports/atlas/application-a2p1.csv") 
app = application2p1%>% select(dataset) %>% unique()

# get non-atlas datasets (many have publications)
non_atlas_dataset_graph = read_csv("../../hra-pop/output-data/v0.5/non-atlas-dataset-graph.csv") 
non_atlas = non_atlas_dataset_graph %>% select(hasPublication,dataset_id, publication, consortium_name) %>% unique()

# create combined tibble with dataset_id and publications
pub_pred = non_atlas %>% mutate(
  has_prediction = ifelse(dataset_id %in% app$dataset, TRUE, FALSE)
)
pub_pred %>% view()

# unique publications in non-atlas-dataset-graph
non_atlas_dataset_graph$publication %>% unique() %>% length() #141

# unique publications in final (for which we made predictions)
pub_pred$publication %>% unique() %>% length() #141

# group
final = pub_pred %>% group_by(consortium_name,hasPublication,has_prediction) %>%tally() %>% rename(number_of_datasets = n)

# save to file
write_csv(final, "r_output/publications.csv")
