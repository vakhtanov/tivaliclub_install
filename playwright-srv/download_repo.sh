#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!

PLAYWRIGHT_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/playwright-srv"



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

mkdir -p playwright-env-install 
mkdir -p playwright-env-install/authorized_keys
cd playwright-env-install

wget $PLAYWRIGHT_SRV_REPO/docker-compose.yml -O docker-compose.yml
wget $PLAYWRIGHT_SRV_REPO/install_playwright_env_split_files.sh -O install_playwright_env_split_files.sh
wget $PLAYWRIGHT_SRV_REPO/Dockerfile -O Dockerfile
wget $PLAYWRIGHT_SRV_REPO/.env -O .env
#wget $PLAYWRIGHT_SRV_REPO/playwright.config.ts -O playwright.config.ts

echo -e "${GREEN}cd playwright-env-install${NC}"
echo -e "${GREEN}install_playwright_env_split_files.sh${NC}"
