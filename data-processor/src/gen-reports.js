import { readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import { basename } from 'path';
import sh from 'shelljs';
import { getCtPopDb } from './ctpop-db.js';

// Some queries don't run well in oxigraph. This allows us to run with an external sparql server.
const remoteQueries = new Set(['table-s2', 'rui-location-stats']);
const SPARQL_ENDPOINT = 'https://api.triplydb.com/datasets/bherr/ctpop/services/ctpop/sparql';

// Ensure reports output directory exists
sh.mkdir('-p', '../data/reports');

// Initialize a SPARQL database with CTPop and HRA loaded
const engine = await getCtPopDb();

// Go through each query in queries, run them, and save out the csv report to ../data/reports/
for (const queryFile of globSync('queries/*.rq')) {
  const reportName = basename(queryFile, '.rq');
  if (remoteQueries.has(reportName)) {
    console.log('Creating report via remote SPARQL Endpoint:', reportName);

    const query = readFileSync(queryFile).toString();
    const csvString = await engine.selectCsvRemote(query, SPARQL_ENDPOINT);
    writeFileSync(`../data/reports/${reportName}.csv`, csvString);
  } else {
    console.log('Creating report:', reportName);

    const query = readFileSync(queryFile).toString();
    const csvString = engine.selectCsv(query);
    writeFileSync(`../data/reports/${reportName}.csv`, csvString);
  }
}
