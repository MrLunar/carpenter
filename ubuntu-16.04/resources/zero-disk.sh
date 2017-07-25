#!/usr/bin/env bash

set -euo pipefail

echo "Zeroing free space ..."
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

echo "Syncing filesystem ..."
sync
