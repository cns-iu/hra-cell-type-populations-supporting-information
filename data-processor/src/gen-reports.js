import { readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import { basename } from 'path';
import sh from 'shelljs';
import './utils/fetch-polyfill.js';
import { selectCsvRemote } from './utils/sparql.js';

// SPARQL endpoint with ctpop data loaded
//const SPARQL_ENDPOINT = 'https://api.triplydb.com/datasets/bherr/ctpop/services/ctpop/sparql';
// const SPARQL_ENDPOINT = 'https://lod.humanatlas.io/sparql';
// const SPARQL_ENDPOINT = 'https://ukiemb6svh.us-east-2.awsapprunner.com/blazegraph/namespace/kb/sparql';
// const SPARQL_ENDPOINT = 'https://lod.humanatlas.io/sparql-dev';
// const SPARQL_ENDPOINT = 'https://uwbpuqjrsa.us-east-2.awsapprunner.com/blazegraph/namespace/kb/sparql'
const SPARQL_ENDPOINT = 'http://localhost:8080/blazegraph/namespace/kb/sparql';

// Ensure reports output directory exists
sh.mkdir('-p', '../data/reports');

// Go through each query in queries, run them, and save out the csv report to ../data/reports/
for (const queryFile of globSync('queries/*.rq').sort()) {
  const isLarge = queryFile.endsWith('.lg.rq');
  
  const reportName = basename(queryFile, isLarge ? '.lg.rq' : '.rq');
  if (process.argv.length === 3 && !reportName.includes(process.argv[2])) {
    continue;
  }

  const reportCsv = `../data/reports/${reportName}.csv`;
  console.log('Creating report:', reportName);
  
  if (isLarge) {
    sh.exec(`./src/sparql-select.sh ${SPARQL_ENDPOINT} ${queryFile} > ${reportCsv}`);
  } else {
    const query = readFileSync(queryFile).toString();
    const csvString = await selectCsvRemote(query, SPARQL_ENDPOINT);
    writeFileSync(reportCsv, csvString);
  }
}
