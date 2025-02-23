# Introduction 
Data Contract Simple POC to demonstrate `Data First` and `Contract First` design approaches to creating Data Contracts.
This POC assumes that Data Contract Manager has been deployed either locally or in Azure Subscription, and has the latest `datacontract` CLI installed.

Data Contract Manager can be visited [Here](https://datacontractmanagerpoc.azurewebsites.net/mars).

...

# Getting Started
## Warehouse Pre-Requisits
Before starting the jaffle-data seed example, we need to establish a Database & Schema in our Warehouses for a sink to land our data. The steps below will create the necessary assets in our warehouses to begin seeding data.

### Snowflake
Use the following [dbt Snowflake Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) to configure your development machine to allow dbt to interact with your Snowflake instance. Make sure to name the Schema **CONTRACT_FIRST_RAW** to follow along with the examples.

Once this has been completed, use snowflake CLI to initialize our required assets

```bash
snow object create database name=TEST_DATACONTRACT
```

To sink the jaffle-shop data, please run the following
```bash
dbt seed --profiles-dir ~/.dbt/profiles_snowflake
```

### Databricks
Use the following [dbt Databricks Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/databricks-setup) to configure your development machine to allow dbt to interact with your Databricks workspace.Make sure to name the Schema **contract_first_raw** to follow along with the examples.

To sink the jaffle-shop data, please run the following
```bash
dbt seed --profiles-dir ~/.dbt/profiles_databricks
```


## Data Requirements
We use dbt's jaffle-data examples for our use case. If the csv data hasn't been converted into parquet, then please run the converter

```shell
python3 ~/development/datacontracts/poc/simple/_convert.py
```


## DBML Requirements
DBML is a schema type language for defining DB agnostic Schema Definitions. Ensure to register with [dbdiagrams.io](https://dbdiagram.io/), 
and [Install the CLI](https://docs.dbdocs.io/#installation)

```shell
npm install -g dbdocs

dbdocs login
```

# Build and Test
## Data First
The `Data First` approach to building Data Contracts implies that the Data is already available to begin designing the Data Contract. We can use the `datacontract` CLI to `import` the Schema and initialize a Data Contract.

```shell
export $(cat ~/development/datacontracts/.env)
datacontract import \
  --format parquet \
  --source ~/development/datacontracts/poc/simple/jaffle-data/parquet/raw_orders.parquet \
  --template ~/development/datacontracts/ddaas_data_first_datacontract.yaml \
  --output ~/development/datacontracts/poc/simple/raw_orders_data_first.yaml
```

## Contract First
The `Contract First` approach to building Data Contracts relies on pre-requisit efforts to properly define the Data Assets, and then begin desiging the Data Contract. We can use the `datacontract` cli to `import` the schema and initialize a Data Contract.

```shell
dbdocs build ~/development/datacontracts/poc/simple/jaffle.dbml \
  --project jaffle

export $(cat ~/development/datacontracts/.env)
datacontract import \
  --format dbml \
  --source ~/development/datacontracts/poc/simple/jaffle.dbml \
  --dbml-schema raw \
  --dbml-table orders \
  --template ~/development/datacontracts/ddaas_contract_first_datacontract.yaml \
  --output ~/development/datacontracts/poc/simple/raw_orders_contract_first.yaml
```

## Comparison

Use the `datacontract` CLI to review what the differences are between 2 Data Contracts (or 2 different version of the same Data Contract), and print to stdout.

```shell
datacontract changelog \
  ~/development/datacontracts/poc/simple/raw_orders_data_first.yaml \
  ~/development/datacontracts/poc/simple/raw_orders_contract_first.yaml
```

## Publish

Use the `datacontract` CLI to publish the newly created Data Contract to DCM.

```shell
sed -i 's/id: ddaas_contract_first_data_contract_id/id: ddaas_contract_first_data_contract_raw_id/' \
  ~/development/datacontracts/poc/simple/raw_orders_contract_first.yaml

datacontract publish ~/development/datacontracts/poc/simple/raw_orders_contract_first.yaml
```

## Tear Down

### Snowflake

Use snowflake CLI to remove our test database

```bash

snow object drop database TEST_DATACONTRACT

```

### Databricks

Use databricks CLI to remove our test schema

```bash

databricks schemas delete datagovernance_mvp.contract_first_raw --force

```

To remove the Data Contract in DCM, using the following API call.

```shell
curl -X 'DELETE' \
  'https://datacontractmanagerpoc.azurewebsites.net/api/datacontracts/ddaas_contract_first_data_contract_raw_id' \
  --header "x-api-key: $DATACONTRACT_MANAGER_API_KEY" \
  --header "content-type: application/json"
```

Clean up dbdocs and test data contracts

```bash
dbdocs remove jaffle
rm ~/development/datacontracts/poc/simple/raw_orders_data_first.yaml
rm ~/development/datacontracts/poc/simple/raw_orders_contract_first.yaml
```


