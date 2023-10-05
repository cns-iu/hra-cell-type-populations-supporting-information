// Requires Node v18+ (for fetch support)
import { readFileSync, writeFileSync } from 'fs';

const OUTPUT = '../data/universe-registrations.jsonld';
const ATLAS_REGISTRATIONS = '../data/atlas-registrations.jsonld';
const COMBINED_OUTPUT = '../data/rui_locations.jsonld';

const REGISTRATION_URLS = [
  'https://ccf-api.hubmapconsortium.org/v1/hubmap/rui_locations.jsonld',
  'https://ccf-api.hubmapconsortium.org/v1/gtex/rui_locations.jsonld',
  'https://hubmapconsortium.github.io/hra-registrations/federated/rui_locations.jsonld'
];

const allRegistrations = await Promise.all(
  REGISTRATION_URLS.map((url) => fetch(url).then(r => r.json()))
);

const results = allRegistrations.reduce((acc, graph) => acc.concat(graph['@graph']), []);

// Write out the new universe-registrations.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results,
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));

// Write the combined rui_locations.jsonld file
const combined = JSON.parse(readFileSync(ATLAS_REGISTRATIONS).toString());
combined['@graph'] = combined['@graph'].concat(results);

writeFileSync(COMBINED_OUTPUT, JSON.stringify(combined, null, 2));
