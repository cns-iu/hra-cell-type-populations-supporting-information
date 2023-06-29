# Data Processor for CTPop

## Quick Start

- You can view the latest version in an EUI instance [here](https://cns-iu.github.io/hra-cell-type-populations-supporting-information/data/)
- You can review the primary enriched data [here](../data/enriched_rui_locations.jsonld)
- You can review the full cell summaries data [here](../data/dataset-cell-summaries.jsonld)
- More data for use is in the [data directory](../data/)

## Rebuilding the jsonld files

To rebuild the data in the [data directory](../data/):

1. Install node.js v18 or higher

2. Grab a hubmap token and set an environment variable: `export HUBMAP_TOKEN=xxxMyTokenYyyy`

3. Install the prerequisites: `npm ci`

4. Finally run `npm start clean` to regenerate the data in the [data](../data/) directory. Run `npm start` if you want to run data processing for missing files.

To recap:

```bash
export HUBMAP_TOKEN=xxxMyTokenYyyy
npm ci
npm start clean
```
