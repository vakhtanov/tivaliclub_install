# Установка NODE.JS

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



## 🚀 Следующий шаг
После установки Node.js вы можете вернуться в папку проекта и запустить команду инициализации Playwright:
```
npm init playwright@latest
```

# Установка Playwright

## 1. Создание проекта
Playwright не рекомендуется устанавливать глобально. Лучше инициализировать его в папке вашего проекта:

**КЛОНИРОВАТЬ  GIT - СТРУКТУРУ ПАПОК ДЛЯ ТЕСТИРОВАНИЯ TIVALI**

```
mkdir my-playwright-tests
cd my-playwright-tests
npm init playwright@latest
```
## 2. Настройка при установке
После запуска команды npm init консоль задаст несколько вопросов:

* TypeScript or JavaScript: Выберите нужный (по умолчанию TypeScript).
* Name of your tests folder: Оставьте tests.
* Add a GitHub Actions workflow: Нажмите y, если планируете запускать тесты в облаке.
* Install Playwright browsers: Нажмите y (это автоматически скачает браузеры Chromium, Firefox и WebKit).

------------------------------
## 3. Ручная установка браузеров
Если вы пропустили шаг с установкой браузеров или скачали проект из Git, выполните:

`npx playwright install`

------------------------------
## 4. Проверка работы
Чтобы убедиться, что всё встало ровно, запустите тестовый пример:

`npx playwright test`

По умолчанию тесты пройдут в фоновом режиме. Чтобы увидеть браузер, используйте флаг --headed:

`npx playwright test --headed`

## 🛠 Полезные дополнения

* VS Code Extension: Если вы пользуетесь VS Code, обязательно поставьте расширение Playwright Test. Оно позволяет запускать тесты нажатием одной кнопки рядом со строкой кода.
* Инспектор кода: Чтобы быстро сгенерировать тест, просто записывая свои действия в браузере, используйте:
`npx playwright codegen`

# Playwright в зависимости от ОС

Сама команда установки Playwright одинакова для всех систем, но процесс подготовки и системные зависимости различаются.
------------------------------
## 1. Универсальная часть (Node.js)
Команда инициализации проекта всегда одна и та же:
```
npm init playwright@latest
```
------------------------------
## 2. Различия в зависимостях

* Windows: Обычно всё работает «из коробки». Playwright сам скачивает нужные браузеры в папку %USERPROFILE%\AppData\Local\ms-playwright.
* Linux (Ubuntu/Debian): Браузерам часто не хватает системных библиотек (библиотеки отрисовки, шрифты). После установки проекта вам обязательно нужно запустить команду:
```
npx playwright install-deps
```
Без этого браузеры просто не запустятся в Linux.
* macOS: Как и в Windows, дополнительные зависимости обычно не требуются, если система обновлена.

------------------------------
## 3. Различия в браузере WebKit (Safari)

* Playwright позволяет тестировать Safari на Windows и Linux.
* Но: На Windows это будет «эмуляция» через сборку WebKit. На macOS это работает максимально близко к реальному Safari.

------------------------------
## 4. Headless-режим (CI/CD)

* На Linux-серверах (без графической оболочки) Playwright требует наличия Xvfb (виртуального дисплея). Но при использовании Docker или команды install-deps Playwright настраивает это сам.

------------------------------
## 📝 Резюме
Если вы ставите его на Windows, просто следуйте инструкции из предыдущего шага. Если ставите на Linux, не забудьте добавить команду для установки зависимостей:
```
   1. npm init playwright@latest
   2. npx playwright install
   3. npx playwright install-deps (только для Linux)
```


# Best practice

Для командной работы 2–3 человек важно сразу договориться о «правилах игры», чтобы тесты не превратились в хаос.
Вот базовая структура и рекомендации по организации процесса:
## 1. Структура проекта (Best Practices)
Используйте паттерн Page Object Model (POM). Это позволит не править каждый тест, если на сайте изменится кнопка.
```
my-playwright-project/
├── .github/workflows/      # Настройки CI/CD (автозапуск тестов)
├── tests/                  # Сами файлы тестов (e.g., login.spec.ts)
├── pages/                  # Page Objects (логика взаимодействия со страницами)
│   ├── login-page.ts
│   └── dashboard-page.ts
├── data/                   # Тестовые данные (JSON, константы)
├── utils/                  # Вспомогательные функции
├── playwright.config.ts    # Глобальные настройки (URL, таймауты, браузеры)
├── package.json            # Зависимости
└── .gitignore              # Игнорируем node_modules, отчеты и логи
```
------------------------------
## 2. Организация Git (Workflow)
Чтобы тестировщики не мешали друг другу:

* Main branch: Всегда стабильный код. Тесты в этой ветке должны проходить на 100%.
* Feature branches: Каждый тестировщик создает свою ветку для нового теста: git checkout -b feat/login-test.
* Pull Requests (PR): Перед слиянием в main другой тестировщик должен проверить код (Code Review).

