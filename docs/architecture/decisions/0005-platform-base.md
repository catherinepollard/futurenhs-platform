# 5. Platform base

Date: 2020-06-15

## Status

Proposed

## Context

### Problem statement

We want to build an open-source collaboration platform to succeed the current FutureNHS platform.

### Hypothesis

It may be quicker to build on top of an existing open-source hub.

### Current situation

The client is currently using Kahootz and they are not happy with it. This is because it is expensive, proprietary, and the supplier is very slow to add new features.
We have a team who are familiar with TypeScript and React.

### Option 1 - Extend from [Next.js](https://nextjs.org/) starter app (recommended)

(taking code and inspiration from existing open-source systems)

Benefits

- Tech stack that the we control and are familiar with.
- Can use [NHS.UK UI components](https://github.com/NHSDigital/nhsuk-react-components).
- Can focus on exactly the features we need. Helps not to overburden users.

Risks

- We will have to fix issues, which could be avoided by using existing tested solutions.
- There needs to be a team to maintain the software.

### Option 2 - Extend from [Crocus Wiki](https://site.crowi.wiki/)

Benefits

- Tech stack that the team are familiar with.
- Existing community helps maintaining software base.
- Existing user-base to file off the rough edges.

Risks

- Redundant features add cognitive overhead for users and developers.
- Initial overhead for understanding code base.
- Need to add "workspace" functionality, which could be invasive.

### Option 3 - Extend from [HumHub](https://www.humhub.com/)

Benefits

- Meets more of the client's needs initially.

Risks

- Old tech stack will take a long time to learn, slow development, and harm team morale.
- Lacks a high availability option and documentation about scaling.

### Option 4 - Extend from [Nextcloud](https://nextcloud.com/)

Benefits

- Extensible through "Apps", which can provide new views, use existing backends and extend existing functionality by listening to events.

Risks

- Redundant features add cognitive overhead for users and developers.
- Initial overhead for understanding code base.
- Need to add "workspace" functionality, which could be invasive.
- Need to change content ownership from user-owned to community-owned, which could be invasive.
- Accessibility currently in a poor state.

[@simplybenuk](https://github.com/simplybenuk)'s (product owner) comment after testing Nextcloud:

> Been having a look around Nextcloud and it feels like the experience is too different. Feels more like an alternative to how we use Office365 at work than how the platform is used

### Option 5 - Extend from [Wiki.js](https://wiki.js.org/)

Benefits

- Modern tech stack.
- Existing user-base to file off the rough edges (in practice, there were still a lot of javascript errors though).

Risks

- Team does not know Vue.js. May take some time to onboard.
- Need to add "workspace" functionality, which could be invasive.

### Option 6 - Extend from [Discourse](https://www.discourse.org/)

Benefits

- Already used by some teams in the NHS.

Risks

- Redundant features add cognitive overhead for users and developers.
- Initial overhead for understanding code base.
- The forum aspect of the software isn't really the core of the platform, so we would be building a lot of things via plugins. This may be hard to maintain.
- Seems hard to run/operate.

## More Details

More detailed analysis lives [in google sheets](https://docs.google.com/spreadsheets/d/e/2PACX-1vRKOSyGLwYlZGMLPS3dL21hGoN9IMAD2KHCr8A807Potc5or-h9SCbXFpQh4hh2qog4nr5Vk0UpkIUo/pubhtml). Note that the public version is missing all notes. Team members should view [this version](https://docs.google.com/spreadsheets/d/1CTbuVPZjEjijSxpgySup7V9V7QYMz3mAQ5g4pqlfXeE/edit#gid=0) instead.

## Decision

We will go with option 1: extend from Next.js starter app.

## Consequences

See risks and benefits discussed in [Context](#context).
