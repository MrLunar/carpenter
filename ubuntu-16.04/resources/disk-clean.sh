#!/usr/bin/env bash

set -euo pipefail

echo "Cleaning apt ..."
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

echo "Cleaning various directories ..."
find /var/cache -type f -exec rm -rf {} \;
rm -rf /tmp/*
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;

echo "Zeroing free space ..."
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

echo "Syncing filesystem ..."
sync
