import { Page } from '@playwright/test';

export class BasePage {
  readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Общий метод для перехода на любую страницу
  async navigate(path: string = '') {
    await this.page.goto(`/${path}`);
  }

  // Общий метод для проверки заголовка вкладки
  async getTitle() {
    return await this.page.title();
  }
}
