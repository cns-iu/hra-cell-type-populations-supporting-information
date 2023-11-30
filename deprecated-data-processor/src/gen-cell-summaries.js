// Requires Node v18+ (for fetch support)
import { existsSync, readFileSync, writeFileSync } from 'fs';
import { globSync } from 'glob';
import Papa from 'papaparse';
import sh from 'shelljs';

const CSV_URL =
  'https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/export?format=csv&gid=1529271254';
const FIELDS =
  'unique_dataset_id,dataset_id,source,excluded_from_atlas_construction,paper_id,HuBMAP_tissue_block_id,sample_id,ccf_api_endpoint,CxG_dataset_id_donor_id_organ,non_hubmap_donor_id,organ,cell_type_annotation_tool'.split(
    ','
  );
const BASE_IRI = 'ctpop_datasets:';
const OUTPUT = '../data/dataset-cell-summaries.jsonld';
const DATASETS = '../data/datasets.jsonld';
const HUBMAP_TOKEN = process.env.HUBMAP_TOKEN;

// A HuBMAP Token is required as some datasets are unpublished
if (!HUBMAP_TOKEN) {
  console.log('Please run `export HUBMAP_TOKEN=xxxYourTokenyyy` and try again.');
  process.exit();
}

// Check out the tissue-bar-graphs repo with summary csv files
if (!existsSync('tissue-bar-graphs')) {
  console.log('Getting static cell type summary csv files...');
  sh.exec('git clone https://github.com/hubmapconsortium/tissue-bar-graphs -b static');
}

// Check out the hra-ct-summaries-mx-spatial-data repo with spatial summary csv files
if (!existsSync('hra-ct-summaries-mx-spatial-data')) {
  console.log('Getting static spatial cell type summary csv files...');
  sh.exec('git clone https://github.com/cns-iu/hra-ct-summaries-mx-spatial-data');
}

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

/**
 * Finds and converts a cell type summary from the tissue-bar-graphs repository for a dataset
 *
 * @param {string} id dataset id (will look for ${id}.csv)
 * @param {*} datasetIri the dataset iri to use for this summary
 * @param {*} dirPattern the optional glob to use inside the csv folder for lookup, default is '*'
 * @returns a cell summary in jsonld format or undefined
 */
function findCTSummary(id, datasetIri, dirPattern = '*') {
  const csvFiles = globSync([
    `hra-ct-summaries-mx-spatial-data/${dirPattern}/cell_type_counts/${id}.csv`,
    `tissue-bar-graphs/csv/${dirPattern}/${id}.csv`,
  ]);
  let result;
  if (csvFiles.length > 0) {
    if (!datasetIri) {
      datasetIri = id.startsWith('http') ? id : `${BASE_IRI}${encodeURIComponent(id)}`;
    }
    let modality = 'bulk';
    if (csvFiles[0].startsWith('hra-ct-summaries-mx-spatial-data')) {
      modality = 'spatial';
    }
    result = getCTSummary(csvFiles[0], datasetIri, modality);
    if (csvFiles.length > 1) {
      console.log(`Multiple matches for ${id}: \n\t${csvFiles.join('\n\t')}`);
    }
  }
  return result;
}

/**
 * For a given hubmap id, find related ids and see if they exist in the
 * tissue-bar-graphs repo. If so, return that for a cell summary.
 *
 * @param {string} id the hubmap id for the dataset
 * @param {string} datasetIri the dataset iri to use for this summary
 * @param {string} token the HuBMAP Token for gathering unpublished data
 * @returns a cell summary in jsonld format or undefined
 */
function tryRelatedHbmIds(id, datasetIri, token) {
  return fetch('https://search.api.hubmapconsortium.org/v3/portal/search', {
    method: 'POST',
    headers: token
      ? { 'Content-type': 'application/json', Authorization: `Bearer ${token}` }
      : { 'Content-type': 'application/json' },
    body: JSON.stringify({
      version: true,
      from: 0,
      size: 10000,
      query: {
        term: {
          'hubmap_id.keyword': id,
        },
      },
      _source: {
        includes: ['uuid', 'hubmap_id', 'descendants.hubmap_id', 'ancestors.hubmap_id'],
      },
    }),
  })
    .catch((r) => ({ ok: false }))
    .then((r) => (r.ok ? r.json() : undefined))
    .then((r) => {
      if (!r || r.hits.hits.length === 0) return;
      r = r.hits.hits[0]._source;
      const hbmIds = r.descendants.concat(r.ancestors).map((d) => d.hubmap_id);
      for (const id of hbmIds) {
        const ctSummary = findCTSummary(id, datasetIri);
        if (ctSummary) {
          return ctSummary;
        }
      }
    });
}

// Grab the datasets list from the given CSV_URL and convert to array of objects
const allDatasets = await fetch(CSV_URL, { redirect: 'follow' })
  .then((r) => r.text())
  .then(
    (r) => Papa.parse(r, { header: true /* fields: FIELDS */ }).data
    // .filter((row) => row.excluded_from_atlas_construction !== 'TRUE')
  );

const datasetObjects = [];
const results = [];
for (const dataset of allDatasets) {
  let id;
  let result;

  id = dataset.unique_dataset_id;
  result = findCTSummary(id);

  // Custom processing per dataset source (GTEx, HuBMAP, and CxG)
  if (dataset.source === 'HuBMAP' && !result) {
    // result = await tryRelatedHbmIds(id, `${BASE_IRI}${id}`);
    // if (!result) {
    //   // When no results, reformat the id output for easy checking in a browser
    //   id = `https://portal.hubmapconsortium.org/browse/${id}`;
    // }
  } else if (dataset.source === 'CxG' && !result) {
    // id = dataset.CxG_dataset_id_donor_id_organ;
    // const searchId = `${dataset.dataset_id}_${dataset.non_hubmap_donor_id}`;
    // result = findCTSummary(searchId, `${BASE_IRI}${id}`, `${dataset.organ}_CxG_Portal`);
  }

  id = encodeURI(id);

  // If data is found, add it to the growing list of registrations to output
  if (result) {
    results.push(result);
    datasetObjects.push({
      '@id': result.cell_source,
      '@type': 'Dataset',
      'ctpop:reported_organ': dataset.organ,
    });
  } else {
    console.log(`Investigate ${dataset.source}: ${id}`);
  }
}

if (results.length !== allDatasets.length) {
  console.log(
    `There was some problem saving out at least one dataset. Saved: ${results.length} Expected: ${allDatasets.length}`
  );
}

const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));

// Write out the new rui_locations.jsonld file
const datasetsJsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': datasetObjects,
};
writeFileSync(DATASETS, JSON.stringify(datasetsJsonld, null, 2));
