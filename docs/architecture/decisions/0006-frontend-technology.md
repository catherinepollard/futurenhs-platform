# 6. Frontend technology

Date: 2020-06-26

## Status

Accepted

## Context

The most important criterion for choosing frontend technology is the impact it has on the user. We want to deliver a good user experience. Technology choice needs to account for that.

The best way to make resilient websites is to make sure they work with HTML only. This is good for flaky networks (HTML is the first thing to load, CSS and JavaScript load later and may not load at all) and also for accessibility, since the accessibility tree is built mostly from HTML. Both CSS and JavaScript should be used to enhance the user experience. This is described in more detail in [building a resilient frontend using progressive enhancement](https://www.gov.uk/service-manual/technology/using-progressive-enhancement). With progressive enhancement there is likely a tradeoff between speed of delivering features and ensuring they work without JavaScript. This is something we need to address for every feature we build.

Instead of writing JavaScript directly, we prefer to write [TypeScript](https://www.typescriptlang.org/) and introduce a compile step in our build pipeline. The reason for this is a static type system:

- It lets us find more bugs while we write code, which results in fewer bugs for users.
- Editors can provide richer experiences with autocomplete, which results in faster and a more pleasant developer experience.

To speed up delivery and reduce maintenance burden we would like to reuse existing NHS frontend libraries. At this time there are two choices:

- [NHS.UK frontend](https://github.com/nhsuk/nhsuk-frontend): The official NHS.UK UI components, built with [Nunjucks](https://mozilla.github.io/nunjucks/) templates, JavaScript and SCSS. The technology forces us to render sites on the server. Using progressive enhancement is relatively easy. However there is little "out of the box" developer tooling, which means we will have to pay an upfront cost of creating a development and build pipeline.
- [NHS.UK React Components](https://github.com/NHSDigital/nhsuk-react-components): A port of the NHS.UK frontend to [React](https://reactjs.org/). Our team has existing knowledge in building websites using TypeScript and React. However React is a relatively large JavaScript library. We will have to take extra measures to ensure the website will run on all devices and will be accessible to all users.

## Decision

We're going to built the frontend using TypeScript, [Next.js](https://nextjs.org/) and the NHS.UK React Components.

Reasons:

- Our team is familiar with the technology.
- Next.js gives us an easy way to render pages on the server, so the browser can show a functional website without JavaScript.
- The NHS.UK React Components will need slight changes to adopt for the FutureNHS branding. But they still allow us to start from a solid set of accessible components.

## Consequences

We will assess the required level of progressive enhancement for each feature we build. For features that should work entirely without JavaScript, we will consider adding automated integration tests to ensure they don't regress.
