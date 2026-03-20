#!/usr/bin/env bash
# Copy your host public key into the running dev container (passwordless SSH).
# Run from this directory with the stack up: docker compose up -d
set -euo pipefail
cd "$(dirname "$0")"

CONTAINER_ID=$(docker compose ps -q dev)
if [ -z "${CONTAINER_ID}" ]; then
  echo "Error: dev service is not running."
  exit 1
fi

SSH_PORT="${MERN_SSH_PORT:-2222}"

if [ ! -f "${HOME}/.ssh/id_rsa.pub" ] && [ ! -f "${HOME}/.ssh/id_ed25519.pub" ]; then
  echo "No id_rsa.pub or id_ed25519.pub found. Generating ed25519 key..."
  ssh-keygen -t ed25519 -f "${HOME}/.ssh/id_ed25519" -N ""
fi

PUB=""
if [ -f "${HOME}/.ssh/id_ed25519.pub" ]; then
  PUB="${HOME}/.ssh/id_ed25519.pub"
elif [ -f "${HOME}/.ssh/id_rsa.pub" ]; then
  PUB="${HOME}/.ssh/id_rsa.pub"
fi
if [ -z "${PUB}" ]; then
  echo "Error: no id_ed25519.pub or id_rsa.pub after keygen attempt."
  exit 1
fi

echo "Using public key: ${PUB}"
docker compose exec -T dev mkdir -p /root/.ssh
docker cp "${PUB}" "${CONTAINER_ID}:/tmp/dev.pub"
docker compose exec -T dev sh -c "touch /root/.ssh/authorized_keys && cat /tmp/dev.pub >> /root/.ssh/authorized_keys && rm -f /tmp/dev.pub && chmod 600 /root/.ssh/authorized_keys && chmod 700 /root/.ssh"

echo "Done. Connect (default host port ${SSH_PORT} → container 22):"
echo "  ssh -p ${SSH_PORT} root@localhost"
