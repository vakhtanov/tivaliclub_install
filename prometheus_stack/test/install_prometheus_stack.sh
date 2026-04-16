#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/prometheus_stack"
#RUN_USER="hyperdx"
SERVER_IP="grafana.devopsdemo.ru"  # ← Твой домен!
PROMETHEUS_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test"
DOCKER_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/docker"

## КРАСИТ ЭХО В РАЗНЫЕ ЦВЕТА!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================INIT=============

echo -e "${GREEN}INIT PREPARE${NC}"

sudo mkdir -p $INSTALL_DIR/{prometheus,grafana,alertmanager,blackbox}
cd $INSTALL_DIR

wget $PROMETHEUS_REPO/alertmanager/config.yml -O $INSTALL_DIR/alertmanager/config.yml
wget $PROMETHEUS_REPO/prometheus/etc/alert.rules -O $INSTALL_DIR/prometheus/etc/alert.rules
wget $PROMETHEUS_REPO/prometheus/etc/prometheus.yml -O $INSTALL_DIR/prometheus/etc/prometheus.yml
wget $PROMETHEUS_REPO/docker-compose.yml -O $INSTALL_DIR/docker-compose.yml

#=============SETUP DOCKER OFFICIAL==============================

echo -e "${GREEN}SETUP DOCKER OFFICIAL${NC}"

wget -O - $DOCKER_REPO/setup_docker_tv_mod.sh | bash

echo -e "${RED}LOGOUT, LOGIN ${NC}"
echo -e "${RED}CHECK DIRRECTORY $INSTALL_DIR and DO COMMAND ${NC}"
echo -e "${RED}docker compose up -d${NC}"
