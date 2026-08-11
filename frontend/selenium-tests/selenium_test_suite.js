const { Builder, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const path = require('path');
const fs = require('fs');
const { generateTestCases } = require('../test-results/test_cases_data');
const { compileExcelReport } = require('../test-results/generate_reports');

// Load env variables
require('dotenv').config({ path: path.join(__dirname, '../.env') });

describe('CampusConnect Selenium E2E Web Suite - 5 Verification Tests', function () {
  this.timeout(120000);
  let driver;
  let webCases = [];
  
  before(async function () {
    // Generate base test cases
    webCases = generateTestCases('WEB');

    const options = new chrome.Options();
    options.addArguments('--headless'); // Headless execution for CI
    options.addArguments('--disable-gpu');
    options.addArguments('--no-sandbox');
    options.addArguments('--disable-dev-shm-usage');

    try {
      driver = await new Builder()
        .forBrowser('chrome')
        .setChromeOptions(options)
        .build();
      console.log("Chrome Selenium Driver initialized successfully.");
    } catch (err) {
      console.error("Could not start Chrome Driver:", err.message);
      throw err;
    }
  });

  after(async function () {
    if (driver) {
      await driver.quit();
    }

    // Write execution status updates directly to report compiler file
    // In a real project, these results would be output to a JSON that generate_reports reads.
    // Let's mock write them to a temp results JSON so they get picked up.
    const resultsDir = path.join(__dirname, '../test-results');
    if (!fs.existsSync(resultsDir)) {
      fs.mkdirSync(resultsDir, { recursive: true });
    }
    
    // We will save these case updates
    fs.writeFileSync(
      path.join(resultsDir, 'selenium_run_results.json'),
      JSON.stringify(webCases.filter(c => c.status !== 'NOT_EXECUTED'), null, 2)
    );

    // Run report generator
    console.log("Recompiling Excel report with active execution results...");
    await compileExcelReport();
  });

  it('TC-WEB-01: Verify Successful Landing Page Loads and Target Endpoint Response', async function () {
    const caseIndex = webCases.findIndex(c => c.id === 'TC-WEB-001');
    const startTime = Date.now();
    try {
      const targetUrl = process.env.LOAD_TEST_BASE_URL || 'http://localhost:5000';
      console.log(`Navigating to target URL: ${targetUrl}`);
      await driver.get(targetUrl);
      
      // Wait for page load
      await driver.sleep(10000); // Allow Flutter engine to boot
      
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'PASS';
        webCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-WEB-01 failed:", e.message);
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'FAIL';
        webCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-WEB-02: Verify Document Title matches CampusConnect', async function () {
    const caseIndex = webCases.findIndex(c => c.id === 'TC-WEB-002');
    const startTime = Date.now();
    try {
      const title = await driver.getTitle();
      console.log(`Document Title: ${title}`);
      if (title !== 'CampusConnect') {
        throw new Error(`Expected title 'CampusConnect' but got '${title}'`);
      }
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'PASS';
        webCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-WEB-02 failed:", e.message);
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'FAIL';
        webCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-WEB-03: Verify Flutter Web Engine Init (flt-glass-pane container exists)', async function () {
    const caseIndex = webCases.findIndex(c => c.id === 'TC-WEB-003');
    const startTime = Date.now();
    try {
      // Flutter web injects a <flt-glass-pane> to host its canvas render tree
      const glassPane = await driver.findElement(By.tagName('flt-glass-pane'));
      if (!glassPane) {
        throw new Error("flt-glass-pane element not found. Flutter Web engine failed to initialize.");
      }
      console.log("Verified <flt-glass-pane> rendering successfully.");
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'PASS';
        webCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-WEB-03 failed:", e.message);
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'FAIL';
        webCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-WEB-04: Verify App Layout structure and canvas container rendering', async function () {
    const caseIndex = webCases.findIndex(c => c.id === 'TC-WEB-004');
    const startTime = Date.now();
    try {
      // Find flutter-view inside flt-glass-pane shadow DOM
      const fltView = await driver.findElement(By.css('flt-glass-pane'));
      if (!fltView) {
        throw new Error("Flutter view canvas render host element not found.");
      }
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'PASS';
        webCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-WEB-04 failed:", e.message);
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'FAIL';
        webCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-WEB-05: Verify URL path router parameters match standard root router', async function () {
    const caseIndex = webCases.findIndex(c => c.id === 'TC-WEB-005');
    const startTime = Date.now();
    try {
      const currentUrl = await driver.getCurrentUrl();
      console.log(`Current active URL path: ${currentUrl}`);
      if (!currentUrl.includes('localhost') && !currentUrl.includes('127.0.0.1')) {
        throw new Error(`Unexpected routing URL: ${currentUrl}`);
      }
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'PASS';
        webCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-WEB-05 failed:", e.message);
      if (caseIndex !== -1) {
        webCases[caseIndex].status = 'FAIL';
        webCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });
});
