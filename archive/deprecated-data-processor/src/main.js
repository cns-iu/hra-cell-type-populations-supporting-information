import { existsSync } from 'fs';
import sh from 'shelljs';

const CLEAN = process.argv[2] === 'clean';
const HUBMAP_TOKEN = process.env.HUBMAP_TOKEN;

// A HuBMAP Token is required as some datasets are unpublished
if (!HUBMAP_TOKEN) {
  console.log(
    'Please run `export HUBMAP_TOKEN=xxxYourTokenyyy` and try again.'
  );
  process.exit();
}

// Check out the hra-ct-summaries-mx-spatial-data repo with spatial summary csv files
if (!existsSync('hra-ct-summaries-mx-spatial-data')) {
  console.log('Getting static spatial cell type summary csv files...');
  sh.exec(
    'git clone https://github.com/cns-iu/hra-ct-summaries-mx-spatial-data'
  );
} else if (CLEAN) {
  // update hra-ct-summaries-mx-spatial-data if its already checked out an CLEAN is true
  sh.exec('cd hra-ct-summaries-mx-spatial-data; git pull origin main');
}

// Check out the tissue-bar-graphs repo with summary csv files
if (!existsSync('tissue-bar-graphs')) {
  console.log('Getting static cell type summary csv files...');
  sh.exec(
    'git clone https://github.com/hubmapconsortium/tissue-bar-graphs -b static'
  );
} else if (CLEAN) {
  // update tissue-bar-graphs if its already checked out an CLEAN is true
  sh.exec('cd tissue-bar-graphs; git pull origin static');
}

// Generate universe spatial dataset cell summaries
if (CLEAN || !existsSync('../data/gen-universe-cell-summaries-spatial.jsonld')) {
  sh.exec('npm run generate:universe-cell-summaries-spatial');
}

// Generate universe bulk dataset cell summaries
if (CLEAN || !existsSync('../data/gen-universe-cell-summaries-bulk.jsonld')) {
  sh.exec('npm run generate:universe-cell-summaries-bulk');
}

// Generate universe registrations
if (CLEAN || !existsSync('../data/gen-universe-registrations.jsonld')) {
  sh.exec('npm run generate:universe-registrations');
}

// Generate registrations
if (CLEAN || !existsSync('../data/rui_locations.jsonld')) {
  sh.exec('npm run generate:registrations');
}

// Generate rui location cell summaries
if (CLEAN || !existsSync('../data/rui-location-cell-summaries.jsonld')) {
  sh.exec('npm run generate:rui-location-cell-summaries');
}

// Generate dataset cell summaries
if (CLEAN || !existsSync('../data/dataset-cell-summaries.jsonld')) {
  sh.exec('npm run generate:dataset-cell-summaries');
}

// Generate rui location collisions
if (CLEAN || !existsSync('../data/collisions.jsonld')) {
  sh.exec('npm run generate:collisions');
}

// Generate rui location corridors
if (CLEAN || !existsSync('../data/corridors.jsonld')) {
  sh.exec('npm run generate:corridors');
}

// Combine the data
if (CLEAN || !existsSync('../data/enriched_rui_locations.jsonld')) {
  sh.exec('npm run generate:combined-data');
}

// Generate anatomical structures' cell type summaries
if (CLEAN || !existsSync('../data/as-cell-summaries.jsonld')) {
  sh.exec('npm run generate:as-cell-summaries');
}

// Generate rui location as cell summaries
if (CLEAN || !existsSync('../data/rui-location-as-cell-summaries.jsonld')) {
  sh.exec('npm run generate:rui-location-as-cell-summaries');
}

// Generate cell summary similarity scores
if (CLEAN || !existsSync('../data/cell-summary-similarities.jsonld')) {
  sh.exec('npm run generate:cell-summary-similarities');
}

// Generate rui location euclidian distances
if (CLEAN || !existsSync('../data/rui-location-distances.jsonld')) {
  sh.exec('npm run generate:rui-location-distances');
}

// Combine the data (again)
if (CLEAN || !existsSync('../data/enriched_rui_locations.jsonld')) {
  sh.exec('npm run generate:combined-data');
}

// Create the blazegraph database for querying
if (CLEAN || !existsSync('../data/blazegraph.jnl')) {
  sh.exec('./src/create-blazegraph.sh');
}

// Generate csv reports
if (CLEAN || !existsSync('../data/reports')) {
  sh.exec('npm run generate:reports');
}
