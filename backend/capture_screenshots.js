const puppeteer = require('puppeteer-core');
const path = require('path');
const fs = require('fs');

async function captureScreens() {
  const screenshotsDir = path.resolve(__dirname, '../screenshots');
  if (!fs.existsSync(screenshotsDir)) {
    fs.mkdirSync(screenshotsDir, { recursive: true });
  }

  const browser = await puppeteer.launch({
    executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: 'new',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-web-security',
      '--window-size=430,932'
    ]
  });

  const routes = [
    { url: 'http://127.0.0.1:8089/?screen=welcome', file: '01_welcome_screen.png', name: '01 Welcome & Value Proposition' },
    { url: 'http://127.0.0.1:8089/?screen=login', file: '02_login_screen.png', name: '02 User Login & Session' },
    { url: 'http://127.0.0.1:8089/?screen=signup', file: '03_signup_screen.png', name: '03 Account Registration' },
    { url: 'http://127.0.0.1:8089/?screen=home', file: '04_home_discovery.png', name: '04 Pet Discovery & Adoption Catalog' },
    { url: 'http://127.0.0.1:8089/?screen=pet_details&id=pet_bella_in_02', file: '05_pet_details_adoption.png', name: '05 Pet Bio & Adoption Modal (Bella)' },
    { url: 'http://127.0.0.1:8089/?screen=vaccines', file: '06_vaccination_tracker.png', name: '06 4-Metric Vaccination Dashboard' },
    { url: 'http://127.0.0.1:8089/?screen=vaccine_timeline&id=pet_bruno_in_03', file: '07_pet_vaccine_timeline.png', name: '07 Clinical Timeline & Countdown (Bruno)' },
    { url: 'http://127.0.0.1:8089/?screen=add_vaccine&id=pet_bruno_in_03', file: '08_add_vaccination_form.png', name: '08 Add Vaccine Record Form' },
    { url: 'http://127.0.0.1:8089/?screen=mypets', file: '09_my_pets.png', name: '09 My Adopted Pets' },
    { url: 'http://127.0.0.1:8089/?screen=shelter', file: '10_shelter_add_pet.png', name: '10 Shelter Rescue Intake Form' },
    { url: 'http://127.0.0.1:8089/?screen=reminders', file: '11_vaccine_reminders.png', name: '11 Clinical Reminders & Notifications' },
  ];

  for (const item of routes) {
    console.log(`Navigating to ${item.name} at ${item.url} ...`);
    const page = await browser.newPage();
    await page.setViewport({
      width: 414,
      height: 896,
      deviceScaleFactor: 2,
      isMobile: true,
      hasTouch: true
    });

    await page.goto(item.url, { waitUntil: 'networkidle0', timeout: 30000 });
    // Wait for Flutter Web canvas rendering and fonts
    await new Promise(r => setTimeout(r, 2000));

    const outPath = path.join(screenshotsDir, item.file);
    await page.screenshot({ path: outPath, fullPage: false });
    console.log(`✓ Saved ${item.file}`);
    await page.close();
  }

  await browser.close();
  console.log('🎉 All 11 screenshots successfully captured in /screenshots!');
}

captureScreens().catch(err => {
  console.error('Error capturing screenshots:', err);
  process.exit(1);
});
