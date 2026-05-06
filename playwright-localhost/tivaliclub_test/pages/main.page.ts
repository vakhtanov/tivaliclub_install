import { Locator, Page } from '@playwright/test';
import { BasePage } from './base.page';

export class MainPage extends BasePage {
  // Объявляем локатор
  readonly startLearningButton: Locator;

  constructor(page: Page) {
    super(page); // вызываем конструктор BasePage
    // Инициализируем локатор через getByRole
    this.startLearningButton = page.getByRole('button', { name: 'Start Learning' });
  }

 // Метод для открытия именно ГЛАВНОЙ страницы
  async openMain() { 
    await this.navigate('/'); // Playwright подставит baseURL из конфига 
  }

  // Метод для клика
  async clickStartLearning() {
    await this.startLearningButton.click();
  }
}
