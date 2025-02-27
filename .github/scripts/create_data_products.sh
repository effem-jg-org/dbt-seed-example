#!/bin/bash

if [[ ! -f metadata/output/data_products/source.yaml ]]; then
  echo "{}" | \
    jq -r \
      --arg gh_repo $(gh repo view --json url -q '.url') \
      '
      .dataProductSpecification += "0.0.1" |
      .id += "urn:dataproduct:project:jaffle-shop:dbt:jaffle-shop-raw" |
        
      .info += {
        "title": "dbt Jaffle Shop Raw",
        "description": "Example Jaffle Shop RAW Data provided by dbt/ created by dbt seed.",
        "owner": "enabling-team",
        "status": "development",
        "archetype": "consumer-aligned",
        "maturity": "managed"
      } |

      .inputPorts += [] |
      .outputPorts += [] |
        
      .tags += [
        "POC",
        "RAW"
      ] |

      .links += {
        "documentation": "$gh_repo/README.md",
        "catalog": "https://catalog.example.com/search/search-queries/",
        "repository": "$gh_repo"
      }
      ' > metadata/output/data_products/source.json
  
  for input in metadata/output/source_systems/*.json; do
    cat metadata/output/data_products/source.json | \
      jq -r \
        --arg id "$(jq -r '.id' $input)" \
        --arg title "$(jq -r '.name' $input)" \
        --arg description "$(jq -r '.description' $input)" \
        '.inputPorts += [{
          "id": $id,
          "name": $title,
          "description": $description,
          "sourceSystemId": $id,
          "autoApprove": false,
          "containsPii": false
        }]' > metadata/output/data_products/source.json
  done

  for output in metadata/output/data_contracts/*.json; do
    cat metadata/output/data_products/source.json | \
      jq -r \
        --arg id "$(jq -r '.id' $output)" \
        --arg title "$(jq -r '.info.title' $output)" \
        --arg description "$(jq -r '.info.description' $output)" \
        '.outputPorts += [{
          "id": $id,
          "name": $title,
          "description": $description,
          "dataContractId": $id,
          "autoApprove": false,
          "containsPii": false
        }]' > metadata/output/data_products/source.json
  done

  yq --yaml-output '.' metadata/output/data_products/source.json > metadata/output/data_products/source.yaml
fi