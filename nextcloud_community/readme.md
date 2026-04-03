
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


**узнаем пароль - задан при установке**

**Настраиваем прокси - перенаправление на сервер nextcloud**

**заходим на доменное имя**

далее меню пользователя/приложения/пакеты приложений/Talk - установить



  *Все адреса и доменные имена исправляем на ИСПОЛЬЗУЕМЫЕ*

  [https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/nginx_reverse-proxy](https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/nginx_reverse-proxy)
