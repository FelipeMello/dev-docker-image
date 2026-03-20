#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/docker-stack-recipes/java-oracle-enterprise"
exec docker compose up --build "$@"
