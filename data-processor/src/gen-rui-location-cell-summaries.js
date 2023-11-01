import { readFileSync, writeFileSync } from 'fs';

const OUTPUT = '../data/rui-location-cell-summaries.jsonld';
const donors = JSON.parse(readFileSync('../data/enriched_rui_locations.jsonld'));
const ruiCellSummaries = {};

function getCellSummaryRows(dataset) {
  const allSummaries = dataset.summaries ?? [];
  const summaries = allSummaries.reduce((acc, c) => acc.concat(c?.summary ?? []), []);
  return summaries;
}

function handleCellSummaries(dataset, ruiLocation) {
  const cellSummaryRows = getCellSummaryRows(dataset);
  const summary = (ruiCellSummaries[ruiLocation] = ruiCellSummaries[ruiLocation] || {
    '@type': 'CellSummary',
    cell_source: ruiLocation,
    annotation_method: 'Aggregation',
    aggregated_summary_count: 0,
    aggregated_summaries: new Set(),
    summary: [],
  });
  summary.aggregated_summaries.add(dataset['@id']);

  for (const cell of cellSummaryRows) {
    let summaryRow = summary.summary.find((s) => s.cell_id === cell.cell_id);
    if (summaryRow) {
      summaryRow.count += cell.count;
    } else {
      summaryRow = {
        '@type': 'CellSummaryRow',
        cell_id: cell.cell_id,
        cell_label: cell.cell_label,
        count: cell.count,
        percentage: 0, // to be computed at the end
      };
      summary.summary.push(summaryRow);
    }
  }
}

function finalizeCellSummaries() {
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
    for (const section of block.sections ?? []) {
      (section.datasets ?? []).forEach((ds) => handleCellSummaries(ds, ruiLocation));
    }
    (block.datasets ?? []).forEach((ds) => handleCellSummaries(ds, ruiLocation));
  }
}

const results = finalizeCellSummaries();

// Write out the new rui-location-cell-summaries.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
