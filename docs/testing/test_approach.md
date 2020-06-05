# FutureNHS Test Approach

At Red Badger, we utilise Agile methodologies to release with regularity and predictability. Cross-functional teams are equipped with resources from all disciplines; Development, Test, User Experience, Design and Insights who collaborate to deliver to a consistently high quality.
Through a combination of automated tests and effective manual testing, our emphasis is on early defect detection. We aim to prioritise and address defects as early as possible in the development cycle. 

We aim to deliver a high quality platform and migrate users in the shortest time possible. To enable this we are proposing to pursue testing strategies that will enable quick delivery, without sacrificing quality. Through test-driven development (TTD), incorporating comprehensive automation testing and targeted, effective manual testing locally and in Production, we are confident that we can minimise the number of issues that users will encounter. 

## Proposed Testing Flow

In the spirit of pursuing high-quality quick delivery, we are proposing the following process for each ticket:
1. Create a feature flag (if new feature).
2. Write TTD Unit/Integration tests.
3. Build the feature locally.
4. Get the TTD tests passing.
5. Add Snapshot and E2E tests (if relevant).
6. Create a Pull Request and get code reviewed.
7. QA performs exploratory manual testing locally.
8. Any blocker issues discovered are fixed immediately. Minor issues are logged and prioritised in the backlog. 
9. When happy that acceptance criteria are met and there are no blocker issues, QA merges to master.
10. Test suite runs and passes on master.
11. Code deploys to Production as canary deployment/behind a feature flag.
12. QA verifies the code in Production.
13. Feature flag is toggled to allow access to a beta group (stakeholders, beta testers).
14. Once all parties are satisfied with a feature’s completed status, the feature flag is toggled to allow wider user groups to interact with the feature. This process can be segmented gradually i.e. allowing 5% of users see the feature, then 10%, 20%, etc. 
15. Once all users have been given access to the feature for a period of time, the feature flag is removed. 

### Continuous Integration Testing
Unit, Integration and Snapshot tests will be written and run each time before code is committed/merged/deployed, to act as a safety net to prevent feature regressions and help to reduce the number of bugs that make it into Production. 
In addition to these standard tests an end-to-end testing suite will be developed, which will test all parts of the system in conjunction with each other. They will focus on ‘happy paths’ - common user journeys that are essential for the platform to operate effectively. 

## Test Environments
### Local Environment
The earliest possible stage to test code is in a local environment. This would entail the QA checking out code from the GitHub repository to their laptop. They would then compile and run the platform locally and perform manual exploratory testing. 

By testing locally we save time by not having to spin up a branch environment or rebuild any time a minor change to the code is made. 

A snapshot of anonymised Production data will be spun up in a local database when testing locally. This will give us the best possible data to work with.

### Branch Environments
Occasionally we may want to spin up a branch environment for tickets that cannot be tested effectively in a local environment, e.g. if we need to test major infrastructure changes. 

Again these would use a snapshot of anonymised Production data to facilitate testing. There is also potential to have live anonymised Production data available but this requires further investigation. 

### Test Data
As mentioned above, to provide data used in the local branch environments we propose using actual Production data wherever possible. Obviously this presents issues surrounding privacy. To resolve this we propose anonymising everything at the point of snapshotting the Production data. This would entail stripping out any identifying information that could link data back to the person it was posted by or about. 

## Feature Flags and Staging
We are proposing to forgo testing in a Staging environment before deploying code to Production. To achieve this we use “feature flags” - switches that allow you to toggle isolated code or features in Production. This allows us to deploy code directly from master to Production behind a feature flag that prevents users from seeing the new code until it has been thoroughly verified that it is safe to make available. 

### Staging Environments
Staging environments were introduced to solve a specific problem in waterfall development - checking code directly into Production would often cause something to break, with this likelihood rising exponentially the more developers you have. Staging environments that mimic Production as closely as possible were introduced as an extra layer of insulation to help prevent this. Builds are tested in this environment, where hopefully any major issues can be discovered and addressed before deploying to Production. 

Staging environments can be quite useful if you have multiple teams in an organisation committing code independently of each other. They also give you a higher degree of certainty that code is safe to deploy.

However, there are some downsides to having a staging environment. 

