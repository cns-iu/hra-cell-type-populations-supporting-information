import json
from numpy import dot
from numpy.linalg import norm

# CCF API endpoint, not used yet (using downloaded version for dev)
URL_AS_CT_COMBOS = "http://grlc.io/api-git/hubmapconsortium/ccf-grlc/subdir/ccf//cells_located_in_as?endpoint=https%3A%2F%2Fccf-api.hubmapconsortium.org%2Fv1%2Fsparql?format=application/json"


def main():
    """A function to perform validation steps for the current CTPop workflow to predict rui_locations and cell type populations
    """

    with open("../enriched_rui_locations.jsonld", 'r') as f:
        enriched_rui_locations = json.load(f)

    # load AS cell summaries
    with open("../as-cell-summaries.jsonld", 'r') as f:
        as_summaries = json.load(f)

    # open downloaded API responses (for speed)
    with open("downloaded_api_responses/ccf_api_as_ct_combos.json", 'r') as f:
        api = json.load(f)

    # V1: Test RUI Location Prediction (simAS, simCorridor)
    # Prediction 0: using as-cell-sumamries
    # make all as-cell-summaries available as list
    list_as_summary_dict = []

    for cell_summary in as_summaries['@graph']:
        summary_to_add = {
            "cell_source": cell_summary['cell_source'],
            'summary': cell_summary['summary']
        }
        list_as_summary_dict.append(summary_to_add)

    # for list in list_as_summary_dict:
    #     print(list)

    # make samples with RUI location and cell type population that we use for this test available as list
    list_tissue_blocks_summary_dict = []

    for donor in enriched_rui_locations['@graph']:
        for sample in donor['samples']:
            try:
                summary_to_add = {
                    "cell_source": sample['@id'],
                    'ccf_annotations' : sample['rui_location']['ccf_annotations'],
                    "summaries": sample['rui_location']['summaries']
                }
                list_tissue_blocks_summary_dict.append(summary_to_add)
            except:
                continue

    # for sample in list_tissue_blocks_summary_dict:
    #     print(sample)

    # NORMALIZATION ONLY NEEED BETWEEN SUMMARy PAIRS WE COMPARE!
    # WRITE NORMALIZATION FUNCTION THAT IS ONLY APPLIED WITH COMPARING TWO AS OR TB OR MIXED WITH EACH OTHER!

    # compute cosine similarity matrix between AS
    # set up a set for unique CTs in the AS
    unique_cts = set()
    for as_n_dict in as_summaries['@graph']:
        simple = as_n_dict
        for summary in simple['summary']:
            unique_cts.add(summary['cell_id'])
        # capture as-cell-summary in list
        list_as_summary_dict.append(simple)

    # set up a base dict with all possible cell types in the AS
    base_dict = {}
    for ct in sorted(unique_cts):
        base_dict[ct] = 0

    print(f'''base_dict has {len(base_dict)} unique cell types.''')

    # vectors = create_comparison_dicts(normalize_summaries(
    #     list_tissue_blocks_summary_dict[0], list_as_summary_dict[0]))

    # print(cosine_sim(vectors['anatomical_structure'], vectors['tissue_block']))

    max = 0
    best_fit = ""
    tb = list_tissue_blocks_summary_dict[77]

    for as_sum in list_as_summary_dict:
        vectors = create_comparison_dicts(normalize_summaries(
            tb, as_sum))
        val = cosine_sim(
            vectors['anatomical_structure']['vector'], vectors['tissue_block']['vector'])
        print(
            f'''AS {vectors['anatomical_structure']['cell_source']} has val: {val}''')
        if val > max:
            max = val
            best_fit = vectors['anatomical_structure']['cell_source']
    print()
    print(f'''Best fit: {best_fit} with {max}''')
    print(f'''Is best_fit in ccf_annotations? {best_fit in tb['ccf_annotations']}''')

    # print(cosine_sim(vectors[0], vectors[1]))
    # compute cosine similarity between tissue blocks/samples and all AS
    # normalize sample cell summaries

    # make all as-cell-summaries available as simple list

    # V2: Test Cell Type Population Prediction (CTPop4TB)

    # V3: Cosine Similarity Space


