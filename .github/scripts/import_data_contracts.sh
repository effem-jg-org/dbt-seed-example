export DATABRICKS_DEV_CATALOG=$(cat ./dbt/logs/dbt_databricks_dev_config.log | grep -Po '(?<=catalog:\s)[a-zA-Z0-9_]+')
export DATABRICKS_DEV_SCHEMA=$(cat ./dbt/logs/dbt_databricks_dev_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

export DATABRICKS_PROD_CATALOG=$(cat ./dbt/logs/dbt_databricks_prod_config.log | grep -Po '(?<=catalog:\s)[a-zA-Z0-9_]+')
export DATABRICKS_PROD_SCHEMA=$(cat ./dbt/logs/dbt_databricks_prod_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

export SNOWFLAKE_DEV_DATABASE=$(cat ./dbt/logs/dbt_snowflake_dev_config.log | grep -Po '(?<=database:\s)[a-zA-Z0-9_]+')
export SNOWFLAKE_DEV_SCHEMA=$(cat ./dbt/logs/dbt_snowflake_dev_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

export SNOWFLAKE_PROD_DATABASE=$(cat ./dbt/logs/dbt_snowflake_prod_config.log | grep -Po '(?<=database:\s)[a-zA-Z0-9_]+')
export SNOWFLAKE_PROD_SCHEMA=$(cat ./dbt/logs/dbt_snowflake_prod_config.log | grep -Po '(?<=schema:\s)[a-zA-Z0-9_]+')

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table supplies \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_supplies.yaml

cat metadata/output/data_contracts/raw_supplies.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:supplies"' | \
  jq '.info.title |= "Jaffle Shop RAW Supplies Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Supplies Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_supplies.json

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table stores \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_stores.yaml

cat metadata/output/data_contracts/raw_stores.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:stores"' | \
  jq '.info.title |= "Jaffle Shop RAW Stores Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Stores Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_stores.json

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table products \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_products.yaml

cat metadata/output/data_contracts/raw_products.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:products"' | \
  jq '.info.title |= "Jaffle Shop RAW Products Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Products Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_products.json

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table orders \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_orders.yaml

cat metadata/output/data_contracts/raw_orders.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:orders"' | \
  jq '.info.title |= "Jaffle Shop RAW Orders Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Orders Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_orders.json

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table items \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_items.yaml

cat metadata/output/data_contracts/raw_items.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:items"' | \
  jq '.info.title |= "Jaffle Shop RAW Items Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Items Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_items.json

datacontract import \
  --format dbml \
  --source jaffle-shop.dbml \
  --dbml-schema contract_first_raw \
  --dbml-table customers \
  --template enablement_team_contract_template.yaml \
  --output metadata/output/data_contracts/raw_customers.yaml

cat metadata/output/data_contracts/raw_customers.yaml | yq | \
  jq '.id |= "urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:customers"' | \
  jq '.info.title |= "Jaffle Shop RAW Customers Data Contract"' | \
  jq '.info.description |= "Data Contract for Example Jaffle Shop RAW Customers Data provided by dbt/ created by dbt seed."' | \
  jq --arg d $(date '+%Y.%m.%d') '.info.version |= $d' | \
  jq --arg v0 ${DBT_ENV_SECRET_DATABRICKS_PROD_HOST:-NA} '.servers.dna_databricks_production.host |= $v0' | \
  jq --arg v1 ${DBT_ENV_SECRET_DATABRICKS_DEV_HOST:-NA} '.servers.dna_databricks_development.host |= $v1' | \
  jq --arg v2 ${DATABRICKS_PROD_CATALOG:-NA} '.servers.dna_databricks_production.catalog |= $v2' | \
  jq --arg v3 ${DATABRICKS_DEV_CATALOG:-NA} '.servers.dna_databricks_development.catalog |= $v3' | \
  jq --arg v4 ${DATABRICKS_PROD_SCHEMA:-NA} '.servers.dna_databricks_production.schema |= $v4' | \
  jq --arg v5 ${DATABRICKS_DEV_SCHEMA:-NA} '.servers.dna_databricks_development.schema |= $v5' | \
  jq --arg v6 ${DBT_ENV_SECRET_SNOWFLAKE_PROD_ACCOUNT:-NA} '.servers.snowflake_production.account |= $v6' | \
  jq --arg v7 ${DBT_ENV_SECRET_SNOWFLAKE_DEV_ACCOUNT:-NA} '.servers.snowflake_development.account |= $v7' | \
  jq --arg v8 ${SNOWFLAKE_PROD_DATABASE:-NA} '.servers.snowflake_production.database |= $v8' | \
  jq --arg v9 ${SNOWFLAKE_DEV_DATABASE:-NA} '.servers.snowflake_development.database |= $v9' | \
  jq --arg v10 ${SNOWFLAKE_PROD_SCHEMA:-NA} '.servers.snowflake_production.schema |= $v10' | \
  jq --arg v11 ${SNOWFLAKE_DEV_SCHEMA:-NA} '.servers.snowflake_development.schema |= $v11' > \
  metadata/output/data_contracts/raw_customers.json
