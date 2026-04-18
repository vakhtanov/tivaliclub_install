#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!

INSTALL_DIR="/opt/prometheus_stack"
PROMETHEUS_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/server"
DOCKER_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/docker"

## COLORS FOR BASH!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================INIT=============

echo -e "${GREEN}INIT PREPARE${NC}"

sudo mkdir -p $INSTALL_DIR/{prometheus,grafana,alertmanager,blackbox}


sudo mkdir -p $INSTALL_DIR/prometheus/etc

sudo wget $PROMETHEUS_SRV_REPO/alertmanager/config.yml -O $INSTALL_DIR/alertmanager/config.yml
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/alert.rules -O $INSTALL_DIR/prometheus/etc/alert.rules
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/prometheus.yml -O $INSTALL_DIR/prometheus/etc/prometheus.yml
sudo wget $PROMETHEUS_SRV_REPO/prometheus/etc/targets.json -O $INSTALL_DIR/prometheus/etc/targets.json
sudo wget $PROMETHEUS_SRV_REPO/docker-compose.yml -O $INSTALL_DIR/docker-compose.yml
sudo wget $PROMETHEUS_SRV_REPO/.env -O $INSTALL_DIR/.env

#PATH to DATA DIRECTORY
sudo mkdir -p $INSTALL_DIR/prometheus/data
sudo chown 65534:65534 $INSTALL_DIR/prometheus/data

#=============SETUP DOCKER OFFICIAL==============================

echo -e "${GREEN}SETUP DOCKER OFFICIAL${NC}"

wget -O - $DOCKER_REPO/setup_docker_tv_mod.sh | bash


echo -e "${YELLOW}do cd $INSTALL_DIR and DO COMMAND ${NC}"
echo -e "${YELLOW}docker compose up -d${NC}"
