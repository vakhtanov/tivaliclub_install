#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!
#set -x #Debug mode if need

INSTALL_DIR="/opt/prometheus_stack"

## COLORS FOR BASH!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'


#===================INIT==============================

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
#=====================================================


#=======REMOVE PREVIOS VERSION, SAVE DATA=============
# stop docker

docker compose down -f "$INSTALL_DIR/docker-compose.yml" --remove-orphans || true
##!!!!!!!!!!!!!!!!!!REMOVE ALL PROMETHEUS DATA!!!!!!!!!!!!!!!!!!
sudo rm -rf "$INSTALL_DIR"

#remove inst folder, but no data

#=====================================================

#=======PATH to DATA DIRECTORY COPY FILES=============
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r alertmanager  "$INSTALL_DIR/alertmanager"
sudo cp -r prometheus "$INSTALL_DIR/prometheus"
sudo cp -r grafana  "$INSTALL_DIR/grafana"
sudo cp docker-compose.yml "$INSTALL_DIR/docker-compose.yml"
sudo cp .env "$INSTALL_DIR/.env"

sudo mkdir -p "$INSTALL_DIR/prometheus/data"
# Prometeus user 65534
sudo chown 65534:65534 "$INSTALL_DIR/prometheus/data"
sudo mkdir -p "$INSTALL_DIR/grafana/data"
#Grafana user 472
sudo chown 472:472 "$INSTALL_DIR/grafana/data"
#====================================================

cd "$INSTALL_DIR"

#=======SET CREDENTIAL===============================
echo -e "${YELLOW}--- Security Configuration ---${NC}"
echo -e "${YELLOW}--- Checking Secrets ---${NC}"

SMTP_PASS_PATH="$INSTALL_DIR/alertmanager/secrets/smtp_pass"
TG_TOKEN_PATH="$INSTALL_DIR/alertmanager/secrets/tg_token"
NEEDS_UPDATE=false

#Check files
if [[ -f "$SMTP_PASS_PATH" && -f "$TG_TOKEN_PATH" ]]; then
    echo -e "${YELLOW}Secrets already exist.${NC}"
    read -p "Do you want to update them? (y/N): " CONFIRM < /dev/tty || CONFIRM="n"
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        NEEDS_UPDATE=true
    fi
else
    # No files
    NEEDS_UPDATE=true
fi

if [ "$NEEDS_UPDATE" = true ]; then
    echo -e "${YELLOW}Enter new credentials:${NC}"
    
    # Запрашиваем данные
    read -sp "Enter SMTP Password: " USER_SMTP_PASS < /dev/tty
    echo ""
    read -sp "Enter Telegram Bot Token: " USER_TG_TOKEN < /dev/tty
    echo ""

    sudo mkdir -p "$INSTALL_DIR/alertmanager/secrets"

# Use printf for clear string, tee for sudo
    printf "%s" "$USER_SMTP_PASS" | sudo tee "$SMTP_PASS_PATH" > /dev/null
    printf "%s" "$USER_TG_TOKEN" | sudo tee "$TG_TOKEN_PATH" > /dev/null

    # Clear ENV
    unset USER_SMTP_PASS
    unset USER_TG_TOKEN

    # Altermanager user 65534
    sudo chown -R 65534:65534 "$INSTALL_DIR/alertmanager/secrets"
    sudo chmod 400 "$INSTALL_DIR/alertmanager/secrets/"*
    
    echo -e "${GREEN}Secrets updated successfully.${NC}"
    
else
    echo -e "${GREEN}Using existing secrets. Skipping...${NC}"
fi
#====================================================

#============START PROJECT===========================
echo -e "${GREEN}Start Prometheus stack${NC}"

docker compose pull
docker compose up -d --remove-orphans
sudo docker image prune -f
echo -e "${GREEN}Started Prometheus stack${NC}"
echo "Wait start"
sleep 10
#=====================================================


# =====CHECK DOCKER COMPOSE up======================

echo "Check project status"

# 1. Container STATUS
STATUSES=$(docker compose ps --format json)

# 2. Check project STARTED
if [[ -z "$STATUSES" || "$STATUSES" == "[]" ]]; then
    echo -e "${RED}ERROR: Project not started${NC}"
    exit 1
fi

# 3. Check container status

FAILED_CONTAINERS=$(echo "$STATUSES" | grep -vE '"State":"(running|healthy)"' | grep -c "State" || true)

if [ "$FAILED_CONTAINERS" -eq "0" ]; then
    echo -e "${GREEN}OK: All containers are running and healthy!${NC}"
    docker compose ps
    #exit 0
else
    echo -e "${RED}WARNING: Some containers are not started or error${NC}"
    docker compose ps
    exit 1
fi
#===========================================
