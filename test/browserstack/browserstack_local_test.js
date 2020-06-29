var webdriver = require("selenium-webdriver");
var assert = require("assert");

// Need to replace these credentials with env vars
var userName = "declanslevin1";
var accessKey = "UEZD7fj328mqvqX6xtxq";
var browserstackURL =
  "https://" +
  userName +
  ":" +
  accessKey +
  "@hub-cloud.browserstack.com/wd/hub";

var capabilities = {
  os: "Windows",
  os_version: "10",
  browserName: "IE",
  browser_version: "11",
  "browserstack.local": "true",

  name: "Example Local Test",
};

var driver = new webdriver.Builder()
  .usingServer(browserstackURL)
  .withCapabilities(capabilities)
  .build();

driver.get("http://127.0.0.1:3000").then(function () {
  driver.findElement(webdriver.By.css("h1")).then((h1) => {
    h1.getText()
      .then((text) => {
        console.log(text);
        assert.equal(text, "[Your Name]");
        driver.quit();
      })
      .catch((error) => {
        console.log(error);
        driver.quit();
      });
  });
});
