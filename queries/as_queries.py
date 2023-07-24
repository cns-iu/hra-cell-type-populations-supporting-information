import requests
import json
import csv

def main():
    """Main function to get data from AS cell summaries and perform queries"""    
    # You need a token to get this raw GitHub content from the endpoint
    TOKEN = "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"
    endpoint = "https://raw.githubusercontent.com/cns-iu/hra-cell-type-populations-supporting-information/main/data/as-cell-summaries.jsonld"
    headers = {"Authorization": "Bearer " + TOKEN}
    data = requests.get(endpoint, headers=headers).json()
    
    # get a dict of unique AS + number of CTs
    as_ct_counts = {}
    
    # count CTs per AS and capture in dict
    for cell_summary in data["@graph"]:
        if cell_summary['cell_source'] not in as_ct_counts:
            as_ct_counts[cell_summary['cell_source']] = 0
        for row in cell_summary['summary']:
            as_ct_counts[cell_summary['cell_source']] = as_ct_counts[cell_summary['cell_source']] + 1

    # export dict to CSV and JSON
    export_data("csv",as_ct_counts)
    export_data("json", as_ct_counts)

    # print results to console
    for key in as_ct_counts:
        print(f'''
    {key}: {as_ct_counts[key]} cell types
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
                wr.writerow(["anatomical_structure", "cell_types"])
                for kvp in dict.items():
                    wr.writerow([kvp[0], kvp[1]])
                
# driver code
if __name__ == '__main__':
    main()
