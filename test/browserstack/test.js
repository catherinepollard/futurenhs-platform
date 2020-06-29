var BrowserStack = require("browserstack");
var assert = require("assert");

var browserStackCredentials = {
  username: "declanslevin1",
  password: "UEZD7fj328mqvqX6xtxq",
};

// var client = BrowserStack.createClient(browserStackCredentials);

// client.getBrowsers(function(error, browsers) {
//     console.log("The following browsers are available for testing");
//     console.log(browsers);
// });

var automateClient = BrowserStack.createAutomateClient(browserStackCredentials);

automateClient.getBrowsers(function (error, browsers) {
  console.log("The following browsers are available for testing");
  console.log(browsers);
});

describe("Array", function () {
  describe("#indexOf()", function () {
    it("should return -1 when the value is not present", function () {
      assert.equal([1, 2, 3].indexOf(4), -1);
    });
  });
});
