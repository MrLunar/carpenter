#!/usr/bin/env bash

set -euo pipefail

echo "Make packer shutdown script executable ..."
chmod +x "/root/packer-shutdown.sh"

echo "Installing common software ..."
apt-get update
apt-get install -y vim

echo "Configuring vagrant user ..."
adduser vagrant --disabled-password --gecos ""
echo "vagrant:vagrant" | chpasswd
echo "vagrant ALL = NOPASSWD : ALL" > /etc/sudoers.d/vagrant
mkdir /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Configuring firewall ... "
ufw disable
ufw reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw limit ssh
echo y | ufw enable

echo "Provisioning complete."
