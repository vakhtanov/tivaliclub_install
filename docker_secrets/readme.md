# Рекомендуемая передача секретов в docker compose

без переменных окружения, которые доступны многи.

Основная идея, что используются `/run/secrets/<secret_name>` которые доступны только тем приложениям, которым дали доступ в docker-compose.yaml

[docker official](https://docs.docker.com/compose/how-tos/use-secrets/)

С другой стороны официальный образ docker postgres содержит имеет переменную `POSTGRES_PASSWORD_FILE: ________` для передачи пароля.

В приложение пароль и параметры подключения передаются через `ConnectionStrings__DefaultConnection`

сам пароль лежит в файле с ограниченными правами, пример скрипта для его создания [create_secret.sh](./create_secret.sh)

пример [docker_compose.yaml](./docker_compose.yaml)

