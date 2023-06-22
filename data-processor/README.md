# Data Processor for CTPop

## Quick Start

- You can view the latest version in an EUI instance [here](https://cns-iu.github.io/hra-cell-type-populations-supporting-information/data/)
- You can review the registrations [here](../data/rui_locations.jsonld)
- You can review the cell summaries [here](../data/cell-summaries.jsonld)
- You can review the combined data [here](../data/rui_locations_with_summaries.jsonld)

## Rebuilding the jsonld files

To rebuild the rui_locations.jsonld file:

1. Install node.js v18 or higher

2. Grab a hubmap token and set an environment variable: `export HUBMAP_TOKEN=xxxMyTokenYyyy`

3. Install the prerequisites: `npm ci`

4. Finally run `npm start` to regenerate the rui_locations.jsonld, cell-summaries.jsonld, and rui_locations_with_summaries.jsonld

To recap:

```bash
export HUBMAP_TOKEN=xxxMyTokenYyyy
npm ci
npm start
```
