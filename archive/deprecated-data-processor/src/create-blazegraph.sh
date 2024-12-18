#!/bin/bash

JNL=../data/blazegraph.jnl
rm -f $JNL

CTPOP=https://purl.humanatlas.io/graph/ctpop
CCF=https://purl.org/ccf/releases/2.2.1/ccf.owl

run_ndjsonld() {
  zcat $1 | ndjsonld canonize - $2 -c ccf-context.jsonld 
  blazegraph-runner load --journal=$JNL "--graph=${3}" $2
}

run_jsonld() {
  jsonld canonize $1 |
    rdfpipe -i nquads -o ttl - \
      --ns=ccf=http://purl.org/ccf/ \
      --ns=dcterms=http://purl.org/dc/terms/ \
      "--ns=ctpop=${CTPOP}" \
    > $2
  blazegraph-runner load --journal=$JNL "--graph=${3}" $2
}

# Atlas Data
run_jsonld ../data/enriched_rui_locations.jsonld ../data/enriched_rui_locations.ttl "${CTPOP}"
run_jsonld ../data/as-cell-summaries.jsonld ../data/as-cell-summaries.ttl "${CTPOP}"

# Universe of Registrations
run_jsonld ../data/rui_locations.jsonld ../data/rui_locations.ttl "${CTPOP}#registrations"
run_jsonld ../data/collisions.jsonld ../data/collisions.ttl "${CTPOP}#registrations"
run_jsonld ../data/corridors.jsonld ../data/corridors.ttl "${CTPOP}#registrations"
run_jsonld ../data/rui-location-as-cell-summaries.jsonld ../data/rui-location-as-cell-summaries.ttl "${CTPOP}#registrations"

# 'Universe' of Datasets
run_jsonld ../data/dataset-cell-summaries.jsonld ../data/dataset-cell-summaries.ttl "${CTPOP}#datasets"
run_jsonld ../data/datasets.jsonld ../data/datasets.ttl "${CTPOP}#datasets"

# Precomputed distances and cosine similarities
run_jsonld ../data/rui-location-distances.jsonld ../data/rui-location-distances.ttl "${CTPOP}#distances"
run_ndjsonld ../data/cell-summary-similarities.jsonl.gz ../data/cell-summary-similarities.ttl "${CTPOP}#similarities"

if [ ! -e ../data/ccf.owl ]; then
  curl -L $CCF > ../data/ccf.owl
fi

blazegraph-runner load --journal=$JNL "--graph=${CCF}" ../data/ccf.owl

echo "Start the Blazegraph Server and press Enter"
read -t 120
