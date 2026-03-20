#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECIPE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLUSTER_NAME="${KIND_CLUSTER_NAME:-dev-local}"
CONFIG="${KIND_CONFIG:-$RECIPE_DIR/kind-config.yaml}"

if [[ "${1:-}" == "--recreate" ]]; then
  kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true
fi

if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
  echo "Kind cluster '$CLUSTER_NAME' already exists. Skip create."
  echo "  Recreate: $0 --recreate"
  echo "  Remove:   KIND_CLUSTER_NAME=$CLUSTER_NAME \"$RECIPE_DIR/scripts/cluster-down.sh\""
  exit 0
fi

kind create cluster --name "$CLUSTER_NAME" --config "$CONFIG"
echo "Kubeconfig context: kind-$CLUSTER_NAME"
echo "Verify: kubectl --context \"kind-$CLUSTER_NAME\" get nodes"
