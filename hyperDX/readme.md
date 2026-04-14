## Что такое hyperDX

**1. Программные компоненты (Инфраструктура)**

- HyperDX работает как оркестрация нескольких сервисов:

- ClickHouse: Главный «движок». В нем хранятся все логи, трейсы и метрики. Это сердце системы, обеспечивающее высокую скорость поиска.

- MongoDB: Используется для хранения метаданных (настройки дашбордов, профили пользователей, правила алертинга).

- Redis: Необходим для кэширования и управления очередями задач.

- HyperDX App & API: Собственные контейнеры платформы для интерфейса и обработки запросов.

- Ingestor: Сервис, который принимает данные по протоколу OTLP (OpenTelemetry).

**2. Сбор данных (Инструментарий)**

- Чтобы в HyperDX что-то появилось, вам нужно настроить отправку данных из вашего приложения:

- OpenTelemetry SDK: Библиотеки для вашего языка программирования (Node.js, Python, Go, Java и т.д.), которые будут собирать трейсы и логи.

- OpenTelemetry Collector (опционально, но рекомендуется): Промежуточный агент, который собирает данные с разных сервисов и пересылает их в HyperDX.

- HyperDX Browser SDK: Если вы хотите использовать функцию Session Replay (запись действий пользователя в браузере).

**3. Минимальные системные требования**

Для запуска через Docker (минимальный сетап для тестов):

- CPU: минимум 2 ядра (ClickHouse любит ресурсы при тяжелых запросах).

- RAM: от 4 ГБ (лучше 8 ГБ+, так как ClickHouse и MongoDB довольно прожорливы).

- Disk: Быстрый SSD (скорость работы ClickHouse напрямую зависит от дисковой подсистемы).

====================================================

## HyperDX за обратным прокси

https://github.com/hyperdxio/hyperdx/blob/main/proxy/README.md

**1. Конфигурация Nginx (для интерфейса)**
Этот конфиг обеспечит работу интерфейса, авторизацию и «живое» обновление данных через WebSocket
```nginx
server {
    listen 443 ssl;
    server_name hyperdx.company.local; # или внешний домен

    location / {
        proxy_pass http://<IP_ХОСТА_HYPERDX>:8080;
        
        # Поддержка WebSocket (обязательно для live-логов в браузере)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}


### это пример официального конфига
upstream app {
    server 127.0.0.1:8080;
}

server {
    listen 4040;

    set $base_path "${HYPERDX_BASE_PATH}";
    if ($base_path = "/") {
        set $base_path "";
    }

    # Common proxy headers
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # Redirect root to base path, if a base path is set
    location = / {
        if ($base_path != "") {
            return 301 $base_path;
        }
        # If no base path, just proxy to the app
        proxy_pass http://app;
    }

    # This handles assets and api calls made to the root and rewrites them to include the base path
    location ~ ^(/api/|/_next/|/__ENV\.js$|/Icon32\.png$) {
        # Note: $request_uri includes the original full path including query string
        proxy_pass http://app$base_path$request_uri;
    }

    # Proxy requests that are already prefixed with the base path to the app
    location ${HYPERDX_BASE_PATH} {
        # The full request URI (e.g., /hyperdx/settings) is passed to the upstream
        proxy_pass http://app;
    }
}

```

**2. Важная настройка в HyperDX (.env)**
Чтобы интерфейс понимал, что он работает через HTTPS и внешний домен (для генерации правильных ссылок и куки), в файле .env вашего HyperDX укажите:
```env
SERVER_URL=https://yourdomain.com
```
После изменения перезапустите контейнеры: `docker compose up -d.`

**3. Нюанс с логами (Ingestor)**
Раз логи приходят с других серверов, убедитесь в следующем:  
- Порты сбора: Если ваши серверы шлют логи напрямую в HyperDX минуя этот прокси, то порты 4317 (gRPC) и 4318 (HTTP) должны быть открыты во внешней сети (или через VPN).
- На ваших серверах, которые шлют логи, в конфиге OpenTelemetry Collector или в коде приложения указывайте внутренний IP сервера HyperDX, минуя Nginx:
  - Endpoint: http://192.168.x.x:4318 (для HTTP)
  - Endpoint: http://192.168.x.x:4317 (для gRPC)

 ===================================================

 ## Самодподписанный сертификат

**1. Выполните это на сервере, где стоит Nginx. Замените hyperdx.local на ваш реальный домен или IP-адрес.**
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout hyperdx.key -out hyperdx.crt \
  -subj "/C=RU/ST=State/L=City/O=IT/CN=hyperdx.local" \
  -addext "subjectAltName = DNS:hyperdx.local,IP:192.168.1.100"
```

`hyperdx.key` — ваш закрытый ключ (храните в секрете).  
`hyperdx.crt` — ваш сертификат (публичная часть).  
`-days 365` — срок действия (через год нужно обновить).  

**2. Подключение в Nginx**
Положите файлы в папку /etc/nginx/ssl/ и укажите пути в конфиге:
```nginx
server {
    listen 443 ssl;
    server_name hyperdx.local;

    ssl_certificate     /etc/nginx/ssl/hyperdx.crt;
    ssl_certificate_key /etc/nginx/ssl/hyperdx.key;

    # Рекомендуемые настройки безопасности для самоподписанных сертификатов
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://localhost:8080;
        # ... остальные настройки прокси (из предыдущих ответов)
    }
}
```

**3. Настройка доверия (чтобы браузер не ругался)**
Так как сертификат вы выписали себе сами, браузер покажет предупреждение «Ваше подключение не защищено». У вас есть два пути:
- Простой: Нажать «Дополнительно» -> «Перейти на сайт (небезопасно)».
- Правильный: Импортировать файл hyperdx.crt в хранилище доверенных корневых сертификатов на вашем компьютере (в Windows это certlm.msc, в macOS — «Связка ключей»).

https://github.com/hyperdxio/hyperdx/blob/main/docker/nginx/README.md

===================
## Варианты установки

[варианты](https://clickhouse.com/docs/use-cases/observability/clickstack/deployment)


**Установка через docker compose**  
[https://github.com/ClickHouse/ClickStack](https://github.com/ClickHouse/ClickStack)

==========
## Чистка ClickHouse

**1. Настройка автоматической очистки (TTL) — Рекомендуемый**
Это самый правильный способ. Вы задаете правило, и ClickHouse сам удаляет старые данные.
Нужно подключиться к ClickHouse (например, через clickhouse-client внутри контейнера) и выполнить SQL-запрос для таблицы логов:
```sql
ALTER TABLE hdx.logs 
MODIFY TTL timestamp + INTERVAL 30 DAY;
```

В этом примере логи старше 30 дней будут удаляться автоматически.

**2. Ручная очистка через удаление партиций**
Если место на диске закончилось прямо сейчас, можно удалить данные за конкретный месяц или день.

- Посмотреть список партиций и их размер:
```sql
SELECT partition, name, table, active 
FROM system.parts 
WHERE table = 'logs';
```

- Удалить конкретную партицию (например, за январь 2024):
```sql
ALTER TABLE hdx.logs DROP PARTITION '202401';
```

**3. Нюанс с Docker-контейнером**
Если вы используете стандартный docker-compose от HyperDX, подключиться к консоли ClickHouse можно так:
```bash
docker exec -it hyperdx-clickhouse-1 clickhouse-client
```


## Перед установкой докера - обязательно apt update

Важно: Не забудьте также проверить таблицу hdx.spans (там хранятся трейсы) и hdx.metrics, так как они тоже могут занимать много места.
