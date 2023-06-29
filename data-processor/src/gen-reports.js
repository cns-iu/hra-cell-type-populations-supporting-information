import { readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import { basename } from 'path';
import sh from 'shelljs';
import { getCtPopDb } from './ctpop-db.js';

// Ensure reports output directory exists
sh.mkdir('-p', '../data/reports');

// Initialize a SPARQL database with CTPop and HRA loaded
const engine = await getCtPopDb();

// Go through each query in queries, run them, and save out the csv report to ../data/reports/
for (const queryFile of globSync('queries/*.rq')) {
  const reportName = basename(queryFile, '.rq');
  console.log(`Creating report:`, reportName);

  const query = readFileSync(queryFile).toString();
  const csvString = engine.selectCsv(query);
  writeFileSync(`../data/reports/${reportName}.csv`, csvString);
}