Staging environments can get out of sync with Production quite easily, and there is an overhead involved with maintaining them so that they stay up-to-date. There is also the monetary cost of permanently hosting an extra set of servers that mirror Production. 

While they are designed to mirror Production, they rarely use actual Production data. Therefore the staging test data is never going to be as good as a live environment. It can never match the scale and diversity of real data. Bugs found in Production might not be reproducible in staging because the same data is not available. The flipside is that something fixed in staging may not actually fix the issue in Production because the environments and data may differ in crucial ways. 

Getting new features and urgent bug-fixes to Production is slowed down by having a staging environment. Having an extra step of testing in the way is once again another overhead in both time and money. Having to rebuild a feature build for staging and having a QA repeat testing can take a significant amount of time. 

To summarise:

Pros
- Can provide a higher degree of certainty that code is safe to deploy
- Useful when you have multiple teams in an organisation committing code independently

Cons
- Staging environments were introduced when applications where ‘shipped’ and Production data was not accessible
- Incurs extra cost for maintaining environment, both in work hours and hosting fees
- Staging data will never be as good as Production
- Staging can never match the scale of Production
- An extra step of repeated testing (monotonous for the tester 🙃)
- Slows down pushing urgent fixes to Production

### Feature Flagging
Feature flags are essentially on/off switches that allow you to toggle code availability within an application. This means we would have the ability to deploy code to Production without a user seeing it because it has been disabled for them by a feature flag. 
User roles can be assigned to Feature flags so developers/QA can test newly-deployed code in Production whilst the wider user base are unable to see it. This will allow us to test with real data and infrastructure, giving us a high degree of confidence that enabling the feature is unlikely to introduce any bugs.  
Many well known brands utilise feature flagging, such as Google, Facebook, Netflix, Amazon, etc.  

### Benefits
There are many benefits to using feature flags beyond allowing testing in Production. 

#### Beta Testing
With a beta feature flag it will be incredibly easy to make new features available to a select group of beta testers on the platform, without exposing them to the wider user base. There will be no need for a separate beta platform or logins for the beta users. 

#### Code Rollback
It is extremely quick to rollback a feature flagged release - simply toggle it off. It is inevitable that some bugs will make it into Production and should a serious bug go live, having feature flags in place will allow a rapid response. The breaking code can be temporarily toggled off while a fix is deployed, minimising any downtime for Production as a whole. 
Without feature flags it would be necessary to redeploy Production with the offending code rolled-back, which can be a time consuming process. 

#### A/B Testing
Having feature flagging in place also provides the ability to perform A/B testing. This allows for splitting the user base and testing different prototypes of a feature. The results can be compared and provide insight for the future development of said feature. Assumptions made in the design process can be validated and modified accordingly with real-time feedback from users actually interacting with the feature. If it is not being engaged with you can make an informed decision on whether to cease working on it and prioritise other features for development. 

#### Canary Deployments
Similar to A/B testing, a canary deployment is where you expose a new feature to a small number of users, say 5%, to get some initial feedback on the feature’s stability, uptake and efficacy. Combined with effective monitoring and analytics, this is a powerful tool for verifying prototypes and feature design, ensuring that by the time the feature goes fully live it has been tested thoroughly. 
A canary deployment can be performed either with a feature flag or by creating a second Production environment and diverting users to the new environment. If an issue should arise in the new deployment, it is easy to stop the diversion and continue sending users to the original environment.

#### Workspace Segmentation & User Engagement
Feature flags can be assigned to specific workspaces. This opens up the possibility of identifying workspaces where there is high user engagement or where new features/widgets are taken up quickly by users and targeting them for testing. 

### Infrastructure Changes
When it comes to making big infrastructure changes it is likely that we would opt to spin up a new environment entirely to deploy to rather than going straight into Production with a feature flag. This would mitigate the risk that the infrastructure changes might cause catastrophic failures in the live Production environment. 
Once thoroughly tested in a temporary ‘staging’ environment the changes would be rolled out to Production.

### Performance Testing
To avoid negatively affecting Production performance it would be wise to test performance/load testing in a separate temporary environment that mirrors Production. We can use a framework such as Gatling in conjunction with Postman to perform load testing to stress the platform and measure performance. It would useful to establish a baseline for future comparison.

