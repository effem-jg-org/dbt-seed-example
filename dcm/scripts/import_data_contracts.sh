#!/bin/bash

source .venv/bin/activate

export DBML_SCHEMA=$(find *.dbml)

if [ ! -f metadata/output/data_contracts/raw_supplies.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_supplies \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_supplies.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:supplies" |
      .info.title |= "Jaffle Shop RAW Supplies Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Supplies Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_supplies.yaml
fi

if [ ! -f metadata/output/data_contracts/raw_stores.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_stores \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_stores.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:stores" |
      .info.title |= "Jaffle Shop RAW Stores Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Stores Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_stores.yaml
fi

if [ ! -f metadata/output/data_contracts/raw_products.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_products \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_products.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:products" |
      .info.title |= "Jaffle Shop RAW Products Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Products Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_products.yaml
fi

if [ ! -f metadata/output/data_contracts/raw_orders.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_orders \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_orders.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:orders" |
      .info.title |= "Jaffle Shop RAW Orders Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Orders Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_orders.yaml
fi

if [ ! -f metadata/output/data_contracts/raw_customers.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_customers \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_customers.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:customers" |
      .info.title |= "Jaffle Shop RAW Customers Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Customers Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_customers.yaml
fi

if [ ! -f metadata/output/data_contracts/raw_items.yaml ]; then
  datacontract import \
    --format dbml \
    --source ${DBML_SCHEMA} \
    --dbml-schema $( echo "${DBML_SCHEMA}" | cut -d'.' -f1 | tr '-' '_' ) \
    --dbml-table raw_items \
    --template enablement_team_contract_template.yaml \
    --output metadata/output/data_contracts/raw_items.yaml
  
  yq -i --yaml-output \
    --arg version $(date '+%Y.%m.%d') \
    '
      .id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:items" |
      .info.title |= "Jaffle Shop RAW Items Data Contract" |
      .info.description |= "Data Contract for Example Jaffle Shop RAW Items Data provided by dbt/ created by dbt seed." |
      .info.version |= $version
    ' \
    metadata/output/data_contracts/raw_items.yaml
fi

if [ "${1}" == "databricks" ]; then
  export DATABRICKS_CATALOG=$(cat dbt/logs/dbt_databricks_${DBT_ENV_TARGET}_config.log | grep -Po '(?<=catalog:\s)[a-zA-Z0-9_]+')
  export DATABRICKS_SCHEMA=$(cat dbt/logs/dbt_databricks_${DBT_ENV_TARGET}_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

  for contract in metadata/output/data_contracts/*.yaml; do
    if ! $( yq 'has("servers")' ${contract} ); then
      yq -i --yaml-output \
        --arg serverName "dna_databricks_${DBT_ENV_TARGET}" \
        --arg host ${DBT_ENV_SECRET_DATABRICKS_HOST:-NA} \
        --arg catalog ${DATABRICKS_CATALOG:-NA} \
        --arg schema ${DATABRICKS_SCHEMA:-NA} \
      '
        .servers |= {($serverName):
            {
              "type": "databricks",
              "host": $host,
              "catalog": $catalog,
              "schema": $schema
            }
          }
      ' ${contract}
    elif ! $( yq --arg serverName "dna_databricks_${DBT_ENV_TARGET}" '.servers | has($serverName)' ${contract} ); then
      yq -i --yaml-output \
        --arg serverName "dna_databricks_${DBT_ENV_TARGET}" \
        --arg host ${DBT_ENV_SECRET_DATABRICKS_HOST:-NA} \
        --arg catalog ${DATABRICKS_CATALOG:-NA} \
        --arg schema ${DATABRICKS_SCHEMA:-NA} \
      '
        .servers += {($serverName): 
            {
              "type": "databricks",
              "host": $host,
              "catalog": $catalog,
              "schema": $schema
            }
          }
      ' ${contract}
    fi
  done

elif [ "${1}" == "snowflake" ]; then

  export SNOWFLAKE_DATABASE=$(cat dbt/logs/dbt_snowflake_${DBT_ENV_TARGET}_config.log | grep -Po '(?<=database:\s)[a-zA-Z0-9_]+')
  export SNOWFLAKE_SCHEMA=$(cat dbt/logs/dbt_snowflake_${DBT_ENV_TARGET}_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

  for contract in metadata/output/data_contracts/*.yaml; do
    if ! $( yq 'has("servers")' ${contract} ); then
      yq -i --yaml-output \
        --arg serverName "dna_snowflake_${DBT_ENV_TARGET}" \
        --arg account ${DBT_ENV_SECRET_SNOWFLAKE_ACCOUNT:-NA} \
        --arg database ${SNOWFLAKE_DATABASE:-NA} \
        --arg schema ${SNOWFLAKE_SCHEMA:-NA} \
        '
          .servers |= {($serverName):
            {
              "type": "snowflake",
              "account": $account,
              "database": $database,
              "schema": $schema
            }
          }
      ' ${contract}
    elif ! $( yq --arg serverName "dna_snowflake_${DBT_ENV_TARGET}" '.servers | has($serverName)' ${contract} ); then
      yq -i --yaml-output \
        --arg serverName "dna_snowflake_${DBT_ENV_TARGET}" \
        --arg account ${DBT_ENV_SECRET_SNOWFLAKE_ACCOUNT:-NA} \
        --arg database ${SNOWFLAKE_DATABASE:-NA} \
        --arg schema ${SNOWFLAKE_SCHEMA:-NA} \
        '
          .servers += {($serverName):
            {
              "type": "snowflake",
              "account": $account,
              "database": $database,
              "schema": $schema
            }
          }
      ' ${contract}
    fi
  done
  
fi

deactivate