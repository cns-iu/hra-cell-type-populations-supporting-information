import { readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import { basename } from 'path';
import sh from 'shelljs';
import { getCtPopDb } from './ctpop-db.js';

// Some queries don't run well in oxigraph. This allows us to skip those for now.
const queriesToSkip = new Set(['table-s2']);

// Ensure reports output directory exists
sh.mkdir('-p', '../data/reports');

// Initialize a SPARQL database with CTPop and HRA loaded
const engine = await getCtPopDb();

// Go through each query in queries, run them, and save out the csv report to ../data/reports/
for (const queryFile of globSync('queries/*.rq')) {
  const reportName = basename(queryFile, '.rq');
  if (queriesToSkip.has(reportName)) {
    console.log('Skipping report (for now):', reportName);
  } else {
    console.log('Creating report:', reportName);

    const query = readFileSync(queryFile).toString();
    const csvString = engine.selectCsv(query);
    writeFileSync(`../data/reports/${reportName}.csv`, csvString);
  }
}
