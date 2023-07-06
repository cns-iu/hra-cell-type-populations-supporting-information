import { readFileSync, writeFileSync } from 'fs';

const OUTPUT='../data/enriched_rui_locations.jsonld';
const collisions = JSON.parse(readFileSync('../data/collisions.jsonld'));
const corridors = JSON.parse(readFileSync('../data/corridors.jsonld'));
const datasetSummaries = JSON.parse(readFileSync('../data/dataset-cell-summaries.jsonld'));
const ruiSummaries = JSON.parse(readFileSync('../data/rui-location-cell-summaries.jsonld'));
const donors = JSON.parse(readFileSync('../data/rui_locations.jsonld'));

const summaryLookup = datasetSummaries['@graph'].concat(ruiSummaries['@graph'])
  .reduce((acc, summary) => (acc[summary['cell_source']] = summary, acc), {});

// Add summary to an object if it exists in *-cell-sumaries.jsonld
function enrichWithSummaries(obj) {
  const summary = summaryLookup[obj['@id']];
  if (summary) {
    obj.summaries = obj.summaries ?? [];
    obj.summaries.push(summary);
    delete summary.cell_source;
  }
}

const collisionLookup = collisions['@graph']
  .reduce((acc, collision) => (acc[collision['collision_source']] = collision, acc), {});

const corridorLookup = corridors['@graph']
  .reduce((acc, corridor) => (acc[corridor['corridor_source']] = corridor, acc), {});

function enricheRuiLocation(ruiLocation) {
  const collision = collisionLookup[ruiLocation['@id']];
  if (collision) {
    ruiLocation.all_collisions = ruiLocation.all_collisions ?? [];
    ruiLocation.all_collisions.push(collision);
    delete collision.collision_source;
  }

  const corridor = corridorLookup[ruiLocation['@id']];
  if (corridor) {
    ruiLocation.corridor = corridor;
    delete corridor.corridor_source;
  }

  enrichWithSummaries(ruiLocation);
}

// Find all datasets in rui_locations.jsonld and add cell summaries if they exist
for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    if (block.rui_location) {
      enricheRuiLocation(block.rui_location);
    }
    for (const section of block.sections ?? []) {
      (section.datasets ?? []).forEach(enrichWithSummaries);
    }
    (block.datasets ?? []).forEach(enrichWithSummaries);
  }
}

// Write out the new enriched_rui_locations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': donors['@graph'],
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
