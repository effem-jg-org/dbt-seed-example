#!/bin/bash

if [[ ! -f metadata/output/source_systems/source.yaml ]]; then
  echo "{}" | \
    jq -r \
      '
      .id += "urn:sourcesystem:jaffle-shop:dbt-seed" |
      .name += "Jaffle Shop Example Data" |
      .owner += "enabling-team" |
      .description += "Example Jaffle Shop data provided by dbt/ created by dbt seed." |
      .tags += [
        "POC"
      ] |

      .links += {
        "homepage": "https://github.com/dbt-labs/jaffle-shop"
      }
      ' > metadata/output/source_systems/source.json

  yq --yaml-output '.' metadata/output/source_systems/source.json > metadata/output/source_systems/source.yaml
fi