------------------------------
## 3. Общие настройки в playwright.config.ts
Настройте один файл для всех, чтобы тесты работали одинаково на всех машинах:

* BaseURL: Укажите адрес сайта, чтобы в тестах писать await page.goto('/').
* Retries: Поставьте 2 попытки для нестабильных (flaky) тестов.
* Video/Screenshot: Настройте on-first-retry, чтобы видеть ошибку, если тест упал.

------------------------------
## 4. Секреты и окружения
Никогда не храните пароли в коде.

* Используйте файл .env для логинов/паролей.
* Добавьте .env в .gitignore.
* Создайте файл .env.example с пустыми значениями, чтобы коллеги знали, какие переменные им нужно прописать у себя.

------------------------------
## 5. Автозапуск (CI/CD)
Это самое важное для команды. Тесты должны запускаться сами при каждом обновлении кода в Git.

* Если используете GitHub, создайте файл .github/workflows/playwright.yml.
* Это позволит сразу видеть в Git, «сломал» ли кто-то проект своим новым кодом.

------------------------------
## 💡 Советы для старта:

   1. Линтеры: Установите ESLint и Prettier, чтобы код у всех выглядел одинаково.
   2. Общие аккаунты: Если сайт не дает работать под одним юзером в три потока, создайте каждому тестировщику свой набор данных (Data-Driven testing).
   3. Отчеты: Используйте встроенный html-report. Его удобно смотреть локально после прогона.

С какого сайта планируете начать автоматизацию? Могу набросать пример простого Page Object для старта.

# Одна репа для всех - готовая 

Для тестирования сайта tivaliclub.com (сообщество любителей языков) важно разделить логику элементов интерфейса и сами сценарии тестов.
Вот пример структуры и базового кода, чтобы ваша команда из 2-3 человек могла работать эффективно.
------------------------------
## 1. Настройка Page Object (Страница логики)
Создайте папку pages/ и файл main-page.ts. Здесь мы будем хранить только локаторы (кнопки, поля).
```
// pages/main-page.tsimport { type Locator, type Page } from '@playwright/test';
export class MainPage {
  readonly page: Page;
  readonly loginButton: Locator;
  readonly languageSelector: Locator;

  constructor(page: Page) {
    this.page = page;
    // Используем селекторы, которые легко читать
    this.loginButton = page.getByRole('button', { name: 'Войти' });
    this.languageSelector = page.locator('.language-picker'); 
  }

  async goto() {
    await this.page.goto('https://tivaliclub.com/ru');
  }
}
```
------------------------------
## 2. Написание теста
Теперь в папке tests/ создаем сам тест home.spec.ts. Он получается коротким и понятным.
```
// tests/home.spec.tsimport { test, expect } from '@playwright/test';import { MainPage } from '../pages/main-page';

test('Проверка главной страницы и наличия кнопки входа', async ({ page }) => {
  const mainPage = new MainPage(page);
  
  await mainPage.goto();
  
  // Проверяем заголовок (пример)
  await expect(page).toHaveTitle(/Tivali/);
  
  // Проверяем видимость кнопки входа
  await expect(mainPage.loginButton).toBeVisible();
});
```
------------------------------
## 3. Организация совместной работы (Git + CI)
Чтобы работа шла гладко, выполните эти шаги:

   1. Создайте .gitignore:
   Убедитесь, что в Git не попадают лишние файлы. В корне проекта выполните:
   npx playwright create-gitignore
   (Это скроет папки test-results/, playwright-report/ и node_modules/).
   2. Договоритесь о именовании веток:
   * feat/auth-tests — тесты авторизации.
      * fix/main-selectors — правка локаторов.
   3. Автоматизация (GitHub Actions):
   Если вы выложите код на GitHub, Playwright при инициализации предложит создать файл .github/workflows/playwright.yml. Обязательно соглашайтесь. Теперь при каждом git push тесты будут запускаться в облаке сами.

------------------------------
## 4. Полезные инструменты для команды

* Codegen: Если нужно быстро набросать тест, запустите в Cmder:
npx playwright codegen https://tivaliclub.com/ru
Он откроет браузер и будет записывать ваши клики, превращая их в код.
* Trace Viewer: Если тест упал у коллеги на Linux, а у вас на Windows всё ок — попросите его прислать файл trace.zip. Вы сможете пошагово «отмотать» тест и увидеть, что пошло не так.

------------------------------
## 🏁 С чего начать прямо сейчас?

   1. Один человек создает репозиторий и делает npm init playwright@latest.
   2. Пушит код в main.
   3. Остальные делают git clone и npm install.





# BEST PRACTICE REPO ========================

