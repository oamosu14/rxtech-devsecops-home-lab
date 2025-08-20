
#!/usr/bin/env bash
set -euo pipefail

echo "[*] Running Ansible uninstall playbook (best-effort)..."
ansible-playbook -i ansible/inventory.ini ansible/playbooks/uninstall.yml || true
echo "[*] Manual cleanup may still be required for Nagios XI."
