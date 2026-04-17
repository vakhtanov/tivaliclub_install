## создание NAT instace для yandex облака

`https://yandex.cloud/ru/docs/vpc/tutorials/nat-instance/console`

## соедениться с хостом через джамп машину (через нат)

`ssh -J <имя_пользователя_NAT-инстанса>@<публичный_IP-адрес_NAT-инстанса> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>`

`ssh -o ProxyCommand="ssh -i <путь/имя_файла_ключа_NAT> -W %h:%p <имя_пользователя_NAT>@<публичный_IP-адрес_NAT>" -i <путь/имя_файла_ключа_ВМ> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>`

`ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3`

`ssh -i c:/Users/wahha/.ssh/wahha_rsa wahha@devopsdemo.ru`

## установить docker 
`wget https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/setup_docker_official.sh`  
`chmod +x setup_docker_official.sh`  
`./setup_docker_official.sh`

## проброс порта черз ssh
на локальную машину  (8080 - локальный порт)  
`ssh -L 8080:localhost:80 user@example-host`  
`ssh -L [Локальный_Порт]:[Удаленный_Адрес]:[Удаленный_Порт] user@server`

с локальной машины на удаленную  
`ssh -R [Удаленный_Порт]:[Локальный_Адрес]:[Локальный_Порт] user@server`

Динамическое перенаправление (Dynamic Forwarding -D) (SOCKS-прокси)  
`ssh -D [Локальный_Порт] user@server`

Флаг -N: Часто используется, чтобы не открывать консоль сервера (только туннель)

https://www.dmosk.ru/miniinstruktions.php?mini=ssh-tunnels

## Пароль и сертификат
`passwd`  

другого пользователя
`sudo passwd имя_пользователя`

`passwd -d имя_пользователя` — удалить пароль 

`passwd -l имя_пользователя` — заблокировать учетную запись  

**Доступ по сертификату**

откройте файл настроек: `sudo nano /etc/ssh/sshd_config`  
Отключить вход по паролю для одного пользователя  
PubkeyAuthentication yes
```
Match User имя_пользователя
    PasswordAuthentication no
```
Убедитесь, что выше в файле общая настройка PasswordAuthentication установлена в значение yes (или закомментирована), чтобы остальные пользователи могли входить как обычно.  
Блок Match должен всегда находиться в конце файла. Все настройки, идущие после него, будут применяться только к указанному пользователю.  
Доступ по ключу: Перед сохранением настроек убедитесь, что вы уже скопировали SSH-ключ для этого пользователя (командой ssh-copy-id), иначе он полностью потеряет доступ к серверу.  
`ssh-copy-id пользователь@ip-адрес-сервера`  
Группы: Если нужно отключить пароли для целой группы людей, используйте `Match Group` название_группы.


Проверьте конфиг на наличие ошибок: `sudo sshd -t`  
перезапустите службу: `sudo systemctl restart ssh`
