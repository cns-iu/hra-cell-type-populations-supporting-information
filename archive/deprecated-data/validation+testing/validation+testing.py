import json
import pandas as pd
from numpy import dot
from numpy.linalg import norm

# CCF API endpoint, not used yet (using downloaded version for dev)
URL_AS_CT_COMBOS = "http://grlc.io/api-git/hubmapconsortium/ccf-grlc/subdir/ccf//cells_located_in_as?endpoint=https%3A%2F%2Fccf-api.hubmapconsortium.org%2Fv1%2Fsparql?format=application/json"


def main():
    """A function to perform validation steps for the current CTPop workflow to predict rui_locations and cell type populations
    """
    enriched_rui_locations = load_json("../enriched_rui_locations.jsonld")
    as_summaries = load_json("../as-cell-summaries.jsonld")
    api = load_json("downloaded_api_responses/ccf_api_as_ct_combos.json")
    organ_sex_lookup = load_json(
        "downloaded_api_responses/ccf_api_ref_organ_sex.json")

    # V1: Test RUI Location Prediction (simAS, simCorridor)
    # Prediction 0: using as-cell-sumamries

    ###################################
    # Bruce created SPARQL query that takes AS IRI from mesh collision, then associates them with a reference organ, splits by M/F, include representation_of (AS IRI), includes sex as a field: http://grlc.io/api/hubmapconsortium/ccf-grlc/ccf/#/default/get_ref_organ_as_info
    # Modality added to all cell summaries on the repo
    ###################################

    # #############################
    # Issues:
    # http://purl.org/ccf/latest/ccf.owl#VHFColon and http://purl.org/sig/ont/fma/fma62649 are not in response from http://grlc.io/api/hubmapconsortium/ccf-grlc/ccf/#/default/get_ref_organ_as_info
    # http://purl.org/ccf/latest/ccf.owl#VHFColon is called http://purl.org/ccf/latest/ccf.owl#VHFColon in response
    # For the latter, let's create a mapping from old to new
    # #############################

    mapping = {
        "VHFColon": "VHFLargeIntestine",
        "VHFLungV1.1": "VHFLungV1.2"
    }

    # Let's get relevant data from as-cell-summaries and add all to a list
    list_as_summary_dict = []
    for cell_summary in as_summaries['@graph']:
        summary_to_add = {
            # grab the cell_source (AKA the AS) and the cell summary
            "cell_source": cell_summary['cell_source'],
            'summary': cell_summary['summary']
        }
        list_as_summary_dict.append(summary_to_add)

    # Then, let's get relevant data from enriched-rui-locations and add all to a list
    list_tissue_blocks_summary_dict = []
    for donor in enriched_rui_locations['@graph']:
        for sample in donor['samples']:
            try:
                summary_to_add = {
                    # grab cell source (sample ID), AS collision tags (important for checking validity of CTPop later), and summaries
                    "cell_source": sample['@id'],
                    'all_collisions': sample['rui_location']['all_collisions'],
                    'bb_collisions': sample['rui_location']['ccf_annotations'],
                    # could also match by representation_of/ref_organ_term
                    'ref_organ_iri': sample['rui_location']['placement']['target'],
                    "summaries": sample['rui_location']['summaries'],
                    'only_compare_with': set()
                }

                # let's map old organ IRIs to new ones
                for old in mapping:

                    if old in summary_to_add['ref_organ_iri']:
                        summary_to_add['ref_organ_iri'] = summary_to_add['ref_organ_iri'].replace(
                            old, mapping[old])

                for organ in organ_sex_lookup:
                    if summary_to_add['ref_organ_iri'] in organ['ref_organ_iri']:
                        summary_to_add['only_compare_with'].add(
                            organ['as_iri'])

                list_tissue_blocks_summary_dict.append(summary_to_add)
            except:
                continue

    for tb in list_tissue_blocks_summary_dict:
        print(
            f'''{tb['cell_source']} has {tb['ref_organ_iri']} only compare with {tb['only_compare_with']}''')

    # Let's create a dict to capoture our text results. Each key is a column header and the column content is a list
    d = {
        'tissue_block': [],
        'organ': [],
        'is_best_fit_in_mesh_collisions': [],
        'difference_between_best_and_second_best': [],
        'number_of_mesh_collisions': [],
        'number_of_bb_collisions': [],
        'best_fit': [],
        'second_best_fit': []
    }

    # let's add one column for each AS for which we has AS summaries
    for as_sum in list_as_summary_dict:
        d[as_sum['cell_source']] = []

    # Next, let's run this code for all 159 TBs. We capture their max cosine sim value and the AS name of the best fit AS based on CTPop
    # Additionally, we capture whether this AS is in the mesh-based collisions of the TB
    for tb in list_tissue_blocks_summary_dict:
        print(f'''Now validating {tb['cell_source']}''')
        # variables to capture max, best fit AS, and whether the best fit AS is in the mesh-based collisions for this TB
        organ = tb['ref_organ_iri']
        max = 0
        second_max = 0
        difference = 0
        best_fit = ""
        second_best_fit = ""
        best_fit_in_mesh_collisions = False
        print(tb['all_collisions'])
        number_of_mesh_collisions = len(tb['all_collisions'][0]['collisions'])
        number_of_bb_collisions = len(tb['bb_collisions'])

        # Let's set the ID of this tissue block
        d['tissue_block'].append(tb['cell_source'])

        # Now we loop through all the AS summaries
        for as_sum in list_as_summary_dict:
            if as_sum['cell_source'] in tb['only_compare_with']:
                # Now we use functions defined below to get normalized dictionaries for the current tissue block and AS
                vectors = create_comparison_dicts(
                    normalize_summaries(tb, as_sum))
                # Let's compute the cosime similarity between the two vectors (TB and AS)
                val = cosine_sim(
                    vectors['anatomical_structure']['vector'], vectors['tissue_block']['vector'])
                # Let's capture the current cosine similarity value
                d[as_sum['cell_source']].append(val)

                # if the current value is larger than the current max value, we replace the max value and best fit AS
                if val > max:

                    second_max = max
                    max = val
                    difference = max-second_max
                    print(f'''difference: {difference}''')

                    second_best_fit = best_fit
                    best_fit = vectors['anatomical_structure']['cell_source']

                    print(
                        f'''Identified {best_fit} with {max} for {tb['cell_source']}''')
                    # Finally, we check if the new best fit is in the mesh-based collisions of the TB

                    for item in tb['all_collisions']:
                        for element in item['collisions']:
                            # print(f'''best fit is now {best_fit}, now collision-checking for {element['as_id']} in {tb['cell_source']} with result {element['as_id'] == best_fit}''')
                            print(
                                f'''best fit is now {best_fit}, now collision-checking for {element['as_id']} in {tb['cell_source']} with result {element['as_id'] == best_fit}''')
                            best_fit_in_mesh_collisions = element['as_id'] == best_fit
            else:
                d[as_sum['cell_source']].append("no comparison possible")

        # let's capture the best fit and is_best_fit_in_mesh_collisions bool
        print(f'''Appending {best_fit} for {tb['cell_source']}''')
        d['organ'].append(normalize_organ_name(organ))
        d['best_fit'].append(best_fit)
        d['difference_between_best_and_second_best'].append(difference)
        d['is_best_fit_in_mesh_collisions'].append(
            best_fit_in_mesh_collisions)
        d['number_of_mesh_collisions'].append(number_of_mesh_collisions)
        d['number_of_bb_collisions'].append(number_of_bb_collisions)
        d['second_best_fit'].append(second_best_fit)
        print()

    print(d)
    # finally, let's save the dict as a CSV using pandas
    df = pd.DataFrame(data=d)
    df.to_csv('tissue_block_fit_v2.csv')

    # V2: Test Cell Type Population Prediction (CTPop4TB)
    # TO BE ADDED LATER

    # V3: Cosine Similarity Space
    # TO BE ADDED LATER


