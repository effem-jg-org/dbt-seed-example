#!/bin/bash

source .venv/bin/activate

DQ_RULES=$(ls soda/jaffle_shop_*.yaml | tr '\n' ' ')
soda test-connection \
  --data-source ${1} \
  --configuration soda/configuration.yaml

soda scan \
  --data-source ${1} \
  --configuration soda/configuration.yaml \
  --scan-results-file metadata/output/data_quality/${1}_scan_results.json \
  ${DQ_RULES}

deactiavate