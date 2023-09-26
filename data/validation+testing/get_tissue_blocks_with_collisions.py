import json
import pandas as pd
from utils import get_data


def main():
    """A function to get all the tissue blocks with no mesh collisions
    """

    # create deata frame to hold result
    d = {
        'uuid_link': [],
        'organ': [],
        'bb_collisions': [],
        'mesh_collisions': []
    }

    # load enriched rui locations
    with open('../enriched_rui_locations.jsonld') as f:
        enriched = json.load(f)

    for donor in enriched['@graph']:
        for sample in donor['samples']:

            for collision_summary in sample['rui_location']['all_collisions']:

                # get count of mesh collisions
                num_mesh = len(collision_summary['collisions'])

                # check if none
                if num_mesh == 0:
                    # set cols
                    d['uuid_link'].append(sample['@id'])
                    d['organ'].append(sample['rui_location']
                                      ['placement']['target'])
                    d['bb_collisions'].append(
                        len(sample['rui_location']['ccf_annotations']))
                    d['mesh_collisions'].append(num_mesh)

    # export to CSV
    df = pd.DataFrame(data=d)
    df.to_csv("output/tissue_blocks_without_mesh_collisions.csv", sep=',')


# driver code
if __name__ == "__main__":
    main()
