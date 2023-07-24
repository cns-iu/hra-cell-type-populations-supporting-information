import requests
import json
import csv
from utils import get_data

def main():
    """Main function to get numbers from JSON-LD data"""
   
    rui_cell_summaries = get_data(
        "https://raw.githubusercontent.com/cns-iu/hra-cell-type-populations-supporting-information/main/data/rui-location-cell-summaries.jsonld")
    enriched_rui_locations = get_data(
        "https://raw.githubusercontent.com/cns-iu/hra-cell-type-populations-supporting-information/main/data/enriched_rui_locations.jsonld")
    
    # get a dict of unique AS + number of CTs
    counts = {}
    for summary in rui_cell_summaries["@graph"]:
        if summary["cell_source"] not in counts:
            counts[summary["cell_source"]] = 0
    
    # count occurences of RUI locations in riched RUI locations JSON-LD
    for summary in rui_cell_summaries["@graph"]:
        for donor in enriched_rui_locations["@graph"]:
            for sample in donor["samples"]:
                if sample["rui_location"]["@id"] == summary["cell_source"]:
                    counts[summary["cell_source"]
                           ] = counts[summary["cell_source"]] + 1
    # print results to console
    for key in counts:
        print(f'''
              {key}: {counts[key]}
    ''')
    print(f'''
          Number of unique RUI locations: {len(counts)}
          ''')

# driver code
if __name__ == '__main__':
    main()
