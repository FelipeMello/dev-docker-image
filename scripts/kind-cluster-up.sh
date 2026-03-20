#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/docker-stack-recipes/kind-kubernetes"
exec ./scripts/cluster-up.sh "$@"
