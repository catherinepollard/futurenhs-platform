"use strict";

const { NodeTracerProvider } = require("@opentelemetry/node");
const { BatchSpanProcessor } = require("@opentelemetry/tracing");
const { AzureMonitorTraceExporter } = require('@azure/monitor-opentelemetry-exporter');

const provider = new NodeTracerProvider({
  plugins: {
    https: {
      // Ignore Application Insights Ingestion Server
      ignoreOutgoingUrls: [new RegExp(/dc.services.visualstudio.com/i)],
    },
  },
});

const exporter = new AzureMonitorTraceExporter({
  logger: provider.logger,
  instrumentationKey: process.env.INSTRUMENTATION_KEY,
});

provider.register();

provider.addSpanProcessor(new BatchSpanProcessor(exporter, {
  bufferTimeout: 15000,
  bufferSize: 1000,
}));

console.log("tracing initialized");
