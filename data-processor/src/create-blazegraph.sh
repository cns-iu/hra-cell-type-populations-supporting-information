#!/bin/bash

JNL=../data/blazegraph.jnl
rm -f $JNL

CTPOP=https://cns-iu.github.io/hra-cell-type-populations-supporting-information/data/enriched_rui_locations.jsonld#
CCF=https://purl.org/ccf/releases/2.2.1/ccf.owl

jsonld canonize ../data/enriched_rui_locations.jsonld |
  rdfpipe -i nquads -o ttl - \
    --ns=ccf=http://purl.org/ccf/ \
    --ns=dcterms=http://purl.org/dc/terms/ \
    "--ns=ctpop=${CTPOP}" \
  > ../data/enriched_rui_locations.ttl

blazegraph-runner load --journal=$JNL "--graph=${CTPOP}graph" ../data/enriched_rui_locations.ttl

if [ ! -e ../data/ccf.owl ]; then
  curl -L $CCF > ../data/ccf.owl
fi

blazegraph-runner load --journal=$JNL "--graph=${CCF}" ../data/ccf.owl
