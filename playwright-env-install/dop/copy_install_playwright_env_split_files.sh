#!/bin/bash

# 1. Set path
BASE_DIR="/opt/playwright-env-install"
KEYS_DIR="$(pwd)/authorized_keys"
DEV_COUNT=2

# Set playwright version
PW_VERSION="v1.58.2-noble" 

echo "--- Start install Playwright Environment ---"

# Check SSH keys
if [ ! -d "$KEYS_DIR" ] || [ -z "$(ls -A "$KEYS_DIR"/*.pub 2>/dev/null)" ]; then
    echo "ERROR: Folder $KEYS_DIR empty. Put .pub keys in $(pwd)/keys"
    exit 1
fi

# 2. Create tree
sudo mkdir -p $BASE_DIR


cd $BASE_DIR
for i in $(seq 1 $DEV_COUNT); do sudo mkdir -p "dev$i"; done

# 3. Combine file authorized_keys
cat "$KEYS_DIR"/*.pub | sudo tee authorized_keys > /dev/null

# 7. Create file package.json (всегда ставит актуальную версию под образ)
for i in $(seq 1 $DEV_COUNT); do
    echo '{"devDependencies": {"@playwright/test": "latest"}}' | sudo tee "dev$i/package.json" > /dev/null
done

# 8. Start
sudo docker-compose up -d --build

echo "Finish used image ://microsoft.com"
echo "Ports: 2221, 2222, 2223. User: root"