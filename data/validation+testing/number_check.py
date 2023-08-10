import json


def main():
    """A function to count datasets, unique organs, and cell types
    """

    # load data
    dataset_cell_summaries = load_json("../dataset-cell-summaries.jsonld")

    # unqiue datasets & cell types
    unique_datasets = set()
    unique_cell_types = set()
    
    for cell_summary in dataset_cell_summaries['@graph']:
        unique_datasets.add(cell_summary['cell_source'])
        for row in cell_summary['summary']:
            unique_cell_types.add(row['cell_id'])
    
    print(f'''
          Unique datasets: {len(unique_datasets)}
          Unique cell types: {len(unique_cell_types)}
          ''')
        
    # covering which unique eorgans
    
    

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
