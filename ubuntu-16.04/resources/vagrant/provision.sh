#!/usr/bin/env bash

set -euo pipefail

echo "Make packer shutdown script executable ..."
chmod +x "/root/packer-shutdown.sh"

echo "Installing software ..."
apt-get update >/dev/null 2>&1
apt-get install -y vim
apt-get install -y -o Dpkg::Options::="--force-confold" --force-yes unattended-upgrades

echo "Configuring vagrant user ..."
adduser vagrant --disabled-password --gecos ""
echo "vagrant:vagrant" | chpasswd
echo "vagrant ALL = NOPASSWD : ALL" > /etc/sudoers.d/vagrant
mkdir /home/vagrant/.ssh
chown vagrant:vagrant /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant-insecure-public-key" > /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Installing unattended-upgrades configuration ..."
mv /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.old
cat >/etc/apt/apt.conf.d/20auto-upgrades <<'EOL'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOL
mv /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.old
cat >/etc/apt/apt.conf.d/50unattended-upgrades <<'EOL'
Unattended-Upgrade::Allowed-Origins {
  "${distro_id}:${distro_codename}-security";
};
EOL

echo "Installing first boot initialization script ..."
cat >/usr/bin/vagrant-first-boot-init <<'EOL'
#!/usr/bin/env bash
set -euo pipefail
echo "Running apt-daily task..."
systemctl start apt-daily
echo "Completed apt-daily task."
touch /etc/vagrant-first-boot-init-run
systemctl disable vagrant-first-boot-init
echo "Done."
EOL
chmod +x /usr/bin/vagrant-first-boot-init

echo "Installing first boot initialization service ..."
cat >/etc/systemd/system/vagrant-first-boot-init.service <<'EOL'
[Unit]
Description=Vagrant box first boot initialization script

[Service]
Type=oneshot
ExecStart=/usr/bin/vagrant-first-boot-init

[Install]
WantedBy=multi-user.target
EOL
systemctl enable vagrant-first-boot-init

echo "Configuring firewall ... "
ufw disable
echo y | ufw reset
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw limit ssh
echo y | ufw enable

echo "Provisioning complete."
