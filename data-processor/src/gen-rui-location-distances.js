import { readFileSync, writeFileSync } from 'fs';
import { getAllSpatialEntityDistances } from './utils/spatial-entity-distance.js';

const OUTPUT = '../data/rui-location-distances.jsonld';
const donors = JSON.parse(readFileSync('../data/rui_locations.jsonld'))['@graph'];

const ruiLocations = [];
for (const donor of donors) {
  for (const block of donor['samples']) {
    const ruiLocation = block.rui_location;
    ruiLocations.push(ruiLocation);
  }
}
ruiLocations.sort((a, b) => a['@id'].localeCompare(b['@id']))

const results = [];
for await (const distance of getAllSpatialEntityDistances(ruiLocations)) {
  results.push(distance);
};

// Write out the new enriched_rui_locations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
