#!/bin/bash
# docker_monitoring.sh - Basic monitoring of Docker environment
echo "Docker Monitoring Report - $(date)"
echo "--------------------------------------------------"
echo "[*] Docker Version:"
docker --version
echo ""
echo "[*] Running Containers:"
docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}'
echo ""
echo "[*] All Containers:"
docker ps -a --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}'
echo ""
echo "[*] Docker Images:"
docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'
echo ""
echo "[*] Docker Disk Usage:"
docker system df
