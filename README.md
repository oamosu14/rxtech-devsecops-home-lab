
# DevSecOps Home Lab (Multi-Node)

This repository provisions a **multi-node DevSecOps home lab** using Ansible, Jenkins, Docker, SonarQube, Snyk, and Nagios XI.

## Nodes & Roles

| Hostname        | IP           | Role           | Key Services |
|-----------------|--------------|----------------|--------------|
| control-node    | 192.168.1.xx | Control        | Ansible, Git |
| jenkins-node    | 192.168.1.xx | CI/CD          | Jenkins, SonarQube, Snyk CLI, Docker |
| app-node        | 192.168.1.xx | Application    | Docker runtime, Sample apps |
| monitor-node    | 192.168.1.xx | Monitoring     | Nagios XI |

> Adjust IPs/hostnames in `ansible/inventory.ini` for your environment.

## Quick Start

1) **Control Node** (Ansible master):
```bash
# On control-node
sudo apt update -y || sudo yum -y update
sudo apt install -y ansible git python3-pip sshpass || sudo yum install -y ansible git python3-pip sshpass

git clone ./devsecops-home-lab
cd devsecops-home-lab/ansible

# Test connectivity
ansible -i inventory.ini all -m ping

# Provision everything
ansible-playbook -i inventory.ini site.yml
```
2) Access services post-provision:
- Jenkins: `http://192.168.1.xx:8080`
- SonarQube: `http://192.168.1.xx:9000`
- Nagios XI: `http://192.168.1.xx/nagiosxi`

3) Trigger a pipeline in Jenkins. Example Pipelines are in `jenkins/pipelines/`.

## Repo Structure

```
devsecops-home-lab/
│── README.md
│
├── ansible/
│   ├── inventory.ini
│   ├── site.yml
│   ├── group_vars/
│   │   ├── all.yml
│   │   └── jenkins.yml
│   ├── playbooks/
│   │   ├── deploy-app.yml
│   │   └── uninstall.yml
│   └── roles/
│       ├── common/
│       │   └── tasks/main.yml
│       ├── docker/
│       │   └── tasks/main.yml
│       ├── jenkins/
│       │   ├── tasks/main.yml
│       │   └── templates/jenkins-compose.yml.j2
│       ├── sonarqube/
│       │   ├── tasks/main.yml
│       │   └── files/sonar.properties
│       └── nagios/
│           └── tasks/main.yml
│
├── jenkins/
│   ├── Dockerfile
│   ├── jenkins-compose.yml
│   └── pipelines/
│       ├── cicd-pipeline.groovy
│       └── security-pipeline.groovy
│
├── docker/
│   ├── docker-compose.yml
│   └── sonar/sonar.properties
│
├── monitoring/
│   └── nagiosxi/
│       ├── install.sh
│       ├── nagios.cfg
│       └── services.cfg
│
├── security/
│   ├── snyk-integration.md
│   ├── sonar-quality-gates.json
│   └── scripts/run-scans.sh
│
└── scripts/
    ├── setup.sh
    ├── rollback-ansible.sh
    └── hostname-change.yml
```

## What goes where (multi-node)

- **control-node**: Clone this repo; run all Ansible playbooks. Nothing heavy runs here.
- **jenkins-node**: Jenkins (via Docker Compose), SonarQube (Docker), Snyk CLI. Pipelines defined in `jenkins/pipelines/`.
- **app-node**: Receives application deployments (containers) from Jenkins/Ansible.
- **monitor-node**: Nagios XI installation and configs in `monitoring/nagiosxi/`.

## Security Notes

- Store tokens (GitHub, SonarQube, Snyk) in Jenkins Credentials or Ansible Vault. Do not commit secrets.
- Example quality gate is in `security/sonar-quality-gates.json`.
- Snyk auth: `snyk auth <TOKEN>` on jenkins-node (or via Jenkins step).

## Rollback / Uninstall

- Use Ansible playbook `ansible/playbooks/uninstall.yml` and helper `scripts/rollback-ansible.sh` to remove services.
- For hostnames, use `scripts/hostname-change.yml`.

---

