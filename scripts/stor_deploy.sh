#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

az deployment group create \
    --resource-group guemry-reda \
    --name deploy-storage \
    --mode Incremental \
    --template-file "$script_dir/template.json" \
    --parameters "@$script_dir/parameters.json"
