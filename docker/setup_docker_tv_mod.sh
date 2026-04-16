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
    echo -e "${GREEN}Docker уже установлен. Версия: $(docker --version)${NC}"
    exit 0
fi

echo -e "${YELLOW}Docker не найден. Начинаем установку...${NC}"

# 1. Set up Docker's apt repository
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 2. Add the repository to Apt sources
echo -e "${YELLOW}Adding Docker repository...${NC}"
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# 3. Install docker
echo -e "${YELLOW}---===*** Install docker ***===---${NC}"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 4. настройка прав
sudo groupadd -f docker
sudo usermod -aG docker $USER

# 5. Вывод версии
echo "------------------------------------------------------"
echo -e "${GREEN}Установка завершена!${NC}"
echo -n "Установленная версия: "
docker --version

echo "------------------------------------------------------"
echo -e "${YELLOW}ВАЖНО: Чтобы запускать контейнеры без sudo, выполните команду:${NC}"
echo -e "${YELLOW}newgrp docker${NC}"
echo -e "${YELLOW}Или перезайдите в систему.${NC}"
