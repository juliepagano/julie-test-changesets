import { test, expect } from '@playwright/test';
import happoPlaywright from 'happo-playwright'

// Pick the new/fake "now" for you test pages.
const fakeNow = new Date("March 14 2042 13:37:11").valueOf();

test.beforeEach(async ({ context }) => {
  await happoPlaywright.init(context);
});

test.afterEach(async () => {
  await happoPlaywright.finish();
});

test('homepage has title', async ({ page }) => {
  // Update the Date accordingly in your test pages
  // From https://github.com/microsoft/playwright/issues/6347#issuecomment-1085850728
  await page.addInitScript(`{
    // Extend Date constructor to default to fakeNow
    Date = class extends Date {
      constructor(...args) {
        if (args.length === 0) {
          super(${fakeNow});
        } else {
          super(...args);
        }
      }
    }
    // Override Date.now() to start from fakeNow
    const __DateNowOffset = ${fakeNow} - Date.now();
    const __DateNow = Date.now;
    Date.now = () => __DateNow() + __DateNowOffset;
  }`);

  await page.goto('/');

  // await expect(page).toHaveScreenshot({
  //   mask: [page.locator('[data-maske2e]')]
  // })

  await happoPlaywright.screenshot(page, page.locator('body'), {
    component: 'Example Page',
    variant: 'default',
  });

  const heading = page.getByRole('heading', {
    level: 1
  })
  await expect(heading).toHaveText(/Hello Julie/)
});
