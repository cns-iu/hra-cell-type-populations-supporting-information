import json


def main():
    """A function to count datasets, unique organs, and cell types
    """

    # load data
    dataset_cell_summaries = load_json("../dataset-cell-summaries.jsonld")
    enriched_rui_locations = load_json("../enriched_rui_locations.jsonld")
    rui_locations = load_json("../rui_locations.jsonld")
    enriched_rui_locations = load_json("../enriched_rui_locations.jsonld")



    # unqiue rui locations, datasets, and cell types
    unique_rui_locations = set()
    unique_datasets = set()
    unique_cell_types = set()
    
    for cell_summary in dataset_cell_summaries['@graph']:
        unique_datasets.add(cell_summary['cell_source'])
        for row in cell_summary['summary']:
            unique_cell_types.add(row['cell_id'])
    

            
    
    
    print(f'''
          Unique datasets: {len(unique_datasets)}
          Unique cell types: {len(unique_cell_types)}
          Unique enriched RUI locations: {len(count_rui_locations(enriched_rui_locations))}
          Unique tissue blocks: {len(count_tissue_blocks(enriched_rui_locations))}
          ''')
        
    # covering which unique eorgans

def count_tissue_blocks(response):
    result = set()
    for donor in response['@graph']:
        for sample in donor['samples']:
            try:
                result.add(sample['@id'])
            except:
                continue
    
    return result
    
def count_rui_locations(response):
    """_summary_

    Args:
        response (dict): the rui_locations.json-ld 

    Returns:
        set: A set of unique RUI location IDs
    """
    
    result = set()
    for donor in response['@graph']:
        for sample in donor['samples']:
            try:
                result.add(sample['rui_location']['@id'])
            except:
                continue
    
    return result

def load_json(file_path):
    """A function to load a json file and return the data as a dict

    Args:
        file_path (string): file path

    Returns:
        dict: the data
    """
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data


# driver code
if __name__ == "__main__":
    main()
