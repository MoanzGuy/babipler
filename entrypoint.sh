#!/bin/bash
set -e

PASS="${ROOT_PASSWORD:-changeme}"
echo "root:${PASS}" | chpasswd

HOST_NAME="f$(cat /proc/sys/kernel/random/uuid | tr -d '-' | head -c 11)"
hostname "$HOST_NAME" 2>/dev/null || true

/usr/sbin/sshd -D -e