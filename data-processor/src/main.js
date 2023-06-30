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

// Generate registrations
if (CLEAN || !existsSync('../data/rui_locations.jsonld')) {
  sh.exec('npm run generate:registrations');
}

// Generate dataset cell summaries
if (CLEAN || !existsSync('../data/dataset-cell-summaries.jsonld')) {
  sh.exec('npm run generate:dataset-cell-summaries');
}

// Generate rui location collisions
if (CLEAN || !existsSync('../data/collisions.jsonld')) {
  sh.exec('npm run generate:collisions');
}

// Combine the data
if (CLEAN || !existsSync('../data/enriched_rui_locations.jsonld')) {
  sh.exec('npm run generate:combined-data');
}

// Generate anatomical structures' cell type summaries
if (CLEAN || !existsSync('../data/as-cell-summaries.jsonld')) {
  sh.exec('npm run generate:as-cell-summaries');
}

// Generate csv reports
if (CLEAN || !existsSync('../data/reports')) {
  sh.exec('npm run generate:reports');
}