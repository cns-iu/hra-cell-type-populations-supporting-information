import json


def main():
    """A function to count datasets, unique organs, and cell types
    """

    # load data
    dataset_cell_summaries = load_json("../dataset-cell-summaries.jsonld")
    enriched_rui_locations = load_json("../enriched_rui_locations.jsonld")
    rui_locations = load_json("../rui_locations.jsonld")
    enriched_rui_locations = load_json("../enriched_rui_locations.jsonld")
    corridors = load_json("../corridors.jsonld")

    # unqiue rui locations, datasets, and cell types
    # dict for corridors and associated AS
    unique_rui_locations = set()
    unique_datasets = set()
    unique_cell_types = set()
    unique_as_in_corridors = set()
    as_counts_in_corridor = {}

    # get unique datasets and cell types
    for cell_summary in dataset_cell_summaries['@graph']:
        unique_datasets.add(cell_summary['cell_source'])
        for row in cell_summary['summary']:
            unique_cell_types.add(row['cell_id'])

    # get AS that collide with tissue blocks that form corridors
    for donor in enriched_rui_locations['@graph']:
        for sample in donor['samples']:
            if "corridor" in sample['rui_location']:
                for collision_item in sample['rui_location']['all_collisions']:
                    for collision in collision_item['collisions']:
                        unique_as_in_corridors.add(collision['as_3d_id'])

    # get numbers of AS per corridor
    for donor in enriched_rui_locations['@graph']:
        for sample in donor['samples']:
            if "corridor" in sample['rui_location']:
                as_counts_in_corridor[sample['rui_location']
                                      ['corridor']['file']] = []
                for collision_item in sample['rui_location']['all_collisions']:
                    for collision in collision_item['collisions']:
                        as_counts_in_corridor[sample['rui_location']['corridor']['file']].append(collision['as_3d_id'])

    # print results for unique counts
    print(f'''
          Unique datasets: {len(unique_datasets)}
          Unique cell types: {len(unique_cell_types)}
          Unique enriched RUI locations: {len(count_rui_locations(enriched_rui_locations))}
          Unique tissue blocks: {len(count_tissue_blocks(enriched_rui_locations))}
          Unique AS in corridors: {len(unique_as_in_corridors)}
          ''')

    # print result for AS per corridor
    for key in as_counts_in_corridor:
        print(f'''Corridor {key} has {len(as_counts_in_corridor[key])} AS: ''')
        for anatomical_structure in as_counts_in_corridor[key]:
            print(f'''\tThose AS are: {anatomical_structure} AS: ''')


def count_tissue_blocks(response):
    """A function to count unique tissue blocks

   Args:
        response (dict): the enriched_rui_locations.json-ld 

    Returns:
        set: A set of unique sample IDs
    """
    result = set()
    for donor in response['@graph']:
        for sample in donor['samples']:
            try:
                result.add(sample['@id'])
            except:
                continue

    return result


def count_rui_locations(response):
    """A function to count unique rui locations

    Args:
        response (dict): the enriched_rui_locations.json-ld 

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
