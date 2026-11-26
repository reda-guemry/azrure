# Azure data engineering lab

Deploy the lab infrastructure into the existing `guemry-reda` resource group. Each service has an independent Azure CLI entry point.

| Service | Template and parameters | Script | Resources |
| --- | --- | --- | --- |
| Azure Storage | [`services/storage/`](services/storage/) | [`scripts/stor_deploy.sh`](scripts/stor_deploy.sh) | Storage account `stf007` and the `datalake` and `source` containers |
| Azure Data Factory | [`services/data-factory/`](services/data-factory/) | [`scripts/df_deploy.sh`](scripts/df_deploy.sh) | Data Factory `df007df` with a system-assigned managed identity |

## Sign in and select a subscription

Use Bash and Azure CLI with access to deploy in `guemry-reda`. Find the subscription ID for the group and set it locally.

```bash
az login
az account list --query '[].{Name:name, ID:id}' --output table
export AZURE_SUBSCRIPTION_ID='<subscription-id>'
```

## Preview and deploy

Run either script from the repository root. By default, Azure What-If previews the changes to the resource group.

```bash
./scripts/stor_deploy.sh
./scripts/df_deploy.sh
```

Review the preview, especially any `Modify` entries for existing resources. To apply a service template, pass `--apply`. Azure CLI runs What-If again and asks for confirmation before deploying.

```bash
./scripts/stor_deploy.sh --apply
./scripts/df_deploy.sh --apply
```

Both scripts verify that the resource group exists in the specified subscription. They use ARM incremental mode, which preserves unrelated resources but can update settings on resources declared in the template. [Azure deployment modes](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deployment-modes)

## Configuration

Each service's `parameters.json` holds its lab configuration. Review the resource names and network settings before deploying. If Azure reports a name conflict when creating a resource, choose an available name in that service's parameters file. Keep credentials and local overrides out of Git.
