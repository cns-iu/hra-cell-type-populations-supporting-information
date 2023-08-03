import json

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
    
    # get cosine sims for as-cell-summaries
    for summary in as_summaries['@graph']:
        print(summary)
    
    # V2: Test Cell Type Population Prediction (CTPop4TB)

    # V3: Cosine Similarity Space


def cosine_sim():
    """A function to return a cosine sim for two vectors

    Returns:
        float: cosine sim
    """
    return 0


def get_vector_from_cell_types():
    """A function to turn a CelLSummary into a vector
    """


# driver code
if __name__ == "__main__":
    main()
