# Introduction 
Data Contract Simple POC to demonstrate `Data First` and `Contract First` design approaches to creating Data Contracts.
This POC assumes that Data Contract Manager has been deployed either locally or in Azure Subscription, and has the latest `datacontract` CLI installed.

Data Contract Manager can be visited [Here](https://datacontractmanagerpoc.azurewebsites.net/mars).

# Getting Started
## Warehouse Pre-Requisits
Before starting the jaffle-data seed example, we need to establish a Database & Schema in our Warehouses for a sink to land our data. The steps below will create the necessary assets in our warehouses to begin seeding data. Please export the project level environment variables consistent across Warehouses.

```bash
export $(cat .env)
```

### Snowflake
Use the following [dbt Snowflake Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) to configure your development machine to allow dbt to interact with your Snowflake instance. Make sure to name the Schema **CONTRACT_FIRST_RAW** to follow along with the examples.

Once this has been completed, use snowflake CLI to initialize our required assets

```bash
snow object create database name=$DBT_ENV_DEV_SCHEMA
```

Prior to executing the jaffle-shop data sink, you can test the connection and configurations have been completed succesfully.

```bash

dbt debug \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/snowflake \
  --target dev > ./dbt/logs/dbt_snowflake_dev_config.log

dbt debug \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/snowflake \
  --target prod > ./dbt/logs/dbt_snowflake_prod_config.log

```

To sink the jaffle-shop data, please run the following
```bash
dbt seed \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/snowflake
```

### Databricks
Use the following [dbt Databricks Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/databricks-setup) to configure your development machine to allow dbt to interact with your Databricks workspace.Make sure to name the Schema **contract_first_raw** to follow along with the examples.

Prior to executing the jaffle-shop data sink, you can test the connection and configurations have been completed succesfully.

```bash

dbt debug \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/databricks \
  --target dev > ./dbt/logs/dbt_databricks_dev_config.log

dbt debug \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/databricks \
  --target prod > ./dbt/logs/dbt_databricks_prod_config.log

```

To sink the jaffle-shop data, please run the following
```bash
dbt seed \
  --project-dir ./dbt \
  --profiles-dir ./dbt/profiles/databricks
```

## DBML Requirements
DBML is a schema type language for defining DB agnostic Schema Definitions. Ensure to register with [dbdiagrams.io](https://dbdiagram.io/), 
and [Install the CLI](https://docs.dbdocs.io/#installation)

```shell
npm install -g dbdocs

dbdocs login
```

# Build and Test

## Contract First
The `Contract First` approach to building Data Contracts relies on pre-requisit efforts to properly define the Data Assets, and then begin desiging the Data Contract. We can use the `datacontract` cli to `import` the schema and initialize a Data Contract.

```bash
dbdocs build ./jaffle-shop.dbml \
  --project jaffle-shop-example

export $(cat ~/creds/dcm.secrets)
datacontract import \
  --format dbml \
  --source ~/development/datacontracts/poc/simple/jaffle.dbml \
  --dbml-schema raw \
  --dbml-table orders \
  --template ./enablement_test_contract_template.yaml \
  --output ./metadata/output/data_contracts/raw_jaffle_shop_contract.yaml
```

*Here's a helper script to build all Data Contracts in the `jaffle-shop.dbml` model*
```bash
./.github/scripts/import_data_contracts.sh
```

## Comparison

Use the `datacontract` CLI to review what the differences are between 2 Data Contracts (or 2 different version of the same Data Contract), and print to stdout.

```bash
datacontract changelog \
  ./metadata/output/data_contracts/raw_jaffle_shop_contract.yaml \
  ./enablement_team_contract_template.yaml
```

## Publish

Use the `datacontract` CLI to publish the newly created Data Contract to DCM.

```bash
sed -i 's/id: enablement_team_data_contract_id/id: urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:full/' \
  ./metadata/output/data_contracts/raw_jaffle_shop_contract.yaml

datacontract publish ./metadata/output/data_contracts/raw_jaffle_shop_contract.yaml
```

*Here's a helper script to publish all Data Contracts & DCM artifacts*

```bash
./.github/scripts/publish.sh
```

## Tear Down

### Snowflake

Use snowflake CLI to remove our test database

```bash

snow object drop database $DBT_ENV_DEV_SCHEMA

```

### Databricks

Use databricks CLI to remove our test schema

```bash

databricks schemas delete datagovernance_mvp.contract_first_raw --force

```

To remove the Data Contract in DCM, using the following API call.

```shell
curl -X 'DELETE' \
  'https://datacontractmanagerpoc.azurewebsites.net/api/datacontracts/urn:datacontract:project:jaffle-shop:dbt-seed:raw-model:full' \
  --header "x-api-key: $DATACONTRACT_MANAGER_API_KEY" \
  --header "content-type: application/json"
```

Clean up dbdocs and test data contracts

```bash
dbdocs remove jaffle
rm ./metadata/output/data_contracts/raw_jaffle_shop_contract.yaml
```


