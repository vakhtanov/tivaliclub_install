# Инструкция для установки и настройки стека NODE.JS, PLAYWRIGHT, VSCODE для тестирвоания web приложений

Описана установка для Desktop версий ОС.


# Порядок установки и начала работы

0. Прочитать принципы совместной работы
1. Установить Node.JS
2. Клонировать структуру проекта для тестирвоания из репозитория - папки и настройки 
3. Инициализировать PlayWright в папке проекта
4. Проверить работу
5. Установить VSCode и расширение Playwright
6. Изучить структуру репозитория - файл [project_structure.md](./project_structure.md)

# Требование к версии ОС

* Windows 10-11+, Windows Server 2019+ or Windows Subsystem for Linux (WSL).
* macOS 14 (Ventura) or later.
* Debian 12 / 13, Ubuntu 22.04 / 24.04 (x86-64 or arm64).

# Принципы совместной работы по тестированию

 - все используют готовый репозиторий для создания тестов. В репозитории хранятся тесты, настройки проекта и дополнительные файлы
 - перед началом работы нужно клонировать репозиторий (git clone)
 - PlayWright устанавливается локально в папку проекта (npm install и npx playwright install)
 - В ветке main репозитория - стабильный код тестов - проходят на 100%
 - Для новой задачи новая ветка в git (например git checkout -b feat/login-test)
 - Ветки именуются по стандарту (например * feat/auth-tests — тесты авторизации. * fix/main-selectors — правка локаторов.)
 - слияние в main через  Pull Requests (PR)
 - для VSCode используются одинаковые расширения - официальный Playwright Test
 - Для визуальной генерации тестов можно использовать CodeGen (npx playwright codegen https://tivaliclub.com/ru)
 - Для отладки можно использовать Trace Viewer (в файл trace.zip - записаны шаги теста)
 - Для оформления кода используются линтеры, допустим Prettier для форматирования и  ESLint - анализатор кода. Устанавливаются через npm
 - Используется паттерн Page Object Model (POM) - для меньшей зависимости тестов от изменения названия кнопок и других
 - Настройки playwright.config.ts - для всех общие
 - Для хранения паролей и кредов используется .env файл, в репозиторй не пушистя (.gitignore). В репозитории .env.example - для примера
 - В проекте формируется gitignore командой `npx playwright create-gitignore` - исключает папки `test-results/, playwright-report/ и node_modules/`

**Page Object Model (POM) —  популярный паттерн проектирования в автоматизации тестирования.**
Кратко и грубо - код тестов состоит из локаторов элементов страниц и собственно тестов (сценариев), которые описыватю действия с локаторами.


# 1. Установка NODE.JS

У вас уже установлен Node.js (проверить можно командой node -v)?

Будем использовать самые простые способы установки с официального сайта:

[https://nodejs.org/en/download](https://nodejs.org/en/download)

**Ставим стабильную версию с долгой поддержкой v24.15.0 для архитектуры х64**

------------------------------
## 🪟 Windows 

   1. Скачайте установщик:
    [https://nodejs.org/dist/v24.15.0/node-v24.15.0-x64.msi](https://nodejs.org/dist/v24.15.0/node-v24.15.0-x64.msi) 
   2. Установите:
   Запустите .msi и следуйте инструкциям.

   4.  Открывам коммандную сроку (или PowerShell - може не работать npm) и проверяем:
   
   ```
   node -v #v24.15.0
   npm -v #11.12.1
   ```
   
------------------------------
## 🐧 Linux (через nvm (Node Version Manager))

   1. Запустите скрипт установки в терминале выполните команду:
   ```
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
   ```
   2. Обновите окружение:
   Чтобы терминал "увидел" nvm, выполните:
   ```
   \. "$HOME/.nvm/nvm.sh"
   ```

   3. Установите Node.js:
   ```
   nvm install 24
   ```
   4. Проверьте:
   ```
   node -v # Should print "v24.15.0".
   npm -v # Should print "11.12.1".
   ```
   
------------------------------

# 2. Установка GIT

Установим систему контроля версий Git

На Linux возможно уже устанвлено

На windows - установщик на сайте [https://git-scm.com/install/](https://git-scm.com/install/)

[Standalon Win64](https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/Git-2.54.0-64-bit.exe)


# 2. Клонируем репозиторий с шаблоном для создания тестов

Для каждого сайта создается отдельынй шаблон с общими настройками для тестирвоания (ссылками, плагинами и т.д)

Для доступа к репозиторию возможно нужно будет добавить на сайт публичную часть своего ssh ключа

## Клонирование репозитория целиком (одельный репозиторий для тестов)
`git clone https://github.com/[REPO address]`

Создать новую ветку и переключиться в нее  
`git switch -c [BRANCH]`

Переключиться в существующую ветку  
`git switch [BRANCH]`

Коммит изменений и отправка в репозиторий
```
 git add .
 git commit -am "[COMMENT]"
 git push -u origin [BRANCH] - первый раз если ветки нет в репозитории
 git push -u origin [BRANCH] - следующие разы
```

## Клонирвоание папки для тестов из общего репозитория (например DevOps)

```
Создаем папку для работы и заходим в нее
git clone --filter=blob:none --no-checkout [URL_РЕПОЗИТОРИЯ] .
git sparse-checkout set [FOLDER] 
git checkout main
```

Создать новую ветку и переключиться в нее  
`git switch -c [BRANCH]`

Переключиться в существующую ветку  
`git switch [BRANCH]`

Коммит изменений и отправка в репозиторий
```
 git add .
 git commit -am "[COMMENT]"
 git push -u origin [BRANCH] - первый раз если ветки нет в репозитории
 git push -u origin [BRANCH] - следующие разы
```

Файл **.env_example** переименуй в **.env** и пропиши свои креды для доступа

# 3. Устанавливаем PLAYWRIGHT Если скачен репозиторий.

Переходим в папку проекта, выполняем комманды:  
 `npm install` - скачивает библиотеки согласно `package.json`  
 `npx playwright install` - установка браузеров   
 `npx playwright install-deps` (только для Linux) - установка дополнение к браузерам - шрифты и т.д.  
   
 Различия в браузере WebKit (Safari)  
* Playwright позволяет тестировать Safari на Windows и Linux.  
* Но: На Windows это будет «эмуляция» через сборку WebKit. На macOS это работает максимально близко к реальному Safari.  


# 4. Основные команды PLAYWRIGHT

Чтобы убедиться, что всё встало ровно, запустите тестовый пример:

  `npx playwright test`  
    Runs the end-to-end tests.  

По умолчанию тесты пройдут в фоновом режиме. Чтобы увидеть браузер, используйте флаг --headed:

   `npx playwright test --headed`

  `npx playwright test --ui`  
    Starts the interactive UI mode.

  `npx playwright test --project=chromium`  
    Runs the tests only on Desktop Chrome.

  `npx playwright test example`
    Runs the tests in a specific file.

  `npx playwright test --debug`  
    Runs the tests in debug mode.

  `npx playwright codegen`  
    Auto generate tests with Codegen.


And check out the following files:  
  - .\tests\example.spec.ts - Example end-to-end test  
  - .\playwright.config.ts - Playwright Test configuration  

Visit https://playwright.dev/docs/intro for more information. ✨


# 5. Установка VsCode

Устанавливаем ПО  
[https://code.visualstudio.com/download](https://code.visualstudio.com/download)  
[windows](https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user)  
[linux deb](https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64)  

Открываем VSCode

Переходим в папку проекта

* VS Code Extension: Если вы пользуетесь VS Code, обязательно поставьте расширение Playwright Test. Оно позволяет запускать тесты нажатием одной кнопки рядом со строкой кода.


# Чистая установка PLAYWRIGHT (Используется TeamLead один раз для создания проекта)
            `npm init playwright@latest` - инизиализация нового проекта ( для GIT не нужно )  
            * TypeScript or JavaScript: Выберите нужный (по умолчанию TypeScript).  
            * Name of your tests folder: Оставьте tests.  
            * Add a GitHub Actions workflow: Нажмите y, если планируете запускать тесты в облаке.  
            * Install Playwright browsers: Нажмите y (это автоматически скачает браузеры Chromium, Firefox и WebKit).  

            * Windows: Обычно всё работает «из коробки». Playwright сам скачивает нужные браузеры в папку %USERPROFILE%\AppData\Local\ms-playwright.  
            * Linux (Ubuntu/Debian): Браузерам часто не хватает системных библиотек (библиотеки отрисовки, шрифты). После установки проекта вам обязательно нужно запустить команду:  
            ```
            npx playwright install-deps
            ```
            Без этого браузеры просто не запустятся в Linux.  
            * macOS: Как и в Windows, дополнительные зависимости обычно не требуются, если система обновлена.  

            Если вы пропустили шаг с установкой браузеров или скачали проект из Git, выполните:  
             `npx playwright install` - установка браузеров  
             `npx playwright install-deps` (только для Linux) - установка дополнение к браузерам - шрифты и т.д.  
             
             Установка пакета для использования файла .env  
             `npm install dotenv --save-dev`
             
             Использование .env в коде  
             в конфиге:  
             ```
             ссылка на переменную - process.env.BASE_URL
             use: {
               baseURL: process.env.BASE_URL,
             },
             ```
             
             В коде теста:  
             
             ```
             ссылка на переменную - process.env.USER_LOGIN!
             
             await page.fill('#login', process.env.USER_LOGIN!);
             ```
             
# Обновление PlayWrigth

В папке проекта:

```
npm install -D @playwright/test@latest
npx playwright install --with-deps
```

Проверка версии

```
npx playwright --version
```
