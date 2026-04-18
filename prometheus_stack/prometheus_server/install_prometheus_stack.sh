#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!

INSTALL_DIR="/opt/prometheus_stack"


## COLORS FOR BASH!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================INIT=============

echo -e "${GREEN}INIT PREPARE${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Please install Docker${NC}"
    exit 1
fi

echo -e "${GREEN}Docker present. Version: $(docker --version)${NC}"

if ! docker ps &> /dev/null; then
    echo -e "${RED}add user to group DOCKER or run script with SUDO ${NC}"
    exit 1
fi


sudo mkdir -p $INSTALL_DIR/{prometheus,grafana,alertmanager,blackbox}

sudo mkdir -p $INSTALL_DIR/prometheus/etc
sudo mkdir -p $INSTALL_DIR/grafana/provisioning

#PATH to DATA DIRECTORY
sudo mkdir -p $INSTALL_DIR/prometheus/data
sudo chown 65534:65534 $INSTALL_DIR/prometheus/data
sudo mkdir -p $INSTALL_DIR/grafana/data
sudo chown 65534:65534 $INSTALL_DIR/grafana/data

sudo cp alertmanager/config.yml  $INSTALL_DIR/alertmanager/config.yml
sudo cp prometheus/etc/alert.rules $INSTALL_DIR/prometheus/etc/alert.rules
sudo cp prometheus/etc/prometheus.yml  $INSTALL_DIR/prometheus/etc/prometheus.yml
sudo cp prometheus/etc/targets.json $INSTALL_DIR/prometheus/etc/targets.json
sudo cp grafana/provisioning/datasource.yml  $INSTALL_DIR/grafana/provisioning/datasource.yml
sudo cp docker-compose.yml $INSTALL_DIR/docker-compose.yml
sudo cp .env $INSTALL_DIR/.env

echo -e "${GREEN}Start Prometheus stack${NC}"
cd $INSTALL_DIR
docker compose up -d
