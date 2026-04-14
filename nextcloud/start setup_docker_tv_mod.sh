#!/usr/bin/env bash

set -euo pipefail ## ЗАВЕРШАЕТ БАШ СКПРИПТ ПРИ ЛЮБОЙ ОШИБКЕ!!!!!

# 1. Set up Docker's apt repository
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add the repository to Apt sources
echo "Adding Docker repository..."
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# 3. Install docker
echo "---===*** Install docker ***===---"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. Check docker status
# systemctl status docker

# 5. make run container from user
sudo groupadd -f docker
sudo usermod -aG docker $USER

echo "Готово! Docker установлен."
echo "ВНИМАНИЕ: Чтобы запускать docker без sudo, перезайдите в систему или выполните команду: newgrp docker"

