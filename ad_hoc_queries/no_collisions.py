import json
import csv
import pandas as pd

def main():
    """A method to identify extraction sites without mesh collisions in hra-pop
    """
    
     
    # Opening JSON file
    f = open("../../hra-pop/output-data/v0.5.2/atlas-enriched-dataset-graph.jsonld")
    
    # returns JSON object as 
    # a dictionary
    dataset_graph = json.load(f)
    
    # initialize result, to be converted to pandas data farme at the end and exported as CSV
    result = {
      'creator' : [],
      'tissue_block_hubmap_id' : [],
      'rui_location_id': [] 
    }

    # loop through JSON-LD and find...
    for donor in dataset_graph['@graph']:
      for sample in donor['samples']:
        for CollisionSummary in sample['rui_location']['all_collisions']:
          
          # rui_locations with empty collisions arrays
          if len(CollisionSummary['collisions']) == 0:
            
            result['creator'].append(sample['rui_location']['creator'])
            result['tissue_block_hubmap_id'].append(sample['@id'])
            result['rui_location_id'].append(sample['rui_location']['@id'])
    
    # Convert dict to DataFrame
    df = pd.DataFrame.from_dict(result)

      # Export DataFrame to CSV
    df.to_csv('output/no_collisions.csv', index=False)

# driver code
if __name__ == '__main__':
    main()