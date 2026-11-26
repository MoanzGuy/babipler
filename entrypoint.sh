#!/usr/bin/env bash
set -Eeuo pipefail

if [[ -z "${ROOT_PASSWORD:-}" ]]; then
    echo "[ERROR] ROOT_PASSWORD belum diatur."
    exit 1
fi

if [[ ${#ROOT_PASSWORD} -lt 12 ]]; then
    echo "[ERROR] Password minimal 12 karakter."
    exit 1
fi

mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh

echo "root:${ROOT_PASSWORD}" | chpasswd
ssh-keygen -A

/usr/sbin/sshd -t

echo "[OK] OMDUTA CLOUD SSH STARTING"

/usr/sbin/sshd -D -e