import { test, expect } from '@playwright/test';

test('homepage has title', async ({ page }) => {
  await page.goto('http://host.docker.internal:3000');

  await expect(page).toHaveScreenshot({
    mask: [page.locator('p')]
  })

  const heading = page.getByRole('heading', {
    level: 1
  })
  await expect(heading).toHaveText(/Hello Julie/)
});
