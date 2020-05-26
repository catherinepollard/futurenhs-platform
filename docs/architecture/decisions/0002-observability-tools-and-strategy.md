# 2. Observability tools and strategy

Date: 2020-05-26

## Status

Accepted

## Context

We need to be able to monitor our cluster / apps, and be notified by automated alerts if problems occur.

## Decision


### Metrics
We will use [Prometheus](https://prometheus.io/) to gather metrics for the following reasons:
 - Both [Linkerd](https://linkerd.io/2/tasks/exporting-metrics/) and [Istio](https://istio.io/docs/tasks/observability/metrics/querying-metrics/) (our potential service mesh choices) have an internal Prometheus instance.
 - Proven and popular, wide compatibility, Cloud Native Computing Foundation project.
 - We can leverage some of the knowledge and existing work done by the MRHA team
 - Close integration with Grafana (pre-existing dashboard templates for exporters etc)

Prometheus support within [Azure Monitor for Containers](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview) means that no separate Prometheus server is required but allows for scraping /metrics endpoints and make use of Prometheus queries for custom alerts etc.

An example of Prometheus Query (PromQL) can be found here. https://github.com/MHRA/deployments/blob/master/observability/prometheus-configmap.yaml#L15


### Tracing
Instrumentation for our apps will follow the [OpenTelemetry](https://opentelemetry.io/) API.

Will be consumed by [Azure Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/distributed-tracing) or [Jaeger](https://www.jaegertracing.io/). A spike will happen at a later date to determine what we require here.


### Logging
Azure monitor pulls in logs via it's Metrics API
 - We can use Log Analytics in the Azure portal to write log queries and interactively analyze log data
 - We can use the Application Insights analytics console in the Azure portal to write log queries and interactively analyze log data from Application Insights.

NOTE: Log Analytics pricing - 31 days free.  If required, can be retained after this for £0.097 per GB per month(NOTE: Presume this need to be set manually by us in settings somewhere if needed)


### Alerting
Alerts will be configured through Azure Monitor.

Azure uses the Kusto query language. An example can be found here https://github.com/MHRA/products/blob/master/infrastructure/modules/cluster/alerts.tf#L29

Action Groups can be associated with alerts to handle SMS, email notifications for people on support duty.

Note: Prometheus also has an ‘Alert Manager’ which can handle some / much of the above. We should be able to compare the two fairly easily once up and running.

### Visualisation
Azure Dashboard offers basic functionality and may be sufficient, however Grafana may well be worth setting up due to the availability of pre-existing templates for a number of our needs (eg node exporter dashboard), as well as it's greater flexibility. Spike to follow.


## Consequences

No particular risks at this stage to mitigate from our above choices - obviously we are still at a very early stage and have ample room to manouvre.
