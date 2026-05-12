
# Установка NextCloud

**Connect to nextcloud host thrue proxy**  
`ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

*Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*


**download script to install docker and start nextcloud container**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/docker/setup_docker_tv_mod.sh -O setup_docker_tv_mod.sh`

`chmod +x setup_docker_tv_mod.sh`


**start setup_docker_tv_mod.sh**

`./setup_docker_tv_mod.sh` - SUDO NOT NEED 



**выйти из сеанса и зайти заново**

**start nextcloud**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/docker-compose.yaml -O docker-compose.yaml`


**start nextcloud on host100**
```
wget https://gitverse.ru/api/repos/wahha/tivaliclub_install/raw/branch/main/nextcloud%2Fdocker-compose_for100.yaml -O docker-compose_for100.yaml
```
docker-compose_for100.yaml

*Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*

`docker compose up` - SUDO NOT NEED for docker

**узнаем пароль для админки nextcloud**

`docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json`

**новая сессия ssh для проброса портов на управляющую машину**

*Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*

`ssh -L 8080:127.0.0.1:8080 -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

**через браузер на машине управления заходим на страницу**

https://localhost:8080 - это админка для дальнейшей установки

**вводим пароль**

**проверяем домен и настраиваем далее**


* На reverse-proxy должна быть перенаправление НТТPS на хост NEXTCLOUD и порт 11000
* На фаирволе также должны быть открыты порты 3478/TCP и 3478/UDP для TALK

  **пример настройки revers-proxy**

  *Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*

  [https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/nginx_reverse-proxy](https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/nginx_reverse-proxy)
