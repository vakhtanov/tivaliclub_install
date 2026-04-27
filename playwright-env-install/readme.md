#PlayWright install

## Description

install PlayWright on server - some number of docker containers? one to one QA for isolating

## Install 

if need - download files and install docker
```
wget --no-cache -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/playwright-env-install/download_repo.sh
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

### Trace Viewer
Готов к запуску? Если тестировщики планируют использовать Trace Viewer, 
им понадобится проброс еще одного порта или использование npx playwright show-trace с флагом хоста. 


