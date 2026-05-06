import { test, expect } from '@playwright/test';
import { MainPage } from '../../pages/main.page';

test.describe('Главная страница', () => {
  
  test('Проверка кнопки "Начать учиться"', async ({ page }) => {
    const mainPage = new MainPage(page);

    // 1. Переходим на сайт
    await mainPage.navigate(); 

    // 2. Проверяем, что кнопка видна пользователю
    await expect(mainPage.startLearningButton).toBeVisible();

    // 3. Кликаем по кнопке
    await mainPage.clickStartLearning();

    // 4. (Опционально) Проверяем результат, например, появление формы или переход по URL
    // await expect(page).toHaveURL(/.*register/); 
  });

});
