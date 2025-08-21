
DevSecOps Home Lab - Master Bundle
=================================

This master bundle merges previous generated content into one download. Contents include:
- Ansible playbooks and inventory
- Harbor templates and instructions
- Prometheus + Grafana provisioning (datasource + dashboards)
- Nagios Core installer scripts and sample configs
- Security tool scripts (Trivy, Checkov, Conftest)
- Jenkins pipeline (Jenkinsfile) and Job DSL samples
- Sample app Dockerfile and k8s manifests
- docs/ with step-by-step guide

IMPORTANT:
- No secrets are included. Use Ansible Vault and Jenkins Credentials to store secrets.
- Some installers (Harbor, Nagios XI) must be downloaded manually due to vendor licensing and/or download restrictions.
- Review files under ansible/playbooks and adjust inventory IPs and usernames before running.

Next steps (quick):
1. Download and extract this zip on your ansible control node.
2. Review ansible/inventory.ini and update host IPs/usernames.
3. Create Ansible Vault for secrets (ansible/create-vault.sh helper included).
4. Upload Harbor installer to docker-node and follow docker/harbor/README.md.
5. Run ansible playbooks: ansible-playbook -i ansible/inventory.ini ansible/playbooks/monitoring.yml --limit monitoring-node
6. Seed Jenkins jobs using the job-dsl sample or create pipelines manually.

