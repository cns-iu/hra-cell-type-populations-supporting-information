import { readFileSync, writeFileSync } from 'fs';

const OUTPUT = '../data/as-cell-summaries.jsonld';
const donors = JSON.parse(readFileSync('../data/enriched_rui_locations.jsonld'));
const asCellSummaries = {};

function getCollisionItems(block) {
  const allCollisions = block.rui_location?.all_collisions ?? [];
  const collisions = allCollisions.reduce((acc, c) => acc.concat(c?.collisions ?? []), []);
  return collisions;
}

function handleCellSummaries(dataset, collisions) {
  for (const dsSummary of dataset.summaries ?? []) {
    const cellSummaryRows = dsSummary?.summary ?? [];
    for (const cell of cellSummaryRows) {
      for (const collision of collisions) {
        const asIri = collision.as_id;
        const modality = dsSummary.modality;
        const weightedCellCount = cell.count * collision.percentage;

        const summary = (asCellSummaries[asIri + modality] = asCellSummaries[asIri + modality] || {
          '@type': 'CellSummary',
          cell_source: asIri,
          annotation_method: 'Aggregation',
          aggregated_summary_count: 0,
          aggregated_summaries: new Set(),
          modality,
          summary: [],
        });
        summary.aggregated_summaries.add(dataset['@id']);

        let summaryRow = summary.summary.find((s) => s.cell_id === cell.cell_id);
        if (summaryRow) {
          summaryRow.count += weightedCellCount;
        } else {
          summaryRow = {
            '@type': 'CellSummaryRow',
            cell_id: cell.cell_id,
            cell_label: cell.cell_label,
            count: weightedCellCount,
            percentage: 0, // to be computed at the end
          };
          summary.summary.push(summaryRow);
        }
      }
    }
  }
}

function finalizeAsCellSummaries() {
  return Object.values(asCellSummaries).map((summary) => {
    const cellCount = summary.summary.reduce((acc, s) => acc + s.count, 0);
    summary.summary.forEach((s) => (s.percentage = s.count / cellCount));
    summary.aggregated_summary_count = summary.aggregated_summaries.size;
    summary.aggregated_summaries = [...summary.aggregated_summaries];
    return summary;
  });
}

for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    const collisions = getCollisionItems(block);
    if (collisions.length > 0) {
      for (const section of block.sections ?? []) {
        (section.datasets ?? []).forEach((ds) => handleCellSummaries(ds, collisions));
      }
      (block.datasets ?? []).forEach((ds) => handleCellSummaries(ds, collisions));
    }
  }
}

const results = finalizeAsCellSummaries();

// Write out the new as-collisions.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
