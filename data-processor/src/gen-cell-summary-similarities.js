import { readFileSync, writeFileSync } from 'fs';
import { getAllCellSummarySimilarities } from './utils/cell-summary-similarity.js';

const OUTPUT = '../data/cell-summary-similarities.jsonld';

const allSummaries = [
  '../data/dataset-cell-summaries.jsonld',
  '../data/as-cell-summaries.jsonld',
  '../data/rui-location-cell-summaries.jsonld',
]
  .map((path) => JSON.parse(readFileSync(path))['@graph'])
  .reduce((acc, arr) => acc.concat(arr), []);

const results = [...getAllCellSummarySimilarities(allSummaries)];

// Write out the new enriched_rui_locations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
