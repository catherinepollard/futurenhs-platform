# 3. Observability tools and strategy

Date: 2020-06-10

## Status

Awaiting Approval

## Context

Due to the decision to use Feature Flagging in Production we have decided to not implement a Staging environment.

## Decision
We have decided to forgo testing in a Staging environment before deploying code to Production. 
To test effectively we will use “feature flags” - switches that allow you to toggle isolated code or features in Production. 
This allows us to deploy code directly from master to Production behind a feature flag that prevents users from seeing the new code until it has been thoroughly verified that it is safe to make available.

Staging environments were introduced to solve a specific problem in waterfall development - checking code directly into Production would often cause something to break, with this likelihood rising exponentially the more developers you have. Staging environments that mimic Production as closely as possible were introduced as an extra layer of insulation to help prevent this. Builds are tested in this environment, where hopefully any major issues can be discovered and addressed before deploying to Production.

Staging environments can be quite useful if you have multiple teams in an organisation committing code independently of each other. They also give you a higher degree of certainty that code is safe to deploy.

However, there are some downsides to having a staging environment.

Staging environments can get out of sync with Production quite easily, and there is an overhead involved with maintaining them so that they stay up-to-date. There is also the monetary cost of permanently hosting an extra set of servers that mirror Production.

While they are designed to mirror Production, they rarely use actual Production data. Therefore the staging test data is never going to be as good as a live environment. It can never match the scale and diversity of real data. Bugs found in Production might not be reproducible in staging because the same data is not available. The flipside is that something fixed in staging may not actually fix the issue in Production because the environments and data may differ in crucial ways.

Getting new features and urgent bug-fixes to Production is slowed down by having a staging environment. Having an extra step of testing in the way is once again another overhead in both time and money. Having to rebuild a feature build for staging and having a QA repeat testing can take a significant amount of time.


## Consequences

### Pros (to having a Staging environment)

- Can provide a higher degree of certainty that code is safe to deploy
- Useful when you have multiple teams in an organisation committing code independently

### Cons (to having a Staging environment)

- Staging environments are becoming an outdated concept - the were introduced when applications where ‘shipped’ and Production data was not accessible
- Incurs extra cost for maintaining environment, both in work hours and hosting fees
- Staging data will never be as good as Production
- Staging can never match the scale of Production
- An extra step of repeated testing (monotonous for the tester 🙃)
- Slows down pushing urgent fixes to Production

Given the above we believe the slightly higher risk of issues appearing in Production is a worthwhile trade-off in terms of deployment efficiency, testing efficacy and rapid turnaround on identifying and applying fixes in Production. 
