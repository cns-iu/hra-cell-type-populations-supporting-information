import { readFileSync, writeFileSync } from 'fs';

const summaries = JSON.parse(readFileSync('cell-summaries.jsonld'));
const donors = JSON.parse(readFileSync('rui_locations.jsonld'));

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

writeFileSync('rui_locations_with_summaries.jsonld', JSON.stringify(donors, null, 2));
