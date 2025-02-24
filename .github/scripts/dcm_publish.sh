export SOURCE_SYSTEM_ID=$(cat ./metadata/output/source_systems/dbt_jaffle_shop.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/sourcesystems/${SOURCE_SYSTEM_ID}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/source_systems/dbt_jaffle_shop.yaml | yq)"

export DATA_CONTRACT_ID_RAW_CUSTOMERS=$(cat ./metadata/output/data_contracts/raw_customers.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_CUSTOMERS}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_customers.yaml | yq)"

export DATA_CONTRACT_ID_RAW_ITEMS=$(cat ./metadata/output/data_contracts/raw_items.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_ITEMS}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_items.yaml | yq)"

export DATA_CONTRACT_ID_RAW_ORDERS=$(cat ./metadata/output/data_contracts/raw_orders.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_ORDERS}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_orders.yaml | yq)"

export DATA_CONTRACT_ID_RAW_PRODUCTS=$(cat ./metadata/output/data_contracts/raw_products.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_PRODUCTS}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_products.yaml | yq)"

export DATA_CONTRACT_ID_RAW_STORES=$(cat ./metadata/output/data_contracts/raw_stores.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_STORES}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_stores.yaml | yq)"

export DATA_CONTRACT_ID_RAW_SUPPLIES=$(cat ./metadata/output/data_contracts/raw_supplies.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${DATA_CONTRACT_ID_RAW_SUPPLIES}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_contracts/raw_supplies.yaml | yq)"

export DATA_PRODUCT_ID=$(cat ./metadata/output/data_products/jaffle_shop_raw.yaml | grep -Po '(?<=id:\s)[a-zA-Z0-9_:-]+' | head -1)
curl -X 'PUT' \
  "${DATACONTRACT_MANAGER_HOST}/api/dataproducts/${DATA_PRODUCT_ID}" \
  --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
  --header "content-type: application/json" \
  --data "$(cat ./metadata/output/data_products/jaffle_shop_raw.yaml | yq)"