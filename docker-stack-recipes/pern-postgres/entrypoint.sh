#!/bin/sh
set -e
mkdir -p /var/run/sshd

if [ -n "${SSH_ROOT_PASSWORD}" ]; then
  echo "root:${SSH_ROOT_PASSWORD}" | chpasswd
  /usr/sbin/sshd -t -o PermitRootLogin=yes -o PubkeyAuthentication=yes -o PasswordAuthentication=yes
  exec /usr/sbin/sshd -D -o PermitRootLogin=yes -o PubkeyAuthentication=yes -o PasswordAuthentication=yes
else
  passwd -l root 2>/dev/null || true
  /usr/sbin/sshd -t -o PermitRootLogin=yes -o PubkeyAuthentication=yes -o PasswordAuthentication=no
  exec /usr/sbin/sshd -D -o PermitRootLogin=yes -o PubkeyAuthentication=yes -o PasswordAuthentication=no
fi
