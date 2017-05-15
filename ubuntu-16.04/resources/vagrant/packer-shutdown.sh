#!/usr/bin/env bash

set -euo pipefail

echo "Generalising OS ..."
echo > /etc/resolv.conf
rm /var/lib/dhcp/*.leases
echo "localhost" > /etc/hostname
echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts

echo "Removing root password ..."
passwd -dl root

echo "Remove all log files ..."
rm -Rf /var/log/*

echo "Deleting shutdown script ..."
rm -- "$0"

echo "Clearing command history ..."
history -cw

echo "Shutting down ..."
shutdown -P now
