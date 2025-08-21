# DevSecOps Home Lab — Complete Integration Bundle
This repository contains configuration, playbooks, manifests, and scripts to complete your multi-node DevSecOps home lab.

**Current environment (as you described):**
- Ansible control node: ansible-node (192.168.1.10) — already configured with passwordless SSH.
- Jenkins node: jenkins-node (192.168.1.11) — Jenkins & SonarQube already installed and running.
- Docker node: docker-node (192.168.1.12) — Docker installed and running. Harbor not installed yet.
- Monitoring node: monitoring-node (192.168.1.13) — up, no monitoring stack yet.
- k3s/k3d cluster will run on docker-node (k3d recommended for local k3s).

This bundle helps you deploy Harbor, Prometheus + Grafana, Nagios Core (and notes for Nagios XI),
set up security tooling (Trivy, Checkov, Conftest), provide a sample app with Dockerfile and Kubernetes manifests,
and integrate everything via Ansible and a Jenkins pipeline (Jenkinsfile).

> IMPORTANT: This repo contains NO secrets. Replace placeholders with real credentials and use Ansible Vault / Jenkins Credentials.
