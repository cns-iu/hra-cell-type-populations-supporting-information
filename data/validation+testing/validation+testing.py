import json
from numpy import dot
from numpy.linalg import norm

# CCF API endpoint, not used yet (using downloaded version for dev)
URL_AS_CT_COMBOS = "http://grlc.io/api-git/hubmapconsortium/ccf-grlc/subdir/ccf//cells_located_in_as?endpoint=https%3A%2F%2Fccf-api.hubmapconsortium.org%2Fv1%2Fsparql?format=application/json"

# samples with RUI location and cell type population that we use for this test
test_sets = []


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
    # collect all samples with cell summaries in a list
    for donor in enriched_rui_locations['@graph']:
        for sample in donor['samples']:
            try:
                summary_to_add = {
                    "cell_source": sample['@id'],
                    "summaries": sample['rui_location']['summaries']
                }
                test_sets.append(summary_to_add)
            except:
                continue

    for sample in test_sets:
        print(sample)
    # print(test_sets)
    # to get cosine sims with as-cell-summaries
    # for summary in as_summaries['@graph']:
        # print(summary)

    tissue_block1 = {
        "a": 2,
        "b": 3
    }

    # make all as-cell-summaries available as simple list
    # list_all_as_dict = [ana1, ana2]
    list_as_summary_dict = []

    # set up a set for unique CTs and simplified dicts for AS
    unique_cts = set()
    for as_n_dict in as_summaries['@graph']:
        simple = as_n_dict
        # del simple['@type']
        # del simple['annotation_method']
        for summary in simple['summary']:
            # del summary['@type']
            # del summary['cell_label']
            unique_cts.add(summary['cell_id'])
        list_as_summary_dict.append(simple)
        # print(f'''summary_dict: {as_simple}''')
    # print("unique: " + str(unique_cts))

    # set up a base dict with all possible cell types
    base_dict = {}
    for ct in sorted(unique_cts):
        base_dict[ct] = 0

    # print(f'''base with len=={len(base_dict)}: {base_dict}''')

    # create comparison dicts for tissue block and all as-cell-summaries
    list_normalized_as_with_cell_source = []

    for summary_dict in list_as_summary_dict:
        # print(summary_dict)
        normalized_dict = base_dict.copy()
        for entry in normalized_dict:
            for summary in summary_dict['summary']:
                if entry == summary['cell_id']:
                    normalized_dict[entry] = summary['percentage']
        normalized_with_cell_source = {
            'cell_source': summary_dict['cell_source'],
            'normalized_summary': normalized_dict
        }
        list_normalized_as_with_cell_source.append(normalized_with_cell_source)
        print(normalized_with_cell_source)

    # compute cosine similarity matrix between AS

    # compute cosine similarity between 1 tissue block/sample and all AS

     # make all as-cell-summaries available as simple list

    # V2: Test Cell Type Population Prediction (CTPop4TB)

    # V3: Cosine Similarity Space


def cosine_sim(a, b):
    """A function to return a cosine sim for two vectors

    Returns:
        float: cosine sim
    """
    return dot(a, b)/(norm(a)*norm(b))


# driver code
if __name__ == "__main__":
    main()
