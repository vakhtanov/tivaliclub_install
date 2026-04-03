
# Установка NextCloud

https://github.com/docker-library/docs/blob/master/nextcloud/README.md

**Connect to nextcloud host thrue proxy**  
`ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

*Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*


**download script to install docker and start nextcloud container**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/start%20setup_docker_tv_mod.sh -O setup_docker_tv_mod.sh`

`chmod +x setup_docker_tv_mod.sh`


**start setup_docker_tv_mod.sh**

`./setup_docker_tv_mod.sh` - SUDO NOT NEED


**start nextcloud**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud_community/docker-compose.yaml -O docker-compose.yaml`  
`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud_community/postgres_password.txt -O postgres_password.txt`  
`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud_community/nextcloud_admin_password.txt -O nextcloud_admin_password.txt`  


*Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*

`docker compose up` - SUDO NOT NEED for docker


============================================================


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
