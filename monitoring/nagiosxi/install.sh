
#!/usr/bin/env bash
set -euo pipefail

# This is a convenience wrapper that fetches and installs Nagios XI.
# For production, review commands and security posture.

if command -v yum >/dev/null 2>&1; then
  PKG_MGR="yum"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MGR="dnf"
elif command -v apt-get >/dev/null 2>&1; then
  PKG_MGR="apt-get"
else
  echo "Unsupported OS for automatic install. Install Nagios XI manually."
  exit 1
fi

echo "[*] Installing prerequisites..."
sudo ${PKG_MGR} -y update || true
sudo ${PKG_MGR} -y install wget curl tar unzip || true

cd /tmp
echo "[*] Downloading Nagios XI..."
# Using latest stable auto installer from Nagios (adjust if needed)
wget -O nagiosxi-latest.tar.gz https://assets.nagios.com/downloads/nagiosxi/xi-latest.tar.gz
tar -xzf nagiosxi-latest.tar.gz
cd nagiosxi
echo "[*] Running full installer (this takes a while)..."
sudo ./fullinstall.sh -y || sudo ./fullinstall.sh
echo "[*] Nagios XI installation attempt complete. Access via http://<monitor-node>/nagiosxi"
