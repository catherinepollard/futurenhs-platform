## Feature Flags and Staging
We are proposing to forgo testing in a Staging environment before deploying code to Production. To achieve this we will use “feature flags” - switches that allow you to toggle isolated code or features in Production. This allows us to deploy code directly from master to Production behind a feature flag that prevents users from seeing the new code until it has been thoroughly verified that it is safe to make available. 

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
