Урок:
Модули курса DevOps-инженер с нуля/Виртуализация и контейнеризация/Презентация "Практическое применение1

In docker file

Mount secrets


УрокЖ
Модули курса DevOps-инженер с нуля/Виртуализация и контейнеризация/Презентация "Практическое примен2

in docker compose

```
version: '3'
services:
db:
image: mysql:${MYSQL_VERSION:-8}
environment:
- MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-p@ssw0rd}'
- MYSQL_DATABASE=wordpress
- MYSQL_USER=wordpress
- MYSQL_PASSWORD=${MYSQL_PASSWORD:-p@ssw0rd}
env_file:
- /opt/secrets/wordpress_env
wordpress:
image: wordpress
environment:
- WORDPRESS_DB_NAME=wordpress
- WORDPRESS_DB_USER=wordpress
- WORDPRESS_DB_PASSWORD=${MYSQL_PASSWORD:-p@ssw0rd}
- WORDPRESS_DB_HOST=mysql
env_file:
- /opt/secrets/wordpress_env
cat .env
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_PASSWORD=wordpress
```


.env  
```
cat .env
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_PASSWORD=wordpress
```
