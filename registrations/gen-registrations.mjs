// Requires Node v18+ (for fetch support)
import { writeFileSync } from 'fs';
import Papa from 'papaparse';

const CSV_URL='https://docs.google.com/spreadsheets/d/1cwxztPg9sLq0ASjJ5bntivUk6dSKHsVyR1bE6bXvMkY/export?format=csv&gid=1529271254'
const FIELDS='dataset_id,source,excluded,paper_id,HuBMAP_tissue_block_id,sample_id,ccf_api_endpoint,CxG_dataset_id_donor_id_organ'.split(',');
const BASE_IRI='https://cns-iu.github.io/hra-cell-type-populations-supporting-information/registrations/rui_locations.jsonld#';
const OUTPUT='rui_locations.jsonld'
const HUBMAP_TOKEN=process.env.HUBMAP_TOKEN;

if (!HUBMAP_TOKEN) {
  console.log('Please run `export HUBMAP_TOKEN=xxxYourTokenyyy` and try again.')
  process.exit();
}

// Some rui_locations.jsonld may need to be remapped. You can specify old => new url mappings here.
const ALIASES = {
  'https://dw-dot.github.io/hra-cell-type-populations-rui-json-lds/AllenWangLungMap_rui_locations.jsonld': 'https://cns-iu.github.io/hra-cell-type-populations-rui-json-lds/AllenWangLungMap_rui_locations.jsonld'
}
const dataSources = {};

async function getDataSource(url) {
  url = ALIASES[url] || url;
  if (url === 'https://ccf-api.hubmapconsortium.org/v1/hubmap/rui_locations.jsonld' && HUBMAP_TOKEN) {
    url += `?token=${HUBMAP_TOKEN}`; 
  }
  if (!dataSources[url]) {
    const graph = await fetch(url).then(r => r.json());
    if (Array.isArray(graph)) {
      dataSources[url] = graph;
    } else if (graph['@graph']) {
      dataSources[url] = graph['@graph'];
    } else if (graph['@type']) {
      dataSources[url] = [ graph ];
    }
  }
  return dataSources[url];
}

function findInData(data, { donorId, ruiLocation, sampleId, datasetId }) {
  for (const donor of data) {
    if (donor['@id'] === donorId) {
      return { donor };
    }

    for (const block of donor.samples ?? []) {
      if (block['@id'] === sampleId || block.rui_location['@id'] === ruiLocation) {
        return { donor, block };
      }

      for (const section of block.samples ?? []) {
        if (section['@id'] === sampleId) {
          return { donor, block, section };
        }

        for (const sectionDataset of section.datasets ?? []) {
          if (sectionDataset['@id'] === datasetId) {
            return { donor, block, section, dataset: sectionDataset };
          }
        }
      }
      for (const blockDataset of block.datasets ?? []) {
        if (blockDataset['@id'] === datasetId) {
          return { donor, block, dataset: blockDataset };
        }
      }
    }
  }
}

function getHbmToUuidLookup(hubmap_ids, token) {
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
        terms: {
          'hubmap_id.keyword': hubmap_ids
        }
      },
      _source: {
        includes: ['uuid', 'hubmap_id'],
      },
    }),
  })
    .then((r) => r.json())
    .then((r) => r.hits.hits.map((n) => n._source))
    .then((r) => r.reduce((acc, row) => (acc[row.hubmap_id] = `https://entity.api.hubmapconsortium.org/entities/${row.uuid}`, acc), {}))
}

const allDatasets = await fetch(CSV_URL, {redirect: 'follow'}).then(r => r.text()).then(r => Papa.parse(r, { header: true, fields: FIELDS }).data.filter(row => row.excluded !== 'TRUE'));

const hbmLookup = await getHbmToUuidLookup([
  ...allDatasets.filter(d => d.source === 'HuBMAP').map(d => d.dataset_id),
  ...allDatasets.filter(d => d.source === 'HuBMAP').map(d => d.HuBMAP_tissue_block_id),
], HUBMAP_TOKEN);

const results = [];
const donors = {};
const blocks = {};
const datasets = {};

for (const dataset of allDatasets) {
  const data = await getDataSource(dataset.ccf_api_endpoint);

  let id;
  let result;
  if (dataset.source === 'GTEx') {
    id = dataset.dataset_id;
    result = findInData(data, { sampleId: dataset.sample_id });
  } else if (dataset.source === 'HuBMAP') {
    id = dataset.dataset_id;
    const datasetId = hbmLookup[id];
    result = findInData(data, { datasetId });
    if (!result) {
      const sampleId = hbmLookup[dataset.HuBMAP_tissue_block_id];
      result = findInData(data, { sampleId });
      if (!result) {
        console.log(`Investigate ${id}, ${sampleId}`);
      }
    }
  } else if (dataset.source === 'CxG') {
    id = dataset.CxG_dataset_id_donor_id_organ;
    result = findInData(data, { ruiLocation: dataset.sample_id.split('_')[0] });
    if (!result) {
      const sampleId = dataset.sample_id;
      result = findInData(data, { sampleId });
    }
  }
  if (result) {
    const donorId = result.donor['@id'];
    if (!donors[donorId]) {
      donors[donorId] = {
        '@context': 'https://hubmapconsortium.github.io/hubmap-ontology/ccf-entity-context.jsonld',
        ...result.donor,
        samples: []
      };
      results.push(donors[donorId]);
    }
    const donor = donors[donorId];

    const blockId = result.block['@id'];
    if (!blocks[blockId]) {
      blocks[blockId] = {
        ...result.block,
        sections: [],
        datasets: []
      };
      donor.samples.push(blocks[blockId]);
    }
    const block = blocks[blockId];

    const datasetIri = `${BASE_IRI}${id}`
    let hraDataset;
    if (result.dataset) {
      hraDataset = Object.assign(
        { '@id': datasetIri }, // makes sure '@id' is first
        result.dataset,
        { '@id': datasetIri }
      );
    } else {
      hraDataset = {
        '@id': datasetIri,
        '@type': 'Dataset',
        label: block.label,
        description: block.description,
        link: dataset.paper_id || block.link,
        technology: 'OTHER',
        thumbnail: 'assets/icons/ico-unknown.svg' 
      }
    }
    block.datasets.push(hraDataset);
    datasets[hraDataset['@id']] = hraDataset;
  } else {
    console.log(`Investigate ${dataset.source}: ${id}`);
  }
}

const savedDatasets = Object.keys(datasets).length;
if (savedDatasets !== allDatasets.length) {
  console.log(`There was some problem saving out at least one dataset. Saved: ${savedDatasets} Expected: ${allDatasets.length}`);
}

writeFileSync(OUTPUT, JSON.stringify(results, null, 2));
