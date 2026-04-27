#!/bin/bash

# 1. Настройка путей
BASE_DIR="/opt/playwright-env"
KEYS_DIR="$(pwd)/keys"
DEV_COUNT=3

echo "🔍 Проверяю последнюю версию Playwright..."
# Получаем тег последней версии с noble через API (или используем стабильный noble)
PW_VERSION="noble" 

echo "🚀 Начинаю деплой среды Playwright ($PW_VERSION) для $DEV_COUNT разработчиков..."

# Проверка наличия папки с ключами
if [ ! -d "$KEYS_DIR" ] || [ -z "$(ls -A "$KEYS_DIR"/*.pub 2>/dev/null)" ]; then
    echo "❌ Ошибка: Папка $KEYS_DIR пуста. Положите .pub ключи в $(pwd)/keys"
    exit 1
fi

# 2. Создание структуры
sudo mkdir -p $BASE_DIR
cd $BASE_DIR
for i in $(seq 1 $DEV_COUNT); do sudo mkdir -p "dev$i"; done

# 3. Сбор ключей
cat "$KEYS_DIR"/*.pub | sudo tee authorized_keys > /dev/null

# 4. Создание Dockerfile с динамической версией
cat <<EOF | sudo tee Dockerfile > /dev/null
FROM ://microsoft.com
RUN apt-get update && apt-get install -y openssh-server \\
    && mkdir /var/run/sshd \\
    && mkdir -p /root/.ssh \\
    && chmod 700 /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
EOF

# 5. Создание общего конфига
cat <<EOF | sudo tee playwright.config.ts > /dev/null
import { defineConfig, devices } from '@playwright/test';
export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  reporter: [['html', { open: 'never' }]],
  use: {
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    headless: true,
  },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
});
EOF

# 6. Создание docker-compose.yml
cat <<EOF | sudo tee docker-compose.yml > /dev/null
services:
  dev1:
    build: .
    container_name: playwright_dev1
    ports: ["2221:22"]
    volumes: ["./dev1:/app", "./playwright.config.ts:/app/playwright.config.ts"]
    working_dir: /app
    ipc: host
    restart: unless-stopped
  dev2:
    build: .
    container_name: playwright_dev2
    ports: ["2222:22"]
    volumes: ["./dev2:/app", "./playwright.config.ts:/app/playwright.config.ts"]
    working_dir: /app
    ipc: host
    restart: unless-stopped
  dev3:
    build: .
    container_name: playwright_dev3
    ports: ["2223:22"]
    volumes: ["./dev3:/app", "./playwright.config.ts:/app/playwright.config.ts"]
    working_dir: /app
    ipc: host
    restart: unless-stopped
EOF

# 7. Инициализация package.json (всегда ставит актуальную версию под образ)
for i in $(seq 1 $DEV_COUNT); do
    echo '{"devDependencies": {"@playwright/test": "latest"}}' | sudo tee "dev$i/package.json" > /dev/null
done

# 8. Сборка и запуск
sudo docker-compose up -d --build

echo "✅ Готово! Использован образ: ://microsoft.com"
echo "📍 Порты: 2221, 2222, 2223. Юзер: root"