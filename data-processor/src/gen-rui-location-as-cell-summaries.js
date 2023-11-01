import { readFileSync, writeFileSync } from 'fs';

const OUTPUT = '../data/rui-location-as-cell-summaries.jsonld';
const donors = JSON.parse(readFileSync('../data/rui_locations.jsonld'));
const asCellSummaries = JSON.parse(readFileSync('../data/as-cell-summaries.jsonld'));
const collisions = JSON.parse(readFileSync('../data/collisions.jsonld'));
const ruiCellSummaries = {};

const collisionLookup = collisions['@graph'].reduce(
  (acc, collision) => ((acc[collision['collision_source']] = collision.collisions || []), acc),
  {}
);

const asCellSummaryLookup = asCellSummaries['@graph'].reduce(
  (acc, summary) => ((acc[summary['cell_source']] = (acc[summary['cell_source']] || []).concat(summary)), acc),
  {}
);

function handleCellSummaries(ruiLocation, collisions) {
  for (const collision of collisions) {
    const asIri = collision.as_id;
    const asSummaries = asCellSummaryLookup[asIri];

    for (const asSummary of asSummaries ?? []) {
      const modality = asSummary.modality;
      if (!ruiCellSummaries[ruiLocation + modality]) {
        const summary = (ruiCellSummaries[ruiLocation + modality] = ruiCellSummaries[ruiLocation + modality] || {
          '@type': 'CellSummary',
          cell_source: ruiLocation,
          annotation_method: 'AS Cell Summary',
          aggregated_summary_count: 0,
          aggregated_summaries: new Set(),
          modality,
          summary: [],
        });
        summary.aggregated_summaries.add(asIri);

        const cellSummaryRows = asSummary?.summary ?? [];
        for (const cell of cellSummaryRows) {
          const weightedCellCount = cell.count * collision.percentage;

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
}

function finalizeAsCellSummaries() {
  return Object.values(ruiCellSummaries).map((summary) => {
    const cellCount = summary.summary.reduce((acc, s) => acc + s.count, 0);
    summary.summary.forEach((s) => (s.percentage = s.count / cellCount));
    summary.aggregated_summary_count = summary.aggregated_summaries.size;
    summary.aggregated_summaries = [...summary.aggregated_summaries];
    return summary;
  });
}

for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    const ruiLocation = block.rui_location['@id'];
    handleCellSummaries(ruiLocation, collisionLookup[ruiLocation]);
  }
}

const results = finalizeAsCellSummaries();

// Write out the new as-collisions.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