def normalize_organ_name(iri):
    """A function to remove uninformative parts of the URL and version numbers from an organ IRI (and also sex)

      Args:
        iri (str): the organ IRI

    Returns:
        string: the normalized organ name
    """
    regex = [
        "http://purl.org/ccf/latest/ccf.owl#", "VHM", "VHF", "V1.1", "V1.2"
    ]

    updated_iri = iri
    for str in regex:
        if str in updated_iri:
            updated_iri = updated_iri.replace(str, "")
    return updated_iri


def cosine_sim(a, b):
    """A function to return a cosine sim for two vectors

  Args:
        a (list): vector 1
        b (list): vector 2

    Returns:
        float: cosine sim
    """
    return dot(a, b)/(norm(a)*norm(b))


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


def normalize_summaries(dict_tissue_block, dict_as):
    """A function to return a normalize dictionary

    Args:
        dict_tissue_block (dict): The dict with the cell counts of the tissue block
        dict_as (dict): The dict with the cell counts of the anatomical structure

    Returns:
        dict: A normalized dictionary
    """

    # collect unique cell_types in AS and TB
    unique_cell_types = set()
    for row in dict_as['summary']:
        unique_cell_types.add(row['cell_id'])
    for cell_summary in dict_tissue_block['summaries']:
        for entry in cell_summary['summary']:
            unique_cell_types.add(entry['cell_id'])

    # Let's make the list of unique cell types available as a dict
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

    # put together result in one neat dict
    result = {
        'anatomical_structure': normalized_as_with_cell_source,
        'tissue_block': normalized_tissue_block_with_cell_source
    }

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

    # initialize result dict
    result = {}

    # create a simple list for all CT counts for AS
    list_as = []
    for item in sorted(dict_normalized['anatomical_structure']['normalized_summary']):
        list_as.append(
            dict_normalized['anatomical_structure']['normalized_summary'][item])

    # create a simple list for all CT counts for TB
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
