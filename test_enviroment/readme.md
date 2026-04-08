Роль: Системный архитектор.

Задача: Спроектировать защищенную инфраструктуру, независимую от специфических сервисов облачных провайдеров (Cloud Agnostic).

Сетевая архитектура (стандартная):
Gateway: ВМ в публичной сети. На ней только WireGuard (VPN) и Traefik/Nginx (Reverse Proxy). Открыт только один порт (443 или VPN).
Backend Network: Изолированная приватная сеть для всех остальных ВМ.
Egress: Доступ в интернет из привата через стандартный NAT-инстанс/шлюз.

Стек сервисов (Docker-based):
Git & CI/CD: GitLab Omnibus в Docker-контейнере.
Secrets: Использование встроенных GitLab CI Variables или SOPS для шифрования конфигов (без привязки к облачным KMS).
Runner: GitLab Runner (Docker executor), настроенный на автоматический деплой через docker-compose на целевую машину.
Target (Sandbox): Чистая ВМ с Docker для запуска приложений.
Monitoring: Uptime Kuma + Netdata (базовый self-hosted стек).

Требования к ответу:
Схема движения трафика: Пользователь -> VPN -> Private IP (SSH/HTTP).
Универсальный docker-compose.yml для поднятия GitLab и Runner.
Пример пайплайна .gitlab-ci.yml, который деплоит приложение на Sandbox, используя только SSH-ключи и переменные окружения.
Рекомендации по ресурсам (CPU/RAM) для комфортной работы GitLab.
