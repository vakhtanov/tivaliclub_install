
**Connect to nextcloud host thrue proxy**  
`ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

**download script to install docker and start nextcloud container**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/docker-compose.yaml -O setup_docker_tv_mod.sh`

`chmod +x setup_docker_tv_mod.sh`


**start setup_docker_tv_mod.sh**

'sudo ./setup_docker_official.sh'


**start nextcloud**

`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/nextcloud/docker-compose.yaml -O docker-compose.yaml`

`docker compose up` - SUDO NOT NEED for docker

**узнаем пароль для админки nextcloud**

`docker exec nextcloud-aio-mastercontainer grep password /mnt/docker-aio-config/data/configuration.json`

**новая сессия ssh для проброса портов на управляющую машину**

`ssh -L 8080:127.0.0.1:8080 -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

**через браузер на машине управления заходим на страницу**

https://localhost:8080

**вводим пароль**
