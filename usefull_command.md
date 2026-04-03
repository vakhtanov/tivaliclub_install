**создание NAT instace для yandex облака**

`https://yandex.cloud/ru/docs/vpc/tutorials/nat-instance/console`

**соедениться с хостом через джамп машину (через нат)**

`ssh -J <имя_пользователя_NAT-инстанса>@<публичный_IP-адрес_NAT-инстанса> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>`

`ssh -o ProxyCommand="ssh -i <путь/имя_файла_ключа_NAT> -W %h:%p <имя_пользователя_NAT>@<публичный_IP-адрес_NAT>" -i <путь/имя_файла_ключа_ВМ> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>`

`ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

`ssh -i c:/Users/wahha/.ssh/wahha_rsa wahha@devopsdemo.ru`

**установить docker**  
`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/setup_docker_official.sh`  
`chmod +x setup_docker_official.sh`  
`./setup_docker_official.sh`

ssh -L 8080:localhost:80 user@example-host


https://www.dmosk.ru/miniinstruktions.php?mini=ssh-tunnels
