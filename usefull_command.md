создание NAT instace для yandex облака

https://yandex.cloud/ru/docs/vpc/tutorials/nat-instance/console

соедениться с хостом через джамп машину (через нат)

ssh -J <имя_пользователя_NAT-инстанса>@<публичный_IP-адрес_NAT-инстанса> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>

ssh -o ProxyCommand="ssh -i <путь/имя_файла_ключа_NAT> -W %h:%p <имя_пользователя_NAT>@<публичный_IP-адрес_NAT>" -i <путь/имя_файла_ключа_ВМ> <имя_пользователя_ВМ>@<внутренний_IP-адрес_ВМ>

ssh -o ProxyCommand="ssh -i c:/Users/wahha/.ssh/wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:/Users/wahha/.ssh/wahha_rsa wahha@192.168.0.3
