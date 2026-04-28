#PlayWright install

## Description

install PlayWright on server - some number of docker containers? one to one QA for isolating

## Install 

if need - download files and install docker
```
wget --no-cache -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/playwright-env-install/download_repo.sh | bash
```


**put public keys in  folder `authorized_keys`**

set application variables in `install_playwright_env_split_files.sh`  
BASE_DIR="/opt/playwright-env-install"  
KEYS_DIR="$(pwd)/authorized_keys"  
DEV_COUNT=2  #Number of users
PW_VERSION="noble"   

edit docker-compose.yml for set number of needed containers and ports

## QA connect ssh by key

then start `npm install`

### Docker documentation

https://playwright.dev/docs/docker  
https://mcr.microsoft.com/en-us/artifact/mar/playwright/about  

#### VS Code extension

Первый вход: Обязательно выполнить npm install.
Запись теста: Использовать кнопку Record new в расширении Playwright внутри VS Code.
Обновление: Если они хотят обновить Playwright, им нужно попросить тебя перезапустить скрипт, а затем снова сделать npm install.

#### codegen
for generate test

Чтобы codegen работал через эту схему, VS Code автоматически пробросит нужные порты. Единственное требование — у разработчика должно быть установлено расширение Playwright Test внутри этого удаленного подключения (VS Code предложит его установить «на удаленный сервер»).

### Trace Viewer
Готов к запуску? Если тестировщики планируют использовать Trace Viewer, 
им понадобится проброс еще одного порта или использование npx playwright show-trace с флагом хоста. 

### USER WORKSPACE

Этап 3: Настройка рабочих мест разработчиков
Каждый разработчик на своем ноутбуке выполняет следующие действия:
1. Установка софта
Установить VS Code.
Установить расширение Remote - SSH (Microsoft).
Установить расширение Playwright Test for VSCode.
2. Подключение к серверу
В VS Code нажать кнопку в левом нижнем углу (><) или F1 -> Remote-SSH: Connect to Host.
Ввести: ssh username@ip-адрес-сервера.
Когда VS Code откроется внутри сервера (внизу будет надпись SSH: IP), открыть папку /opt/playwright-testing.
⏺ Этап 4: Запуск и использование Codegen
Теперь разработчик готов записывать тесты:
В VS Code на сервере открыть вкладку Testing (значок колбы).
В секции Playwright поставить галочку "Show browser".
Нажать кнопку "Record new".
Магия: На локальном компьютере разработчика всплывет окно Chromium, запущенного на сервере. Все действия (клики, ввод текста) будут автоматически превращаться в код в новом файле на сервере.



