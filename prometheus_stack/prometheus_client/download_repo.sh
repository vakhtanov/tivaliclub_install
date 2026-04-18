#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!

PROMETHEUS_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/prometheus_client"

## COLORS FOR BASH
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$PWD" != "$HOME" ]; then
    echo -e "${RED}Error: You mast be in home ($HOME).${NC}"
    echo -e "Now in: $PWD"
    exit 1
fi

echo -e "${GREEN}Success: you in home${NC}"

mkdir -p prometheus_client
cd prometheus_client

wget $PROMETHEUS_SRV_REPO/docker-compose.yml -O docker-compose.yml
wget $PROMETHEUS_SRV_REPO/install_node_exporter.sh -O install_node_exporter.sh

echo -e "${GREEN}cd prometheus_client${NC}"