## Levels of Testing
### The Testing Pyramid
Popularised by Mike Cohn, the idea of the Test Pyramid is fundamental to our approach to testing within Red Badger. Through previous experience and research, we have come to believe that the principles behind this model are of vital importance for a successful delivery built upon a solid foundation of quality assurance. As automation plays an increasingly important role in enabling continuous integration and delivery, it is vital that this area is given the highest attention.

### Unit Tests
These test the individual logic of a particular function or component in the application, isolated from the other components. The most important things to test at this level are conditional logic, looping and any kind of data manipulation (e.g., sorting of a list). 
Unit tests are fast to run and independent of each other. When utilised with a focus on test-driven development (TDD) they act as documentation for a feature. They should be executed as often and early as possible to provide early feedback on code functionality and quality. 
Unit tests are predominantly the concern of the developer working on a feature, but the tester will take an active role in writing tests and ensuring all scenarios are covered. 

### Integration Tests
These tests ensure that the interaction between functions and components are working together to create the intended result. For example, in the React ecosystem, an appropriate level in a component tree (this might be an entire page) is rendered and populated with input data. Click events are simulated on the UI to make sure that the full logical application flow works as expected. 
API tests also fall under this bracket. With these, a tester can verify that the back-end of the application is in a working state, without going through the additional layer of complexity interacting with a browser.

### End-to-End Tests
End-to-end (aka E2E or UI) testing generally mimics as closely as possible user interaction with the application. A browser, driven by software, simulates the user's journey through the web application. These are the most time consuming and therefore expensive tests in the suite.  
We will also have End-to-end API tests that run solely on the API layer in combination with mocking/stubbing of data/responses to simulate a user’s interaction with the system. These will execute more quickly without the overhead of a browser rendering pages and interactions. 

### Snapshot Testing
Snapshot comparison testing checks for styling regressions as new features are added to the application. The rendering of a component is compared with its previous incarnation and flagged up if a change is detected. These tests supplement more expensive UI tests by ensuring there are no regressions to individual components throughout the application, build after build.

### Manual Testing
Manual testing is often deemed an expensive overhead, however, it provides value by testing scenarios that may not have been caught by other testing methods.
A manual tester has the ability to view the site in the context of requirements, find errors and ignore false negatives far easier and faster than any automated test or screenshot comparison tool. 
Manual testers understand the original story requirement and therefore are essential for confirming that a built feature actually solves the original problem defined by a story. They can also find edge cases in the application that may only be found during real browser testing, as opposed to rigid automated tests.
If any regressions are found by manual testing, the fix should come with an automated test at the lowest sensible level in the triangle.
In general, manual tests: 
- Focus on testing features, rather than finding regressions.
- Can be scripted or exploratory in nature.
- Try and find as many bugs and regressions as possible in the previous steps.
- Allow manual testers' pattern recognition ability to quickly find issues on a wide range of browsers and devices.
- Provide feedback on the effectiveness of the automated suite of tests.

## Other Testing
### Penetration Testing
Penetration testing is a specialised style of testing that would largely need to be carried out by a third party service. It also appears to be a suggested requirement from the Government’s technology service manual: https://www.gov.uk/service-manual/technology/vulnerability-and-penetration-testing

### Vulnerability Testing
Azure provides the ability to scan for vulnerabilities in Docker images we push in our registry. This should provide a sufficient level of confidence that our services are secure, but it won’t hurt to include extra vulnerability testing in the remit of whichever third party we contract to perform the penetration testing. 

## Testing Requirements
The Test Lead for the project will be responsible for manually testing to the following standards.
### Platform / Browser requirements
From ‘Platform Non Functional Requirements’:

Windows
- Internet Explorer 11 (35.87%)
- Edge (latest versions) (12.5%)
- Google Chrome (latest versions) (36.19%)
- Mozilla Firefox (latest versions) (0.98%)

MacOS
- Safari 12 and later (3.91%)
- Google Chrome (latest versions) (1.87%)
- Mozilla Firefox (latest versions) (0.2%)

iOS
- Safari for iOS 10.3 and later (5.66%)
- Google Chrome (latest versions) (0.26%)

Android
- Google Chrome (latest versions) (1.42%)
- Samsung Internet (latest versions) (0.6%)

(%s are from Google Analytics for all Kahootz sessions from 01/03/20-31/5/20)

