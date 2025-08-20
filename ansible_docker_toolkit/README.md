# Ansible + Docker Toolkit

This toolkit provides:
- System inventory script (`system_inventory.sh`)
- Script to create Ansible user on multiple hosts (`create_ansible_user.sh`)
- Basic Docker monitoring script (`docker_monitoring.sh`)
- Docker Compose setup for Prometheus + Grafana

## Usage

### 1. System Inventory
```bash
chmod +x scripts/system_inventory.sh
./scripts/system_inventory.sh
```

### 2. Create Ansible User
```bash
chmod +x scripts/create_ansible_user.sh
./scripts/create_ansible_user.sh
```

### 3. Docker Monitoring
```bash
chmod +x scripts/docker_monitoring.sh
./scripts/docker_monitoring.sh
```

### 4. Monitoring Stack
```bash
cd docker-compose
docker-compose up -d
```
Grafana: http://localhost:3000 (admin/admin)  
Prometheus: http://localhost:9090

---
Generated: 2025-08-20
