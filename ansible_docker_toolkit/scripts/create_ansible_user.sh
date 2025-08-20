#!/bin/bash
# create_ansible_user.sh - Creates an Ansible user on remote hosts
HOSTS_FILE="/home/rxtech/scripts/hosts.txt"
ANSIBLE_USER="ansibleadmin"

for IP in $(cat $HOSTS_FILE); do
    echo "---------------------------------------------------------------"
    echo "Setting up Ansible user on $IP ..."
    echo "---------------------------------------------------------------"

    ssh "$IP" "sudo useradd -m -s /bin/bash $ANSIBLE_USER 2>/dev/null || true"
    ssh "$IP" "id -nG $ANSIBLE_USER | grep -qw wheel || sudo usermod -aG wheel $ANSIBLE_USER 2>/dev/null || sudo usermod -aG sudo $ANSIBLE_USER"
    ssh "$IP" "echo '$ANSIBLE_USER ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$ANSIBLE_USER >/dev/null"
    echo "✅ User $ANSIBLE_USER created and configured on $IP."
done
