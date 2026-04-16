#!/usr/bin/env bash
set -euo pipefail ## ЗАВЕРШАЕТ БАШ СКПРИПТ ПРИ ЛЮБОЙ ОШИБКЕ!!!!!

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/prometheus_stack"
RUN_USER="hyperdx"
SERVER_IP="hyperdx.tivaliclub.com"  # ← Твой домен!

## КРАСИТ ЭХО В РАЗНЫЕ ЦВЕТА!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================

echo -e "${GREEN}INIT PREPARE${NC}"

mkdir -p $INSTALL_DIR/{prometheus,grafana,alertmanager,blackbox}
cd $INSTALL_DIR

wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/alertmanager/config.yml -O $INSTALL_DIR/alertmanager/config.yml
wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/prometheus/etc/alert.rules -O $INSTALL_DIR/prometheus/etc/alert.rules
wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/prometheus/etc/prometheus.yml -O $INSTALL_DIR/prometheus/etc/prometheus.yml
wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/test/docker-compose.yml -O $INSTALL_DIR/docker-compose.yml
