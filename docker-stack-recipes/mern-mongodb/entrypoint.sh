#!/bin/sh
set -e
mkdir -p /var/run/sshd

if [ -n "${SSH_ROOT_PASSWORD}" ]; then
  echo "root:${SSH_ROOT_PASSWORD}" | chpasswd
fi

/usr/sbin/sshd -t
exec /usr/sbin/sshd -D
