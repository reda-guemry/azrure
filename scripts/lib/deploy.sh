#!/usr/bin/env bash
set -euo pipefail

service=$1
shift

case "$#:${1:-}" in
    0:|1:--preview)
        action=(what-if)
        ;;
    1:--apply)
        action=(create --confirm-with-what-if)
        ;;
    1:--help|1:-h)
        printf '%s\n' 'Set AZURE_SUBSCRIPTION_ID to the target subscription ID.' \
            'Run with --preview (the default) or --apply (preview and confirm).'
        exit 0
        ;;
    *)
        printf '%s\n' 'Usage: run this script with --preview, --apply, or --help.' >&2
        exit 2
        ;;
esac

subscription_id=${AZURE_SUBSCRIPTION_ID:-}
if [[ ! $subscription_id =~ ^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$ ]]; then
    printf '%s\n' 'Set AZURE_SUBSCRIPTION_ID to the target Azure subscription ID (UUID).' >&2
    exit 2
fi

if ! command -v az >/dev/null; then
    printf '%s\n' 'Azure CLI is required. Install it and sign in with az login.' >&2
    exit 127
fi

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
service_dir="$repo_dir/services/$service"
resource_group=guemry-reda

az group show --subscription "$subscription_id" --name "$resource_group" --output none

exec az deployment group "${action[@]}" \
    --subscription "$subscription_id" \
    --resource-group "$resource_group" \
    --name "deploy-$service" \
    --mode Incremental \
    --template-file "$service_dir/template.json" \
    --parameters "@$service_dir/parameters.json"
