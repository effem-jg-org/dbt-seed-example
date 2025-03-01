#!/bin/bash

# Open a new file descriptor that redirects to stdout:
exec 3>&1

log () {
    echo "$1" 1>&3
}

source_system_exists () {
  log "Veriyfing if Source System ${1} Exists"
  paylod=$(curl -s -X 'GET' \
    "${DATACONTRACT_MANAGER_HOST}/api/sourcesystems/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" | jq -r '.id')
  
  if [[ $paylod == ${1} ]]; then
    log "Source System ${1} Exists"
    return 1
  else
    log "Source System ${1} Does Not Exist"
    return 0
  fi
}

source_system_delete () {
  log "Deleting Source System ${1}"
  curl -s -X 'DELETE' \
    "${DATACONTRACT_MANAGER_HOST}/api/sourcesystems/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json"
}

data_contract_exists () {
  log "Veriyfing if Data Contract ${1} Exists"
  paylod=$(curl -s -X 'GET' \
    "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" | jq -r '.id')
  
  if [[ $paylod == ${1} ]]; then
    log "Data Contract ${1} Exists"
    return 1
  else
    log "Data Contract ${1} Does Not Exist"
    return 0
  fi
}

data_contract_delete () {
  log "Deleting Data Contract ${1}"
  curl -s -X 'DELETE' \
    "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json"
}

data_product_exists () {
  log "Veriyfing if Data Product ${1} Exists"
  paylod=$(curl -s -X 'GET' \
    "${DATACONTRACT_MANAGER_HOST}/api/dataproducts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" | jq -r '.id')
  
  if [[ $paylod == ${1} ]]; then
    log "Data Product ${1} Exists"
    return 1
  else
    log "Data Product ${1} Does Not Exist"
    return 0
  fi
}

data_product_delete () {
  log "Deleting Data Product ${1}"
  curl -s -X 'DELETE' \
    "${DATACONTRACT_MANAGER_HOST}/api/dataproducts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json"
}

for data_contract in metadata/output/data_contracts/*.yaml; do
  [ -e ${data_contract} ] || continue
  
  data_contract_id=$(cat ${data_contract} | yq -r '.id')
  data_contract_exists "${data_contract_id}"
  if data_contract_exists "${data_contract_id}"; then
    data_contract_delete "${data_contract_id}"
  fi
done


for data_product in metadata/output/data_products/*.yaml; do
  data_product_id=$(cat ${data_product} | yq -r '.id')
  if data_product_exists "${data_product_id}"; then
    data_product_delete "${data_product_id}"
  fi
done