"use strict";

const { NodeTracerProvider } = require("@opentelemetry/node");
const { BatchSpanProcessor, ConsoleSpanExporter } = require("@opentelemetry/tracing");
const { AzureMonitorTraceExporter } = require('@azure/monitor-opentelemetry-exporter');

const provider = new NodeTracerProvider({
  plugins: {
    https: {
      // Ignore Application Insights Ingestion Server
      ignoreOutgoingUrls: [new RegExp(/dc.services.visualstudio.com/i)],
    },
  },
});

const exporter = process.env.INSTRUMENTATION_KEY ? new AzureMonitorTraceExporter({
  logger: provider.logger,
  instrumentationKey: process.env.INSTRUMENTATION_KEY,
}) : new ConsoleSpanExporter()

provider.register();

provider.addSpanProcessor(new BatchSpanProcessor(exporter, {
  bufferTimeout: 15000,
  bufferSize: 1000,
}));
