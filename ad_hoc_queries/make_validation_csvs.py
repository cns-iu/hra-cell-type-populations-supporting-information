import json
import csv
import re
import pandas as pd

def main():
    """A method to identify extraction sites without mesh collisions in hra-pop
    """
    
    # global vars
    hra_pop_version = "0.8.2" #change to v0.8.3 later (to omit unpublished atlas datasets)
    
    # Links to atlas-enriched-dataset-graph
    atlas_enriched_dataset_graph_file = open("../../hra-pop/output-data/v"+hra_pop_version+ "/atlas-enriched-dataset-graph.jsonld") # biomarkers and cell types
    
    # percentage of anatomical structures
    
        
    # # initialize result, to be converted to pandas data farme at the end and exported as CSV
    result = {
      'dataset_id' : [],
      'organ' : []
    }
    
    
     
    # Opening JSON file
    # returns JSON object as 
    # a dictionary
    dataset_graph = json.load(atlas_enriched_dataset_graph_file)
    
    as_tags = set()
    datasets = set()
    
    for donor in dataset_graph['@graph']:
      for sample in donor['samples']:
        
        # get dataset ID
        for dataset in sample['datasets']:
         result['dataset_id'].append(dataset['@id'])
         datasets.add(dataset['@id'])
        # get AS tags
        for collision_summary in sample['rui_location']['all_collisions']:
          for collision_item in collision_summary['collisions']:
            
            # construct AS column header
            to_remove = ['VHF', 'VHM']
            pattern = "|".join(map(re.escape, to_remove))
            organ = re.sub(pattern,'', collision_item['reference_organ'].split('#')[1])
            as_label = collision_item['as_label']
            header = f'{organ} - {as_label}'
            result[header] = []
            as_tags.add(header)

    
    # print(dataset_graph)
    print(len(as_tags))
    print(len(datasets))
    print(result)


    
    # # Convert dict to DataFrame
    df = pd.DataFrame.from_dict(result)

    #   # Export DataFrame to CSV
    df.to_csv('output/umap_as_percentage.csv', index=False)

# driver code
if __name__ == '__main__':
    main()