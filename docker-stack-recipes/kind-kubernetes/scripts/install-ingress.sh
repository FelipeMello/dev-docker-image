#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECIPE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CLUSTER_NAME="${KIND_CLUSTER_NAME:-dev-local}"
CONTEXT="kind-${CLUSTER_NAME}"
CHART_VERSION="${INGRESS_NGINX_CHART_VERSION:-4.11.3}"

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"

if ! kubectl config get-contexts -o name 2>/dev/null | grep -qx "$CONTEXT"; then
  echo "Context '$CONTEXT' not found. Create the cluster first: ./scripts/cluster-up.sh" >&2
  exit 1
fi

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --kube-context "$CONTEXT" \
  --namespace ingress-nginx \
  --create-namespace \
  --version "$CHART_VERSION" \
  --values "$RECIPE_DIR/ingress-nginx-kind-values.yaml" \
  --wait \
  --timeout 10m

echo "ingress-nginx installed. Use host ports 80/443 on localhost (see kind-config.yaml)."
