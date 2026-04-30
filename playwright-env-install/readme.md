#PlayWright install

## Description

install PlayWright on server - number of docker containers one to one QA for isolating

QA use VsCode and connect TO CONTAINER via SSH (SSH key). Use playwright VsCode plugin to create, start and view tests

## Install on desktop ========================================================
Instruction for Win only (Win 10, 11)

1. Install VsCode

[https://code.visualstudio.com/download](https://code.visualstudio.com/download)

Extention --> Install Remote - SSH (Microsoft)

2. Install X server (VcXsrv)

[https://sourceforge.net/projects/vcxsrv/](https://sourceforge.net/projects/vcxsrv/)

3. Config SSH settings

```
## BASTION HOST (IF PRESENT)
Host [Name for SSH] 
  HostName [HostName/IP]
  User [USER]
  Port 22
  IdentityFile "C:\Users\User\.ssh\wahha_rsa"
  ForwardX11 yes
  ForwardX11Trusted yes
  Compression yes

## Server for PlayWright
Host [Name for SSH]
  HostName [HostName/IP]
  User [USER]
  Port 22
  IdentityFile "C:\Users\User\.ssh\wahha_rsa"
  ForwardX11 yes
  ForwardX11Trusted yes
  Compression yes
  ProxyJump devopsdemo.ru ## IF NEED


## Docker container with playwright for do tests
Host [Name for SSH]
  HostName [HostName/IP]
  User root
  Port 2221
  IdentityFile "C:\Users\User\.ssh\wahha_rsa"
  ForwardX11 yes
  ForwardX11Trusted yes
  Compression yes
  Ciphers aes128-gcm@openssh.com,chacha20-poly1305@openssh.com #More simple coding
  ProxyJump devopsdemo.ru ## IF NEED

```

4. Config Win USER enviroment

Win Settings --> "Переменные среды пользователя"

DISPLAY  =  localhost:0.0

Relogin to System

5. Start and config X server

XLaunch --> Multiple windows --> Start on client --> Disable access control --> Save --> Finish

Approve access

6. Start VsCode

F1 --> RemoteSSH: Connect curent ... --> playwright_dev1 (for dev1)

Open Folder --> /app

Extention --> Install Playwright Test for VSCode (Microsoft)

7. Init playwright project

`npx playwright install`

## Files in working dir (/app) and some information

Language for test - TypeScript  

`playwright.config.ts` - PlayWright config  
`tests` - Tests  
`test-results` - Test result  
`playwright-report` - reports  

`xhost +`  
или  
`xhost +local:root`  
Если при запуске браузера вы получаете ошибку: Error: Can't open display: :0 или Protocol not specified.  
Её нужно вводить на самом сервере (не внутри контейнера) перед запуском docker-compose up.


## Install on SERVER ========================================================

1. if need  install docker, add current user to docker group

2. If need download application files 

```
wget --no-cache -O - https://raw.githubusercontent.com/vakhtanov/tivaliclub_install/refs/heads/main/playwright-env-install/download_repo.sh | bash
```

3. CD PlayWright folder

4. **put public keys in  folder `authorized_keys`**

5. Set application variables in `.env`  
```
BASE_DIR="/opt/playwright-env-install"  
KEYS_DIR="$(pwd)/authorized_keys"  
DEV_COUNT=2  #Number of users
PW_VERSION="v1.59.1-noble"   
```
6. Edit docker-compose.yml for adjast number containers with .env and set ports

7. Start install_playwright_env_split_files.sh

`bash install_playwright_env_split_files.sh`



## =================================================

## Additional information


### Playwright in Docker documentation

https://playwright.dev/docs/docker  
https://mcr.microsoft.com/en-us/artifact/mar/playwright/about  

#### VS Code extension

Первый вход: Обязательно выполнить npm install.
Запись теста: Использовать кнопку Record new в расширении Playwright внутри VS Code.
Обновление: Если они хотят обновить Playwright, им нужно попросить тебя перезапустить скрипт, а затем снова сделать npm install.


### Trace Viewer
Готов к запуску? Если тестировщики планируют использовать Trace Viewer, 
им понадобится проброс еще одного порта или использование npx playwright show-trace с флагом хоста. 


###########=============from PLAYVIEW=============
```
root@d878c4a05d27:~# npx playwright install
npm warn exec The following package was not found and will be installed: playwright@1.59.1
╔═══════════════════════════════════════════════════════════════════════════════╗
║ WARNING: It looks like you are running 'npx playwright install' without first ║
║ installing your project's dependencies.                                       ║
║                                                                               ║
║ To avoid unexpected behavior, please install your dependencies first, and     ║
║ then run Playwright's install command:                                        ║
║                                                                               ║
║     npm install                                                               ║
║     npx playwright install                                                    ║
║                                                                               ║
║ If your project does not yet depend on Playwright, first install the          ║
║ applicable npm package (most commonly @playwright/test), and                  ║
║ then run Playwright's install command to download the browsers:               ║
║                                                                               ║
║     npm install @playwright/test                                              ║
║     npx playwright install                                                    ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```
Windows: Установите VcXsrv или Xming. Запустите VcXsrv с опцией Disable access control  
`npm init playwright@latest`


### USER WORKSPACE

Этап 3: Настройка рабочих мест разработчиков
Каждый разработчик на своем ноутбуке выполняет следующие действия:




Этап 5: Решение проблем (Troubleshooting)
Если окно браузера не появляется:
В VS Code на локальном компьютере проверьте вкладку Ports. Playwright использует динамические порты для трансляции интерфейса. Убедитесь, что VS Code не блокирует автоматический проброс портов (обычно это порты в диапазоне 8000–9000).
Если браузер «падает» с ошибкой:
Скорее всего, не хватает библиотек. Снова запустите на сервере:
sudo npx playwright install-deps

X410 - X Server for Windows Installer.exe

####playwright help==============
Inside that directory, you can run several commands:

  npx playwright test
    Runs the end-to-end tests.

  npx playwright test --ui
    Starts the interactive UI mode.

  npx playwright test --project=chromium
    Runs the tests only on Desktop Chrome.

  npx playwright test example
    Runs the tests in a specific file.

  npx playwright test --debug
    Runs the tests in debug mode.

  npx playwright codegen
    Auto generate tests with Codegen.

We suggest that you begin by typing:

    npx playwright test

And check out the following files:
  - ./e2e/example.spec.ts - Example end-to-end test
  - ./playwright.config.ts - Playwright Test configuration

Visit https://playwright.dev/docs/intro for more information.
