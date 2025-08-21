#!/bin/bash
# Helper to create an encrypted Ansible Vault file interactively.
# Usage: ./create-vault.sh vault.yml
set -e
OUT=${1:-group_vars/all/vault.yml}
echo "Creating Ansible Vault file at $OUT"
read -p "Vault filename (enter to accept): " fname
fname=${fname:-$OUT}
ansible-vault create "$fname"
echo "Created $fname"
