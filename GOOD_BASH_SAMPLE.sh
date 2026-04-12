#!/usr/bin/env bash
set -euo pipefail ## ЗАВЕРШАЕТ БАШ СКПРИПТ ПРИ ЛЮБОЙ ОШИБКЕ!!!!!

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/hyperdx"
RUN_USER="hyperdx"
SERVER_IP="hyperdx.tivaliclub.com"  # ← Твой домен!

## КРАСИТ ЭХО В РАЗНЫЕ ЦВЕТА!!!!
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# --- 0) Проверки ---
if ! command -v apt-get >/dev/null 2>&1; then
  echo "Этот скрипт рассчитан на Ubuntu/Debian (apt)."
  exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
  echo "Запусти скрипт от root (пример: sudo ./install-and-run-hyperdx-in-opt-ubuntu.sh)"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Установка HyperDX в /opt/hyperdx${NC}"
echo -e "${GREEN}  и настройка очистки ClickHouse${NC}"
echo -e "${GREEN}========================================${NC}"

# --- 1) Обновление системы и установка утилит ---
apt-get update
apt-get -y upgrade
apt-get -y install ca-certificates curl git sed

# --- 2) Установка Docker из официального репозитория ---
echo -e "${GREEN}---===*** Проверка наличия Docker ***===---${NC}"

if command -v docker >/dev/null 2>&1; then
  DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | tr -d ',')
  echo -e "${GREEN}✅ Docker уже установлен (версия: $DOCKER_VERSION)${NC}"
else
  echo -e "${YELLOW}Docker не найден. Начинаю установку...${NC}"

  apt-get -y install apt-transport-https gnupg lsb-release

  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt-get update

  apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  systemctl enable --now docker

  DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | tr -d ',')
  echo -e "${GREEN}✅ Docker успешно установлен (версия: $DOCKER_VERSION)${NC}"
fi

# --- 3) Создание отдельного пользователя для HyperDX ---
if id -u "${RUN_USER}" >/dev/null 2>&1; then
  echo "Пользователь '${RUN_USER}' уже существует."
else
  useradd -m -s /bin/bash "${RUN_USER}"
  echo "Создан пользователь '${RUN_USER}'."
fi

usermod -aG docker "${RUN_USER}"

# --- 4) Подготовка /opt и клонирование репозитория ---
if [[ -e "${INSTALL_DIR}" ]]; then
  echo "Путь '${INSTALL_DIR}' уже существует."
  echo "Удалите/переименуйте его или измените INSTALL_DIR в скрипте."
  exit 1
fi

mkdir -p "$(dirname "${INSTALL_DIR}")"
git clone "${REPO_URL}" "${INSTALL_DIR}"
chown -R "${RUN_USER}:${RUN_USER}" "${INSTALL_DIR}"

# --- 5) Правки docker-compose.yml и .env ---
cd "${INSTALL_DIR}"

echo "Обновляю SERVER_URL в docker-compose.yml -> http://${SERVER_IP}"
sed -i.bak -E \
  "s|^(\s*SERVER_URL:\s*)http://127\.0\.0\.1(:$\{HYPERDX_API_PORT\})?\s*$|\1http://${SERVER_IP}\2|g" \
  docker-compose.yml

echo "Обновляю HYPERDX_APP_URL в .env -> http://${SERVER_IP}"
sed -i.bak -E \
  "s|^(HYPERDX_APP_URL=)http://localhost\s*$|\1http://${SERVER_IP}|g" \
  .env

chown "${RUN_USER}:${RUN_USER}" docker-compose.yml docker-compose.yml.bak .env .env.bak


# --- 6) Запуск под пользователем hyperdx ---
echo "Запускаю контейнеры от пользователя '${RUN_USER}'..."
sudo -u "${RUN_USER}" -H bash -lc "cd '${INSTALL_DIR}' && docker compose up -d"

# --- 7) Настройка ClickHouse ---
echo -e "${GREEN}---===*** Настройка ClickHouse TTL (очистка логов старше 7 дней) ***===---${NC}"


CH_CONTAINER=$(sudo -u "${RUN_USER}" -H bash -lc "cd '${INSTALL_DIR}' && docker compose ps --services | grep clickhouse")
if [ -z "$CH_CONTAINER" ]; then
  CH_CONTAINER=$(docker ps --filter "name=ch-server" --format "{{.Names}}" | head -1)
fi
if [ -z "$CH_CONTAINER" ]; then
  CH_CONTAINER=$(docker ps --filter "ancestor=clickhouse/clickhouse-server" --format "{{.Names}}" | head -1)
fi
if [ -z "$CH_CONTAINER" ]; then
  CH_CONTAINER=$(docker ps | grep clickhouse | awk '{print $NF}')
fi

if [ -z "$CH_CONTAINER" ]; then
  echo -e "${YELLOW}⚠️  ClickHouse контейнер не найден. Пропускаем настройку TTL.${NC}"
else
  echo -e "${GREEN}✅ Найден ClickHouse контейнер: $CH_CONTAINER${NC}"


  sudo -u "${RUN_USER}" -H bash -lc "docker exec $CH_CONTAINER clickhouse-client --query='ALTER TABLE default.otel_logs MODIFY TTL Timestamp + INTERVAL 7 DAY;' 2>/dev/null"
  echo -e "${GREEN}✅ TTL установлен на 7 дней${NC}"

  echo -e "${GREEN}---===*** Удаление старых логов ***===---${NC}"
  sudo -u "${RUN_USER}" -H bash -lc "docker exec $CH_CONTAINER clickhouse-client --query='OPTIMIZE TABLE default.otel_logs FINAL;' 2>/dev/null"

  sudo crontab -l 2>/dev/null | grep -v "clickhouse" | sudo crontab - 2>/dev/null || true
  (sudo crontab -l 2>/dev/null; echo "0 0 * * * cd ${INSTALL_DIR} && sudo -u ${RUN_USER} -H bash -lc 'docker exec $CH_CONTAINER clickhouse-client --query=\"OPTIMIZE TABLE default.otel_logs FINAL;\" 2>/dev/null'") | sudo crontab -
  echo -e "${GREEN}✅ Cron добавлен (ежедневная оптимизация в 00:00)${NC}"

  OLD_LOGS=$(sudo -u "${RUN_USER}" -H bash -lc "docker exec $CH_CONTAINER clickhouse-client --query='SELECT COUNT(*) FROM default.otel_logs WHERE Timestamp < now() - INTERVAL 7 DAY;' 2>/dev/null | tr -d ' ')
  echo -e "${GREEN}✅ Старых логов осталось: $OLD_LOGS${NC}"
fi

# --- Финальный вывод ---
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  УСТАНОВКА ЗАВЕРШЕНА!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  HyperDX: cd ${INSTALL_DIR}${NC}"
echo -e "${GREEN}  Домен: ${SERVER_IP}${NC}"
echo -e "${GREEN}  UI:     http://${SERVER_IP}:8080${NC}"
echo -e "${GREEN}  API:    http://${SERVER_IP}:8000${NC}"
echo -e "${GREEN}  ClickHouse: логи старше 7 дней удаляются автоматически${NC}"
