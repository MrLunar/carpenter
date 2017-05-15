#!/usr/bin/env bash

set -euo pipefail

echo "Installing prerequisites ..."
apt-get update
apt-get install -y dkms gcc

echo "Preparing installation resources ..."
cd /tmp
mkdir /tmp/isomount
mount -t iso9660 -o loop /root/VBoxGuestAdditions.iso /tmp/isomount

# Unfortunately, the exit code of this script is completely unreliable,
# so we have to test for successful installation manually.
# See http://stackoverflow.com/q/25434139 for examples.
echo "Starting installation process ..."
/tmp/isomount/VBoxLinuxAdditions.run || true
if ! lsmod | grep -q vboxguest; then
  echo "ERROR: Installation of guest additions unsuccessful."
  exit 1
fi

echo "Cleaning up installation resources ..."
umount /tmp/isomount
rm -rf /tmp/isomount /root/VBoxGuestAdditions.iso
apt-get -y --purge autoremove dkms gcc
