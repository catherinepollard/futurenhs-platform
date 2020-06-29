# Automated Testing

## Local Server Testing

These example tests are designed to run off a local server.

[Local API server instructions](../hello-world/README.md)

[Local frontend instructions](../frontend)

Before executing the Cypress or Browserstack tests you will need to have the local frontend server running (the API server is only necessary for the hello_world_rust.js Cypress test at this point).

## Cypress

To run Cypress, cd into the cypress folder and execute `npm run cypress open`.

This will open the test runner. You can then select a test you want to run and which browser you would like to run it in.

## Browserstack

### Selenium

To run the Selenium test on Browserstack, you first need to launch the Browserstack Local executable.
From the command line, cd into the browserstack folder and execute `./BrowserStackLocal --key {accesskey}`\*

\* Replace {accesskey} with your access key, which can be found by going to the [BrowserStack Automate Dashboard](https://automate.browserstack.com/dashboard/v2/) and clicking on the ACCESS KEY dropdown.

Then (in a separate window) execute `node browserstack_local_test.js`.

### Mocha

To run the Mocha test on Browserstack, launch the Browserstack Local executable (see above).

From the /browserstack/ folder execute `mocha browserstack_local_test_mocha.js`.

You can see the result of the test in the command line and [BrowserStack Automate Dashboard](https://automate.browserstack.com/dashboard/v2/).
