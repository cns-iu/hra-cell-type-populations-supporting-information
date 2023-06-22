import { readFileSync, writeFileSync } from 'fs';

const OUTPUT='../data/rui_locations_with_summaries.jsonld';
const summaries = JSON.parse(readFileSync('../data/cell-summaries.jsonld'));
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

// Find all datasets in rui_locations.jsonld and add cell summaries if they exist
for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    for (const section of block.sections ?? []) {
      (section.datasets ?? []).forEach(enrichDataset);
    }
    (block.datasets ?? []).forEach(enrichDataset);
  }
}

writeFileSync(OUTPUT, JSON.stringify(donors, null, 2));
