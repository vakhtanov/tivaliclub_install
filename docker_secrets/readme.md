# Рекомендуемая передача секретов в docker compose

без переменных окружения которые доступны из оболочки.

Основная идея, что используются `/run/secrets/<secret_name>` которые доступны только тем приложениям, которым дали доступ в docker-compose.yaml

[docker official](https://docs.docker.com/compose/how-tos/use-secrets/)

С другой стороны официальный образ docker postgres содержит имеет переменную `POSTGRES_PASSWORD_FILE: ________` для передачи пароля.
