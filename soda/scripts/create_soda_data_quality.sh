#!/bin/bash

source .venv/bin/activate

[ -d soda ] || mkdir -p soda;

[ ! -f "soda/configuration.yaml" ] && echo '{"dummy": 0}' | yq --yaml-output > soda/configuration.yaml

for data_contract in metadata/output/data_contracts/*.yaml; do
  model_name=$(cat ${data_contract} | yq -r '.models | keys[0]')
  servers=$(cat ${data_contract} | yq -r '.servers | keys[]')
  datacontract export $data_contract \
  --format sodacl > soda/jaffle_shop_${model_name}_raw_dev.yaml

  for server in ${servers}; do
    server_spec=$(cat ${data_contract} | yq -r --arg serverName "${server}" '.servers | .[$serverName]')
    server_type=$(echo ${server_spec} | jq -r '.type')

    if [ "${server_type}" = "databricks" ] && ! echo "${server}" | grep -q "aoh"; then
      if ! $(yq --arg serverName "data_source ${server}" 'has($serverName)' soda/configuration.yaml); then
        echo "Adding ${server} Configurations in soda/configuration.yaml"
        yq -i -r --yaml-output \
          --arg serverName "data_source ${server}" \
          --arg catalog "$(echo ${server_spec} | jq -r '.catalog')" \
          --arg schema "$(echo ${server_spec} | jq -r '.schema')" \
          --arg host "$(echo ${server_spec} | jq -r '.host')" \
          '.[$serverName] +=
              {
                "type": "spark",
                "method": "databricks",
                "catalog": $catalog,
                "schema": $schema,
                "host": $host,
                "http_path": "${DATABRICKS_CLUSTER_HTTP_PATH}",
                "token": "${DATABRICKS_TOKEN}",
                "sampler": {
                  "samples_limit": 999999
                }
              }
          ' soda/configuration.yaml
      fi
    elif [ "${server_type}" = "snowflake" ] && ! echo "${server}" | grep -q "aoh"; then
      if ! $(yq --arg serverName "data_source ${server}" 'has($serverName)' soda/configuration.yaml); then
        echo "Adding ${server} Configurations in soda/configuration.yaml"
        yq -i -r --yaml-output \
          --arg serverName "data_source ${server}" \
          --arg account "${account}" \
          --arg database "$(echo ${server_spec} | jq -r '.database')" \
          --arg schema "$(echo ${server_spec} | jq -r '.schema')" \
          '.[$serverName] +=
              {
                "type": "snowflake",
                "account": "${SNOWFLAKE_ACCOUNT}",
                "database": $database,
                "schema": $schema,
                "username": "${SNOWFLAKE_USER}",
                "password": "${SNOWFLAKE_PASSWORD}",
                "role": "${SNOWFLAKE_ROLE}",
                "connection_timeout": 120,
                "client_session_keep_alive": true,
                "authenticator": "externalbrowser",
                "session_params": {
                  "QUERY_TAG": "soda-queries",
                  "QUOTED_IDENTIFIERS_IGNORE_CASE": false
                },
                "sampler": {
                  "samples_limit": 999999
                }
              }
          ' soda/configuration.yaml
      fi
    fi
  done
done

yq -i --yaml-output 'del(.dummy)' soda/configuration.yaml
#sed -iE 's/data_source_/data_source /g' soda/configuration.yaml

deactivate