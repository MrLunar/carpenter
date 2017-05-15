#!/usr/bin/env bash

set -eu

echo "Performing package upgrades ... "
apt-get clean
apt-get update
apt-get -y upgrade -y
apt-get -y dist-upgrade 

echo "Rebooting and waiting ... "
reboot
sleep 60
