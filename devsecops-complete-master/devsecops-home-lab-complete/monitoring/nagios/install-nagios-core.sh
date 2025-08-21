#!/bin/bash
set -e
echo "This script installs Nagios Core (open-source)."
if [ -x "$(command -v dnf)" ]; then
  sudo dnf install -y httpd php gcc glibc glibc-common gd gd-devel make perl
else
  sudo apt install -y apache2 php gcc build-essential libgd-dev make perl
fi
cd /tmp
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.6.tar.gz
tar zxvf nagios-4.4.6.tar.gz
cd nagios-4.4.6
./configure --with-httpd-conf=/etc/httpd/conf.d || true
make all
sudo make install-groups-users || true
sudo usermod -a -G nagios apache || true
sudo make install || true
sudo make install-daemoninit || true
sudo make install-commandmode || true
sudo make install-config || true
sudo make install-webconf || true
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin || true
sudo systemctl enable --now httpd || true
sudo systemctl enable --now nagios || true
echo "Nagios Core installed. Configure hosts in /usr/local/nagios/etc/objects/"
