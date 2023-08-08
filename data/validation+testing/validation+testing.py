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
                    "id": sample['@id'],
                    "summaries": sample['rui_location']['summaries']
                }
                test_sets.append(summary_to_add)
            except:
                continue

    # to get cosine sims with as-cell-summaries
    # for summary in as_summaries['@graph']:
        # print(summary)

    tissue_block1 = {
        "a": 2,
        "b": 3
    }

    # make all as-cell-summaries available as simple list
    # list_all_as_dict = [ana1, ana2]
    list_summary_dict = []

    # set up a set for unique CTs and simplified dicts for AS
    unique_cts = set()
    for as_n_dict in as_summaries['@graph']:
        as_simple = as_n_dict
        del as_simple['@type']
        del as_simple['annotation_method']
        for summary in as_simple['summary']:
            del summary['@type']
            del summary['cell_label']
            unique_cts.add(summary['cell_id'])
        list_summary_dict.append(as_simple)
        # print(f'''summary_dict: {as_simple}''')
    print("unique: " + str(unique_cts))

    # set up a base dict with all possible cell types
    base_dict = {}
    for ct in sorted(unique_cts):
        base_dict[ct] = 0

    print(f'''base with len=={len(base_dict)}: {base_dict}''')

    # create comparison dicts for tissue block and all as-cell-summaries
    list_comparison_dicts = []

    for summary_dict in list_summary_dict:
        print(summary_dict)
        comparison_dict = base_dict.copy()
        for entry in comparison_dict:
            for cell_type in summary_dict['summary']:
                if entry == cell_type['cell_id']:
                    comparison_dict[entry] = cell_type['percentage']
        list_comparison_dicts.append(comparison_dict)
        print(comparison_dict)

    vectors = []
    for c in list_comparison_dicts:
        vector = []
        for type in c:
            vector.append(c[type])
        vectors.append(vector)
        print(vector)

    # print(cosine_sim(vectors[0], vectors[1]))

    # for key in tissue_block:
    #     list.append(tissue_block[key])

    # print(cosine_sim(a,b))

    # V2: Test Cell Type Population Prediction (CTPop4TB)

    # V3: Cosine Similarity Space


def as_list_cell_aummary():
    """A function to convert a cell summary to a list
    """


def cosine_sim(a, b):
    """A function to return a cosine sim for two vectors

    Returns:
        float: cosine sim
    """
    return dot(a, b)/(norm(a)*norm(b))


def get_vector_from_cell_types():
    """A function to turn a CelLSummary into a vector
    """


# driver code
if __name__ == "__main__":
    main()
