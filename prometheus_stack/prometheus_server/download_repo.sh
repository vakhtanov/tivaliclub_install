#!/usr/bin/env bash
set -euo pipefail ## EXIT SCRIPT ON ANY ERROR!
set -x #Debug mode

TIVALICLUB_REPO="https://github.com/vakhtanov/tivaliclub_install.git"
PROMETHEUS_REPO_FOLDER="prometheus_stack/prometheus_server"


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

git init
git remote add origin $TIVALICLUB_REPO
git config core.sparseCheckout true
echo $PROMETHEUS_REPO_FOLDER >> .git/info/sparse-checkout
git pull origin main
rm -rf .git
# remove folder tree
mv -v $PROMETHEUS_REPO_FOLDER "${PROMETHEUS_REPO_FOLDER##*/}"
rm -r "${PROMETHEUS_REPO_FOLDER%%/*}"

echo -e "${GREEN}cd prometheus_server${NC}"
echo -e "${GREEN}bash install_prometheus_stack.sh${NC}"
