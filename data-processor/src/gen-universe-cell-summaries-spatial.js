import { readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import Papa from 'papaparse';
import { basename } from 'path';

const OUTPUT = '../data/universe-cell-summaries-spatial.jsonld';
const SPATIAL_CSV_PATTERN = 'hra-ct-summaries-mx-spatial-data/**/cell_type_counts/*.csv';
const BASE_IRI = 'ctpop_datasets:';

/**
 * Normalize cell type ids, generating one if needed
 *
 * @param {string} id a cell type ID or undefined
 * @param {*} label a cell type label
 * @returns a normalized, ontology friendly cell type id
 */
function normalizeCellType(id, label) {
  if (!id && label) {
    const suffix = label
      .toLowerCase()
      .trim()
      .replace(/\W+/g, '-')
      .replace(/[^a-z0-9-]+/g, '');
    id = `ASCTB-TEMP:${suffix}`; // expands to `https://purl.org/ccf/ASCTB-TEMP_${suffix}`;
  }
  return id;
}

/**
 * Get a cell type summary csv and convert it to a jsonld-compatible format
 *
 * @param {string} path path to a CSV file
 * @param {string} datasetIri the dataset iri for this summary
 * @returns a cell summary in jsonld format
 */
function getCTSummary(path, datasetIri, modality = undefined) {
  const rows = Papa.parse(readFileSync(path).toString(), { header: true }).data;
  const summary = rows
    .map((r) => ({
      '@type': 'CellSummaryRow',
      cell_id: normalizeCellType(r.cell_type_ontology_id, r.cell_type),
      cell_label: r.cell_type,
      count: +r.count,
    }))
    .filter((r) => r.cell_label || r.cell_id);
  const maxCount = summary.reduce((acc, s) => acc + s.count, 0);
  summary.forEach((s) => (s.percentage = s.count / maxCount));

  return {
    '@type': 'CellSummary',
    cell_source: datasetIri,
    annotation_method: 'Ad-Hoc',
    modality,
    summary,
  };
}

const results = [];
for (const csvFile of globSync(SPATIAL_CSV_PATTERN)) {
  const id = basename(csvFile, '.csv');
  const datasetIri = `${BASE_IRI}${id}`;
  const summary = getCTSummary(csvFile, datasetIri, 'spatial');
  results.push(summary);
}

const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
