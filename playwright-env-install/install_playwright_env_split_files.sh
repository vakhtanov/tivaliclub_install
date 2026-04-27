#!/bin/bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!
#set -x #Debug mode if need


#================VARIABLES==============================
INSTALL_DIR="/opt/playwright-env-install"
KEYS_DIR="$(pwd)/authorized_keys"
DEV_COUNT=2 # Number of QA - add or remove section in docker-compose.yml
# Set playwright version in .env


## COLORS FOR BASH!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
#=====================================================

#===================INIT==============================

echo -e "${GREEN}INIT PREPARE${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Please install Docker${NC}"
    exit 1
fi

echo -e "${GREEN}Docker present. Version: $(docker --version)${NC}"

if ! docker ps &> /dev/null; then
    echo -e "${RED}add user to group DOCKER or run script with SUDO${NC}"
    exit 1
fi
#=====================================================

sudo mkdir -p $INSTALL_DIR
sudo cp docker-compose.yml "$INSTALL_DIR/"
sudo cp Dockerfile "$INSTALL_DIR/"
sudo cp .env "$INSTALL_DIR/"

# Check SSH keys
if [ ! -d "$KEYS_DIR" ] || [ -z "$(ls -A "$KEYS_DIR"/*.pub 2>/dev/null)" ]; then
    echo "ERROR: Folder $KEYS_DIR empty. Put .pub keys in $(pwd)/keys"
    exit 1
fi

# 3. Combine file authorized_keys
cat "$KEYS_DIR"/*.pub | sudo tee $INSTALL_DIR/authorized_keys > /dev/null
sudo chmod 600 "$INSTALL_DIR/authorized_keys"

# 2. Create tree
for i in $(seq 1 $DEV_COUNT); do sudo mkdir -p "$INSTALL_DIR/dev$i"; done


# Create volume for browsers
docker volume create playwright_browsers || true


echo "--- Start install Playwright Environment ---"

cd $INSTALL_DIR

docker-compose up -d --build

# Init Playwright (Software --init)
for i in $(seq 1 "$DEV_COUNT"); do
    echo ">>> Initializing Playwright in dev$i..."
    sudo docker compose exec -w /app "dev$i" npm init playwright@latest -- --yes --typescript
done


#Smoke Test
echo ">>> Running Smoke Test in dev1..."
if sudo docker compose exec -w /app dev1 npx playwright test; then
    echo -e "${GREEN}SMOKE TEST PASSED${NC}"
else
    echo -e "${RED}SMOKE TEST FAILED${NC}"
fi

# 5. Rules
sudo chown -R $USER:$USER "$INSTALL_DIR"

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

echo -e "${GREEN}--- DEPLOYMENT FINISHED.  ---${NC}"
echo "${GREEN}Access: ssh root@$(hostname -I | awk '{print $1}') -p 2221 (or 2222)${NC}"