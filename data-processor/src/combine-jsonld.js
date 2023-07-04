import { readFileSync, writeFileSync } from 'fs';

const OUTPUT='../data/enriched_rui_locations.jsonld';
const collisions = JSON.parse(readFileSync('../data/collisions.jsonld'));
const corridors = JSON.parse(readFileSync('../data/corridors.jsonld'));
const summaries = JSON.parse(readFileSync('../data/dataset-cell-summaries.jsonld'));
const donors = JSON.parse(readFileSync('../data/rui_locations.jsonld'));

const summaryLookup = summaries['@graph']
  .reduce((acc, summary) => (acc[summary['cell_source']] = summary, acc), {});

// Add summary to a dataset if it exists in cell-sumaries.jsonld
function enrichDataset(dataset) {
  const summary = summaryLookup[dataset['@id']];
  if (summary) {
    dataset.summaries = dataset.summaries ?? [];
    dataset.summaries.push(summary);
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
}

// Find all datasets in rui_locations.jsonld and add cell summaries if they exist
for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    if (block.rui_location) {
      enricheRuiLocation(block.rui_location);
    }
    for (const section of block.sections ?? []) {
      (section.datasets ?? []).forEach(enrichDataset);
    }
    (block.datasets ?? []).forEach(enrichDataset);
  }
}

// Write out the new enriched_rui_locations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': donors['@graph'],
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
