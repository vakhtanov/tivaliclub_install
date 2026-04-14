#!/usr/bin/env bash
####==========ПОЛЕЗНЫЕ НАСТРОЙКИ====================================
set -euo pipefail ## ЗАВЕРШАЕТ БАШ СКПРИПТ ПРИ ЛЮБОЙ ОШИБКЕ!!!!!

## КРАСИТ ЭХО В РАЗНЫЕ ЦВЕТА!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
###==================================================================

# 0. Проверка, установлен ли Docker
if command -v docker &> /dev/null; then
    echo "Docker уже установлен. Версия: $(docker --version)"
    exit 0
fi

echo "Docker не найден. Начинаем установку..."

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

# 4. настройка прав
sudo groupadd -f docker
sudo usermod -aG docker $USER

# 5. Вывод версии
echo "------------------------------------------------------"
echo "Установка завершена!"
echo -n "Установленная версия: "
docker --version

echo "------------------------------------------------------"
echo "ВАЖНО: Чтобы запускать контейнеры без sudo, выполните команду:"
echo "newgrp docker"
echo "Или перезайдите в систему."
