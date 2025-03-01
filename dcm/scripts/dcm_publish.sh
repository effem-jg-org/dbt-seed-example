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

source_system_create () {
  log "Creating Source System ${1}"
  curl -s -X 'PUT' \
    "${DATACONTRACT_MANAGER_HOST}/api/sourcesystems/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" \
    --data "$(cat ${2} | yq)"
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

data_contract_create () {
  log "Creating Data Contract ${1}"
  curl -s -X 'PUT' \
    "${DATACONTRACT_MANAGER_HOST}/api/datacontracts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" \
    --data "$(cat ${2} | yq)"
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

data_product_create () {
  log "Creating Data Product ${1}"
  curl -s -X 'PUT' \
    "${DATACONTRACT_MANAGER_HOST}/api/dataproducts/${1}" \
    --header "x-api-key: ${DATACONTRACT_MANAGER_API_KEY}" \
    --header "content-type: application/json" \
    --data "$(cat ${2} | yq)"
}

for source_system in metadata/output/source_systems/*.yaml; do
  source_system_id=$(cat ${source_system} | yq -r '.id')
  if source_system_exists "${source_system_id}"; then
    log "Evaluating diff between code repo vs DCM."
    ## TODO: Build Smart Comparison
  fi

  source_system_create "${source_system_id}" "${source_system}"
done


for data_contract in metadata/output/data_contracts/*.yaml; do
  data_contract_id=$(cat ${data_contract} | yq -r '.id')
  if data_contract_exists "${data_contract_id}"; then
    log "Evaluating diff between code repo vs DCM."
    ## TODO: Build Smart Comparison
  fi
  data_contract_create "${data_contract_id}" "${data_contract}"
done


for data_product in metadata/output/data_products/*.yaml; do
  data_product_id=$(cat ${data_product} | yq -r '.id')
  if data_product_exists "${data_product_id}"; then
    log "Evaluating diff between code repo vs DCM."
    ## TODO: Build Smart Comparison
  fi
  data_product_create "${data_product_id}" "${data_product}"
done