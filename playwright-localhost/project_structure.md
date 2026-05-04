# Организация проекта 

## Структура репозитория

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

## Файлы настройки

### playwright.config.ts - общие настройки тестов
* BaseURL: Укажите адрес сайта, чтобы в тестах писать await page.goto('/').
* Retries: Поставьте 2 попытки для нестабильных (flaky) тестов.
* Video/Screenshot: Настройте on-first-retry, чтобы видеть ошибку, если тест упал.

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

### package.json (Скрипты для команды)
Cекция scripts, чтобы всем было удобно запускать тесты одинаковыми командами.
```
"scripts": {
  "test": "npx playwright test",
  "test:ui": "npx playwright test --ui",
  "test:report": "npx playwright show-report",
  "codegen": "npx playwright codegen https://tivaliclub.com"
}
```

### Настройка Page Object (Страница логики) в папке pages/ 
Например создадим ф файл main-page.ts, здесь мы будем хранить только локаторы (кнопки, поля).
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


### Создание теста в папке tests/ 
Например создаем  тест home.spec.ts, который ссылается на локаторы.
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

### .gitignore
Чтобы не засорять репозиторий гигабайтами видео и скриншотов.
```
node_modules/
test-results/
playwright-report/
blob-report/
playwright/.cache/
.env
```



# GitHub Actions


автоматически прогонять тесты при каждом пуше в ветку main или создании Pull Request.

 .github/workflows/playwright.yml
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
## 🚀 Финальный чек-лист :

* Файл .env: Если у вас есть тесты с авторизацией, не забудьте прописать секреты в настройках репозитория GitHub (Settings > Secrets and variables > Actions), чтобы тесты в облаке могли «подхватить» логины и пароли.
* Статус: После пуша этого файла в репозиторий, рядом с вашими коммитами появится зеленая галочка (успех) или красный крестик (ошибка).