def cosine_sim(a, b):
    """A function to return a cosine sim for two vectors

    Returns:
        float: cosine sim
    """
    return dot(a, b)/(norm(a)*norm(b))


def normalize_summaries(dict_tissue_block, dict_as):
    """A function to return a normalize dictionary

    Args:
        dict_tissue_block (dict): The dict with the cell counts of the tissue block
        dict_as (dict): The dict with the cell counts of the anatomical structure

    Returns:
        dict: A normalized dictionary
    """
    # unique cell_types in both
    unique_cell_types = set()
    for row in dict_as['summary']:
        unique_cell_types.add(row['cell_id'])
    for cell_summary in dict_tissue_block['summaries']:
        for entry in cell_summary['summary']:
            unique_cell_types.add(entry['cell_id'])
    # print(f'''unique cell types: {len(unique_cell_types)}''')

    # created based_dict with all cells (shared and not shared) between TB and AS
    base_dict = {}
    for cell_type in unique_cell_types:
        base_dict[cell_type] = 0

    # normalize cell tpyes in AS
    normalized_as = base_dict.copy()
    for entry in normalized_as:
        for cell_summary in dict_as['summary']:
            if entry == cell_summary['cell_id']:
                normalized_as[entry] = cell_summary['percentage']
    normalized_as_with_cell_source = {
        'cell_source': dict_as['cell_source'],
        'normalized_summary': normalized_as
    }
    # print(
    #     f'''normalized_as_with_cell_source has len: {len(normalized_as_with_cell_source['normalized_summary'])}''')
    # print(
    #     f'''normalized_as_with_cell_source: {normalized_as_with_cell_source}''')

    # normalize cell tpyes in tissue block
    normalized_tissue_block = base_dict.copy()
    for entry in normalized_tissue_block:
        for cell_summary in dict_tissue_block['summaries']:
            for summary in cell_summary['summary']:
                if entry == summary['cell_id']:

                    normalized_tissue_block[entry] = summary['percentage']
    normalized_tissue_block_with_cell_source = {
        'cell_source': dict_tissue_block['cell_source'],
        'normalized_summary': normalized_tissue_block
    }
    # print(
    #     f'''normalized_tissue_block_with_cell_source has len: {len(normalized_tissue_block_with_cell_source['normalized_summary'])}''')
    # print(
    #     f'''normalized_tissue_block_with_cell_source: {normalized_tissue_block_with_cell_source}''')

    #    print(cell_summary)

    result = {
        'anatomical_structure': normalized_as_with_cell_source,
        'tissue_block': normalized_tissue_block_with_cell_source
    }

    # for entry in summary['summary']:
    #     if row['cell_id'] == entry['cell_id']:
    #         continue

    return result


def create_comparison_dicts(dict_normalized):
    """A function to isolate CT counts from two dictionaries and return them as a list of lists

    Args:
        dict_comparison (dict): A dictionary with cell type summaries for one anatomical structure and one tissue block 

     Returns:
        list: A list of lists
    """
    # print(f'''AS: {dict_normalized['anatomical_structure']}''')
    # print(f'''TB: {dict_normalized['tissue_block']}''')

    result = {}
    list_as = []
    for item in sorted(dict_normalized['anatomical_structure']['normalized_summary']):
        list_as.append(
            dict_normalized['anatomical_structure']['normalized_summary'][item])

    list_tb = []
    for item in sorted(dict_normalized['tissue_block']['normalized_summary']):
        list_tb.append(dict_normalized['tissue_block']
                       ['normalized_summary'][item])

    result['anatomical_structure'] = {
        'cell_source': dict_normalized['anatomical_structure']['cell_source'],
        'vector': list_as
    }
    result['tissue_block'] = {
        'cell_source': dict_normalized['tissue_block']['cell_source'],
        'vector': list_tb
    }
    return result


# driver code
if __name__ == "__main__":
    main()