Для командной работы в Playwright лучше всего использовать структуру, которая отделяет логику страниц (локаторы) от сценариев (тестов). Это позволит вашим тестировщикам не конфликтовать при редактировании одних и тех же файлов.
## 📂 Рекомендуемая структура репозитория
```
tivali-tests/
├── .github/
│   └── workflows/
│       └── playwright.yml      # Автозапуск тестов при push в GitHub
├── pages/                      # Page Object Model (POM)
│   ├── base.page.ts            # Общие методы для всех страниц
│   ├── login.page.ts           # Страница входа
│   └── main.page.ts            # Главная страница
├── tests/                      # Сами тесты
│   ├── auth/                   # Тесты авторизации
│   │   └── login.spec.ts
│   └── smoke/                  # Быстрые тесты на проверку доступности
│       └── main.spec.ts
├── data/                       # Тестовые данные (пользователи, тексты)
│   └── users.json
├── playwright.config.ts        # Глобальные настройки Playwright
├── package.json                # Зависимости и скрипты запуска
├── .env.example                # Образец файла с паролями
└── .gitignore                  # Исключения для Git
```
------------------------------
## ⚙️ Код основных файлов настроек## 1. playwright.config.ts (Главный конфиг)
Этот файл определяет, как тесты будут бегать у всех участников команды.
```
import { defineConfig, devices } from '@playwright/test';
export default defineConfig({
  testDir: './tests',
  fullyParallel: true,                // Запуск тестов в несколько потоков
  forbidOnly: !!process.env.CI,       // Запрет .only в CI
  retries: process.env.CI ? 2 : 1,    // Перезапуск упавших тестов (2 раза в CI, 1 локально)
  workers: process.env.CI ? 1 : undefined,
  reporter: [['html'], ['list']],    // Отчеты в консоли и HTML

  use: {
    baseURL: 'https://tivaliclub.com', // Базовый URL, чтобы не дублировать в тестах
    trace: 'on-first-retry',          // Запись логов при первой неудаче
    screenshot: 'only-on-failure',    // Скриншот только при ошибке
    video: 'retain-on-failure',       // Видео только при ошибке
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
  ],
});
```
## 2. .gitignore
Чтобы не засорять репозиторий гигабайтами видео и скриншотов.
```
node_modules/
test-results/
playwright-report/
blob-report/
playwright/.cache/
.env
```
## 3. package.json (Скрипты для команды)
Добавьте в секцию scripts, чтобы всем было удобно запускать тесты одинаковыми командами.
```
"scripts": {
  "test": "npx playwright test",
  "test:ui": "npx playwright test --ui",
  "test:report": "npx playwright show-report",
  "codegen": "npx playwright codegen https://tivaliclub.com"
}
```
------------------------------
## 🤝 Как начать работу в команде

   1. Лид создает репозиторий, кладет туда эти файлы и делает git push.
   2. Тестировщики делают git clone.
   3. Каждый выполняет в Cmder: npm install и npx playwright install.
   4. Для новой задачи каждый создает свою ветку: git checkout -b task/login-scenarios.

Совет: Договоритесь использовать одинаковые расширения в VS Code (рекомендую официальное Playwright Test), чтобы у всех был одинаковый интерфейс запуска.
Нужно ли подготовить пример GitHub Actions файла, чтобы тесты сами запускались после каждого вашего коммита?


Ниже представлен код файла для GitHub Actions. Он позволит вашей команде автоматически прогонять тесты при каждом пуше в ветку main или создании Pull Request.
Создайте файл по пути: .github/workflows/playwright.yml
```
name: Playwright Testson:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - uses: actions/setup-node@v4
      with:
        node-version: lts/*

    - name: Install dependencies
      run: npm ci

    - name: Install Playwright Browsers
      run: npx playwright install --with-deps

    - name: Run Playwright tests
      run: npx playwright test

    - uses: actions/upload-artifact@v4
      if: always()
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30
```
## Что делает этот файл:

   1. Триггеры: Запускает тесты, как только кто-то из тестировщиков отправляет код в main или открывает PR.
   2. Среда: Использует свежую версию Ubuntu.
   3. Установка:
   * npm ci — чистая установка всех библиотек из вашего package.json.
      * install --with-deps — устанавливает браузеры и те самые системные библиотеки Linux, о которых мы говорили раньше.
   4. Отчеты: Если тесты упадут, GitHub сохранит папку playwright-report. Вы сможете скачать её из вкладки Actions, открыть и посмотреть видео или скриншот ошибки.

------------------------------
## 🚀 Финальный чек-лист для команды:

* Файл .env: Если у вас есть тесты с авторизацией, не забудьте прописать секреты в настройках репозитория GitHub (Settings > Secrets and variables > Actions), чтобы тесты в облаке могли «подхватить» логины и пароли.
* Статус: После пуша этого файла в репозиторий, рядом с вашими коммитами появится зеленая галочка (успех) или красный крестик (ошибка).






