
#!/usr/bin/env bash
set -euo pipefail

echo "[*] Bootstrapping control-node for Ansible..."
if ! command -v ansible >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y ansible
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y epel-release || true
    sudo yum install -y ansible
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y ansible
  fi
fi

echo "[*] Done. Edit ansible/inventory.ini and run: ansible-playbook -i ansible/inventory.ini ansible/site.yml"
