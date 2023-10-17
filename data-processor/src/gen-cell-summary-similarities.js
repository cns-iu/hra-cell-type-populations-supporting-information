import { createWriteStream, readFileSync } from 'fs';
import { createGzip } from 'zlib';
import { getAllCellSummarySimilarities } from './utils/cell-summary-similarity.js';

const OUTPUT = '../data/cell-summary-similarities.jsonl.gz';

const allSummaries = [
  '../data/dataset-cell-summaries.jsonld',
  '../data/as-cell-summaries.jsonld',
  '../data/rui-location-as-cell-summaries.jsonld',
]
  .map((path) => JSON.parse(readFileSync(path))['@graph'])
  .reduce((acc, arr) => acc.concat(arr), [])
  .sort((a, b) => a['cell_source'].localeCompare(b['cell_source']));

const results = createWriteStream(OUTPUT, { autoClose: true });
const gzip = createGzip({ level: 9 });
gzip.pipe(results);

for (const result of getAllCellSummarySimilarities(allSummaries)) {
  gzip.write(JSON.stringify(result) + '\n');
}

gzip.end();
