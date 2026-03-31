server {
    listen 443 ssl;
    server_name bbb.tivaliclub.com;

    ssl_certificate /etc/letsencrypt/live/bbb.tivaliclub.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/bbb.tivaliclub.com/privkey.pem;

    # Для WebSocket
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    # Остальные заголовки
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # Таймауты для WebSocket
    proxy_read_timeout 3600s;
    proxy_connect_timeout 3600s;
    proxy_send_timeout 3600s;

    add_header X-Robots-Tag "noindex, nofollow, nosnippet, noarchive" always;

    location = /robots.txt {
        add_header Content-Type text/plain;
        return 200 "User-agent: *\nDisallow: /\n";
    }

    location / {
        proxy_pass https://192.168.1.25;  # IP BBB-сервера
    }

    # Важно! Для WebSocket SFU
    location /ws/ {
        proxy_pass https://192.168.1.25;
    }

    location /html5client/ {
        proxy_pass https://192.168.1.25;
    }

    location /bigbluebutton/ {
        proxy_pass https://192.168.1.25;
    }
}
