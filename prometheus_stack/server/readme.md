# Poretheus_stack

[https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker](https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker)

## Connect VMs SAMPLE
proxy  
`ssh -i c:\Users\User\.ssh\wahha_rsa wahha@devopsdemo.ru`  
prometheus  
`ssh -o ProxyCommand="ssh -i c:\Users\User\.ssh\wahha_rsa -W %h:%p wahha@devopsdemo.ru" -i c:\Users\User\.ssh\wahha_rsa wahha@192.168.0.6`  

## SET VARIABLES in install_prometheus_stack.sh

INSTALL_DIR="/opt/prometheus_stack"  
PROMETHEUS_SRV_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/server"  
DOCKER_REPO="https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/docker"  

## START SCRIPT

`wget -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/prometheus_stack/server/install_prometheus_stack.sh | bash`

## ADD NODES

add in file `prometheus/etc/targets.json

host added on a fly



# script step -- FOR INFORMATION

Создаем каталоги, где будем создавать наши файлы:
`mkdir -p /opt/prometheus_stack/{prometheus,grafana,alertmanager,blackbox}`

## Prometheus node-exporter

Создаем (скачиваем) файл:

`touch /opt/prometheus_stack/docker-compose.yml`

Переходим в каталог prometheus_stack:

`cd /opt/prometheus_stack`

Создаем конфигурационный файл для prometheus:

`mkdir -p ./prometheus/etc`

`nano prometheus/prometheus.yml`

```
scrape_configs:
  - job_name: node
    scrape_interval: 5s
    static_configs:
    - targets: ['node-exporter:9100']
```
* в данном примере мы прописываем наш node-exporter в качестве таргета.

Заранее создаем каталог с данными и назначаем ему владельца:

`mkdir -p ./prometheus/data`

`chown 65534:65534 ./prometheus/data`


## Grafana

Ждем несколько секунд и можно пробовать подключиться.  
Открываем браузер и переходим по адресу   
http://<IP-адрес сервера>:9090 — мы должны увидеть страницу Prometheus  
http://<IP-адрес сервера>:9100 — мы должны увидеть страницу Node Exporter  

 http://<IP-адрес сервера>:3000 — мы должны увидеть стартовую страницу Grafana.

Для авторизации вводим admin / admin. После система потребует ввести новый пароль.

Настроим связку с Prometheus. Кликаем по иконке Configuration - Data Sources:
Переходим к добавлению источника, нажав по Add data source:
Среди списка источников данных находим и выбираем Prometheus, кликнув по Select:
Задаем параметры для подключения к Prometheus:
Сохраняем настройки, кликнув по Save & Test:
Добавим дашборд для мониторинга с node exporter. Для этого уже есть готовый вариант.

Кликаем по изображению плюса и выбираем Import:

Вводим идентификатор дашборда. Для Node Exporter это 1860:
Кликаем Load — Grafana подгрузит дашборд из своего репозитория — выбираем в разделе Prometheus наш источник данных и кликаем по Import:
Мы увидим страницу с настроенными показателями метрик. Можно пользоваться.

## AlertManager

В нашем примере мы настроим отправку уведомлений на телеграм бот. Само оповещение будет выполнять AlertManager, который интегрируется с Prometheus.
Для начала подготовим наш бот телеграм. Создадим нового — для этого открываем телеграм и ищем @my_id_bot:
риложение покажет наш идентификатор. Записываем — он нам потребуется позже.
Теперь создаем бота. Ищем @BotFather:
Переходим в чат с найденным BotFather и запускаем бота:
Создаем бота, последовательно введя команду /newbot и отвечая на запросы мастера:
* в нашем примере мы создаем бота prometheus_alert с именем учетной записи DmoskPrometheusBot.

Переходим в чат с созданным ботом, кликнув по его названию:
Запускаем бота:
Попробуйте протестировать отправку из командной строки. Для этого нужно сделать запрос типа GET с синтаксисом:

`https://api.telegram.org/bot<BotID>/sendMessage?chat_id=<ChannelName>\&text=<Text>`

Проще всего, для этого использовать утилиту командной строки curl. Пример команды:

`curl 'https://api.telegram.org/bot1234567890:ABCDEFGHIYKLMNOPI8e48SeTHIGfzD8W4E/sendMessage?chat_id=@dmosk_ru\&text=test'`

* обратите внимание, что токен передается в формате 'bot' + <token>.

Проверяем сообщение в телеграм канале — мы должны увидеть наше тестовое сообщение.

Теперь открываем конфигурационный файл для prometheus:
`prometheus/prometheus.yml`
в данном примере мы указали, что наш сервер мониторинга должен использовать в качестве системы оповещения alertmanager, который доступен по адресу alertmanager:9093. Также мы добавили файл alert.rules с описанием правил оповещения.

* в данном примере мы указали, что наш сервер мониторинга должен использовать в качестве системы оповещения alertmanager, который доступен по адресу alertmanager:9093. Также мы добавили файл alert.rules с описанием правил оповещения.

Создаем файл с правилами оповещения:
`prometheus/alert.rules`

* в данном примере мы добавили правило, которое будет срабатывать при недоступности узла (node-exporter).

Переходим к конфигурированию alertmanager:
`alertmanager/config.yml`

* данная конфигурация позволяет отправлять оповещения в телеграм. Указываем:

bot_token — токен бота.
chat_id — идентификатор чата, группы или канала.

 http://<IP-адрес сервера>:9090 — на вкладке Alerts мы должны увидеть нашу настройку:

 Попробуем проверить работу оповещения. Отключаем наш node exporter:
 `docker stop exporter`
 На телеграм должно прийти оповещение:


 ## Blackbox exporter
Переходим к настройке мониторинга http сервисов. В нашем примере мы будем проверять работу сайта dmosk.ru.
