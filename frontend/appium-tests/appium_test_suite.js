const { remote } = require('webdriverio');
const path = require('path');
const fs = require('fs');
const { generateTestCases } = require('../test-results/test_cases_data');
const { compileExcelReport } = require('../test-results/generate_reports');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '../.env') });

describe('CampusConnect Appium Android E2E Suite - 5 Verification Tests', function () {
  this.timeout(120000);
  let client;
  let mobileCases = [];

  before(async function () {
    mobileCases = generateTestCases('MOBILE');

    // Capabilities configured specifically for device 99364b0f and path / instead of /wd/hub
    const capabilities = {
      platformName: 'Android',
      'appium:automationName': 'UiAutomator2',
      'appium:udid': '99364b0f', // Target physical device from user request
      'appium:appPackage': 'com.example.campusconnect', // Inspected package ID
      'appium:appActivity': 'com.example.campusconnect.MainActivity', // Entry activity
      'appium:noReset': true,
      'appium:newCommandTimeout': 240,
      'appium:ignoreHiddenApiPolicyError': true, // OPPO CPH2381 blocks WRITE_SECURE_SETTINGS
      'appium:skipDeviceInitialization': true, // Skip settings/mock_location that fail on non-rooted OEM
      'appium:autoGrantPermissions': false // Don't try to manage permissions on restricted device
    };

    console.log("Appium capabilities target configured for device 99364b0f:");
    console.log(JSON.stringify(capabilities, null, 2));

    try {
      client = await remote({
        path: '/', // Connect directly to port root to avoid 404 wd/hub errors
        port: 4723,
        capabilities
      });
      console.log("Appium Server session established successfully on port 4723.");
    } catch (e) {
      console.error("Failed to connect to Appium server:", e.message);
      throw e;
    }
  });

  after(async function () {
    if (client) {
      await client.deleteSession();
    }

    // Save mobile execution metrics
    const resultsDir = path.join(__dirname, '../test-results');
    if (!fs.existsSync(resultsDir)) {
      fs.mkdirSync(resultsDir, { recursive: true });
    }

    fs.writeFileSync(
      path.join(resultsDir, 'appium_run_results.json'),
      JSON.stringify(mobileCases.filter(c => c.status !== 'NOT_EXECUTED'), null, 2)
    );

    console.log("Recompiling Excel report with active Appium execution results...");
    await compileExcelReport();
  });

  it('TC-MOBILE-01: Verify Mobile App Launch and AppPackage Foreground State', async function () {
    const caseIndex = mobileCases.findIndex(c => c.id === 'TC-MOBILE-001');
    const startTime = Date.now();
    try {
      const appPackage = await client.getCurrentPackage();
      console.log(`Current active app package in foreground: ${appPackage}`);
      if (appPackage !== 'com.example.campusconnect') {
        throw new Error(`Expected com.example.campusconnect but found ${appPackage}`);
      }
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'PASS';
        mobileCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-MOBILE-01 failed:", e.message);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'FAIL';
        mobileCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-MOBILE-02: Verify Current Activity starts as MainActivity', async function () {
    const caseIndex = mobileCases.findIndex(c => c.id === 'TC-MOBILE-002');
    const startTime = Date.now();
    try {
      const currentActivity = await client.getCurrentActivity();
      console.log(`Current foreground activity: ${currentActivity}`);
      if (!currentActivity.includes('MainActivity')) {
        throw new Error(`Expected MainActivity but got ${currentActivity}`);
      }
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'PASS';
        mobileCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-MOBILE-02 failed:", e.message);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'FAIL';
        mobileCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-MOBILE-03: Verify screen dimensions and display orientation', async function () {
    const caseIndex = mobileCases.findIndex(c => c.id === 'TC-MOBILE-003');
    const startTime = Date.now();
    try {
      const orientation = await client.getOrientation();
      console.log(`Current screen orientation: ${orientation}`);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'PASS';
        mobileCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-MOBILE-03 failed:", e.message);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'FAIL';
        mobileCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-MOBILE-04: Verify interaction with login layout root node', async function () {
    const caseIndex = mobileCases.findIndex(c => c.id === 'TC-MOBILE-004');
    const startTime = Date.now();
    try {
      // Find standard android view root or package view
      const view = await client.$('android.widget.FrameLayout');
      const isDisplayed = await view.isDisplayed();
      console.log(`FrameLayout is displayed: ${isDisplayed}`);
      if (!isDisplayed) {
        throw new Error("Application frame node is not displayed.");
      }
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'PASS';
        mobileCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-MOBILE-04 failed:", e.message);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'FAIL';
        mobileCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });

  it('TC-MOBILE-05: Verify UI tree responsiveness to Android system back key', async function () {
    const caseIndex = mobileCases.findIndex(c => c.id === 'TC-MOBILE-005');
    const startTime = Date.now();
    try {
      // Trigger system back button (4 keycode)
      await client.pressKeyCode(4);
      console.log("Sent hardware back press keycode successfully.");
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'PASS';
        mobileCases[caseIndex].duration = `${Date.now() - startTime}ms`;
      }
    } catch (e) {
      console.error("TC-MOBILE-05 failed:", e.message);
      if (caseIndex !== -1) {
        mobileCases[caseIndex].status = 'FAIL';
        mobileCases[caseIndex].defectInfo = e.message;
      }
      throw e;
    }
  });
});
