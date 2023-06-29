import { readFileSync, writeFileSync } from 'fs';

const OUTPUT='../data/collisions.jsonld';
const donors = JSON.parse(readFileSync('../data/rui_locations.jsonld'));
const API='https://pfn8zf2gtu.us-east-2.awsapprunner.com/get-collisions';

function getCollisions(ruiLocation) {
  return fetch(API, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(ruiLocation)
  }).then(r => r.json()).catch(e => (console.log(e), []));
}

// Find all datasets in rui_locations.jsonld and add run collision detection on them
const results = [];
let bad = 0;
for (const donor of donors['@graph']) {
  for (const block of donor.samples ?? []) {
    if (block.rui_location) {
      const collisions = await getCollisions(block.rui_location);
      results.push({
        '@type': 'CollisionSummary',
        collision_source: block.rui_location['@id'],
        collision_method: 'MESH',
        collisions: collisions.filter(c => c.percentage_of_tissue_block > 0 && c.representation_of !== '-').map(c => ({
          '@type': 'CollisionItem',
          reference_organ: block.rui_location.placement.target,
          as_3d_id: c.id,
          as_id: c.representation_of,
          as_label: c.label,
          as_volume: c.AS_volume,
          percentage: c.percentage_of_tissue_block
        }))
      });
      
      if (collisions.length === 0) {
        bad++;
      }
    }
  }
}

if (bad > 0) {
  console.log(`WARNING ${bad} RUI locations had zero collisions`);
}

// Write out the new collisions.jsonld file
const jsonld = {
  ...JSON.parse(readFileSync('ccf-context.jsonld')),
  '@graph': results
};
writeFileSync(OUTPUT, JSON.stringify(jsonld, null, 2));
