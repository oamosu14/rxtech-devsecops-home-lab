#!/bin/bash
set -euo pipefail
# Run on monitoring-node (RHEL/Alma or Ubuntu)
# This installs Nagios XI via official installer (requires internet access)

curl -LO https://assets.nagios.com/downloads/nagiosxi/install.sh
sudo bash install.sh
echo "Access Nagios XI via http://<monitoring-node-ip>/nagiosxi"
