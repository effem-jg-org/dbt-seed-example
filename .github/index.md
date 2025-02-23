# Github Action Workflows

## Local Actions
Install gh-act
```bash
gh extension install https://github.com/nektos/gh-act
```

### Manual Dispatch Snowflake Seed

```bash

gh act -j snowflake_seed \
  -e .github/local.json \
  --secret-file ~/creds/snowflake.secrets

```

### Manual Dispatch Databricks Seed

```bash

gh act -j databricks_seed \
  -e .github/local.json \
  --secret-file ~/creds/databricks.secrets

```

### Manual Dispatch DCM Integrations

```bash

# TODO: dbt-actions Github Marketplace Worflow can't pipe output to logs.
#       Currently no ability to parse configurations to extned into
#       Data Contract Metadata.
# gh act -j create-data-contracts \
#   -e .github/local.json \
#   --secret-file ~/creds/snowflake.secrets \
#   --secret-file ~/creds/databricks.secrets


# TODO: Integration with DCM
#       Github Actions on.paths is currently having issues with
#       nektos/act where paths is not expected and therefore
#       cannot filter the glob pattern correctly. Workflow
#       architecture is expceting file changes to be filteres
#       to specific specs in order to provide correct payload
#       to DCM API.

#gh act -j add-source-systems \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

#gh act -j update-source-systems \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

#gh act -j add-data-contracts \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

#gh act -j update-data-contracts \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

#gh act -j add-data-products \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

#gh act -j update-data-products \
#  -e .github/local.json \
#  --secret-file ~/creds/dcm.secrets

```

### Manual Dispatch Snowflake Tear Down

```bash

gh act -j snowflake_destroy \
  -e .github/local.json \
  --secret-file ~/creds/snowflake.secrets

```

### Manual Dispatch Databricks Tear Down

```bash

gh act -j databricks_destroy \
  -e .github/local.json \
  --secret-file ~/creds/databricks.secrets

```