// Requires Node v18+ (for fetch support)
import { readFileSync, writeFileSync } from 'fs';

const REGISTRATION_URLS = [
  'https://ccf-api.hubmapconsortium.org/v1/hubmap/rui_locations.jsonld',
  'https://ccf-api.hubmapconsortium.org/v1/gtex/rui_locations.jsonld',
  'https://hubmapconsortium.github.io/hra-registrations/federated/rui_locations.jsonld'
];

const all_registrations = await Promise.all(
  REGISTRATION_URLS.map((url) => fetch(url).then(r => r.json()))
);

const results = all_registrations.reduce((acc, graph) => acc.concat(graph['@graph']), []);

// Write out the new rui_locations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
