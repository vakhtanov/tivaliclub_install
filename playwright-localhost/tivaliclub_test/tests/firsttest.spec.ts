import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://tivaliclub.com/');
  await page.getByRole('button', { name: 'Start Learning' }).click();
  await page.getByRole('button').nth(2).click();
  await page.getByRole('button', { name: 'Start Learning' }).click();
  await page.getByRole('textbox').click();
  await page.getByRole('textbox').fill('wwww@mail.ru');
  await page.getByRole('button', { name: 'Register' }).click();
  await page.getByRole('button', { name: 'OK' }).click();
});