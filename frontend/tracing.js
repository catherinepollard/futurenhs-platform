"use strict";

const { LogLevel } = require("@opentelemetry/core");
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
  instrumentationKey: 'a2fa06cc-a1de-4efd-9096-9f99aa23a01c',
});

provider.register();

provider.addSpanProcessor(new BatchSpanProcessor(exporter, {
  bufferTimeout: 15000,
  bufferSize: 1000,
}));

console.log("tracing initialized");