Breakdown by device:
- Desktop: 82.89%
- Tablet: 9.8%
- Mobile: 7.31%

If we are to attempt to test every single user story on all required platforms this will result in a lower rate of delivery without adding much value, given the low numbers of users on the rarer platforms. We are reducing the number of required testing platforms for every user story in favour of periodic wider testing for the less popular platforms. The ideal time to do more comprehensive platform testing would be when a feature is complete in production but before enabling its feature flag for the wider user base. 

The proposed requirements for a pull request to be merged to master/deployed to production should be that it is tested on the following platforms/browsers:

Windows
- Google Chrome (latest version)
- Internet Explorer 11
- Edge

Edge is more of an optional choice given its similarity to Google Chrome.

To reduce risks from not comprehensively testing all platforms we will rely on an automated test suite that can be run to check that the new features at least don’t break anything on the other platforms. 

## Accessibility Requirements
https://www.gov.uk/service-manual/helping-people-to-use-your-service/understanding-wcag

- Text-to-speech (Screen Reader)
  - It should be possible for a user to have any text on screen read back to them by a Screen reader application. 
  - All non-decorative images should have alt-text values that describe the image contents. 
  - Form elements should have explicit labels.
  - Link text should be descriptive.
- Keyboard Navigation
  - It should be possible to operate and switch between every interactable element of a feature solely with the keyboard. 
  - Tabbing through sections of the page should flow in a natural order. 
  - It should be possible to play, pause and stop moving content with the keyboard.
- Magnification
  - It should be possible to see content clearly and interact with features when using a screen magnifier.
- Contrast
  - Chosen colours should provide enough contrast against their backgrounds to remain visible if the user changes their contrast settings. 
- Text size 200%
  - Every feature is still usable when text size is increased by 200%
- Touch target areas (Mobile)
  - Touch target areas for interactive elements should be large enough to be easily selected. 
- Landscape (Mobile)
  - When viewing content on mobile devices, it should still be readable when the device is in landscape orientation.

Other considerations: 
- Any audio or video should have transcripts
- Video should have captions

Further testing information:
https://accessibility.18f.gov/checklist/

We might need to get an accessibility audit according to this https://www.gov.uk/service-manual/helping-people-to-use-your-service/testing-for-accessibility#getting-an-accessibility-audit

## Issue Logging and Handling
Anyone who discovers an issue should feel free to submit it on GitHub. This way the issues sit alongside the codebase and can be resolved automatically upon a relevant bug-fix being merged. When an issue is logged it should be added to the project backlog for prioritisation. If the person logging an issue feels it has enough urgency they should raise it with the product owner/wider team for discussion. Otherwise, regular ‘triage’ sessions will be held to discuss the bug backlog and whether there are any issues that can be brought into the current stream of work to be fixed.

#### Triage
> “(In a hospital) the process of deciding how seriously ill or injured a person is, so that the most serious cases can be treated first”

A triage session is where various stakeholders for the project come together to go through the issue backlog to determine their severity and prioritise them for fixing going forwards. 

#### Feature Requests 
Anyone within the team should feel free to make suggestions for improving the quality of a feature or the platform as a whole. This can be done in the form of a ‘feature request’ and should be logged in the same manner as a bug. It should then go into the backlog along with other issues and be triaged accordingly. If the feature request is deemed to have some value then it can be spun out into a ticket for further discovery or development.

#### Tech Debt
Tech Debt should also be logged as an Issue, so it can be triaged accordingly. We will want to keep on top of Tech Debt so that it doesn’t get out of control and start to negatively impact our ability to deliver a quality platform.

#### Writing a Unit Test
It has been suggested that when a bug is logged that the QA write a unit test for the issue. This will aid any developer fixing it, and also help to build a regression suite to ensure that the issue does not reappear in the future. It will be up to the QA to decide if the bug requires one and if their skills are up to the task.

## Testing Tooling
#### Automation

- Unit/Integration tests - Jest
- E2E - Cypress
- API - Postman

Potential accessibility tools: 

- A11y
- AccessLintCI
- Pa11y

Honourable mentions:

- Puppeteer (Headless Chrome)
- Gatling (Load testing)

#### Manual Testing aids
Some kind of VM for testing Internet Explorer.
Browserstack will be essential for testing cross-platform. 
