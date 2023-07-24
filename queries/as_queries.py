import requests
import json
import csv


def main():
    """Main function to get data from AS cell summaries and perform queries"""
    # You need a token to get this raw GitHub content from the endpoint
    TOKEN = ""
    headers = {"Authorization": "Bearer " + TOKEN}

    endpoint = "https://raw.githubusercontent.com/cns-iu/hra-cell-type-populations-supporting-information/main/data/as-cell-summaries.jsonld"
    data = requests.get(endpoint, headers=headers).json()

    # get a dict of unique AS + number of CTs
    as_ct_counts = {}

    # count CTs per AS and capture in dict
    for cell_summary in data["@graph"]:
        if cell_summary['cell_source'] not in as_ct_counts:
            as_ct_counts[cell_summary['cell_source']] = {
                "cell_types": 0, "based_on_tissue_blocks": 0}
        for row in cell_summary['summary']:
            as_ct_counts[cell_summary['cell_source']
                         ]["cell_types"] = as_ct_counts[cell_summary['cell_source']]["cell_types"] + 1

    # Now, let's add the number of tissue blocks on which these counts are based
    endpoint = "https://raw.githubusercontent.com/cns-iu/hra-cell-type-populations-supporting-information/main/data/enriched_rui_locations.jsonld"
    enriched_rui_locations = requests.get(endpoint, headers=headers).json()

    for anatomical_structure in as_ct_counts:
        for donor in enriched_rui_locations["@graph"]:
            for sample in donor["samples"]:
                for annotation in sample["rui_location"]["ccf_annotations"]:
                    print(annotation)
                    if annotation == anatomical_structure:
                        as_ct_counts[anatomical_structure]["based_on_tissue_blocks"] = as_ct_counts[
                            anatomical_structure]["based_on_tissue_blocks"] + 1

  # export dict to CSV and JSON
    export_data("csv", as_ct_counts)
    export_data("json", as_ct_counts)

    # print results to console
    for key in as_ct_counts:
        print(f'''
    {key}: {as_ct_counts[key]["cell_types"]} cell types
    ''')


def export_data(file_type, dict):
    """A function to export the as_ct_counts dict to CSV or JSON

    :param file_type: the desired output format
    :param dict: the as_ct_counts dict to be output
    """
    match file_type:
        case "json":
            with open('as_ct_counts.json', 'w') as f:
                json.dump(dict, f)
        case "csv":
            with open('as_ct_counts.csv', 'w', newline='') as f:
                wr = csv.writer(f, delimiter=',')
                wr.writerow(["anatomical_structure", "cell_types",
                            "based_on__how_many_tissue_blocks"])
                for kvp in dict.items():
                    wr.writerow([kvp[0], kvp[1]["cell_types"],
                                kvp[1]["based_on_tissue_blocks"]])


# driver code
if __name__ == '__main__':
    main()
