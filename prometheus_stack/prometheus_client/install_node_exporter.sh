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

sudo mkdir -p $INSTALL_DIR/prometheus/node_exporter
sudo cp docker-compose.yml -O $INSTALL_DIR/prometheus/node_exporter/docker-compose.yml

echo -e "${GREEN}Start Node Exporter${NC}"
cd $INSTALL_DIR/prometheus/node_exporter
docker compose up -d
