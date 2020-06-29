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

describe("Page loads", function () {
  this.timeout(15000);
  let driver;

  before(function () {
    console.log("starting driver");
    let capabilities = {
      os: "Windows",
      os_version: "10",
      browserName: "IE",
      browser_version: "11",
      "browserstack.local": "true",
      "browserstack.console": "errors",

      name: "Example Local Mocha Test",
    };
    driver = new webdriver.Builder()
      .usingServer(browserstackURL)
      .withCapabilities(capabilities)
      .build();
  });

  it("should render h1", function (done) {
    const expected = "[Your Name]";

    let result;
    driver.get("http://127.0.0.1:3000").then(function () {
      driver
        .findElement(webdriver.By.css("h1"))
        .then(function (h1) {
          result = h1.getText();
          console.log(result);
        })
        .catch(function (err) {
          console.log(err);
        });
    });

    try {
      assert.equal(result, expected);
    } catch (err) {
      console.log(err);
    }
    done();
  });

  after(function () {
    driver.quit();
  });
});
