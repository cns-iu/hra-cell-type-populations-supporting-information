import { existsSync, readFileSync, writeFileSync } from 'fs';
import jsonld from 'jsonld';
import { namedNode } from 'oxigraph';
import { SparqlRunner } from './sparql.js';

const HRA_URL = 'https://purl.org/ccf/2.2.1/ccf.owl';
const HRA_PATH = '../data/ccf.owl';
const CTPOP_IRI =
  'https://cns-iu.github.io/hra-cell-type-populations-supporting-information/data/enriched_rui_locations.jsonld#graph';
const CTPOP_PATH = '../data/enriched_rui_locations.jsonld';

function fetchText(url) {
  return fetch(url, {
    redirect: 'follow',
  }).then((r) => r.text());
}

export async function getCtPopDb() {
  const engine = new SparqlRunner();
  const oxigraph = engine.engine;

  const ctpopData = JSON.parse(readFileSync(CTPOP_PATH));
  const ctpopQuads = await jsonld.toRDF(ctpopData, {
    format: 'application/n-quads',
  });
  oxigraph.load(
    ctpopQuads.toString(),
    'text/turtle',
    undefined,
    namedNode(CTPOP_IRI)
  );

  let hraOwl;
  if (!existsSync(HRA_PATH)) {
    hraOwl = await fetchText(HRA_URL);
    writeFileSync(HRA_PATH, hraOwl);
  } else {
    hraOwl = readFileSync(HRA_PATH).toString();
  }
  oxigraph.load(hraOwl, 'application/rdf+xml', undefined, namedNode(HRA_URL));

  return engine;
}
