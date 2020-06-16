use appinsights::telemetry::SeverityLevel;
use appinsights::TelemetryClient;
fn main() -> std::io::Result<()> {
    let id = "0b902312-dbaa-4ac0-bd21-029752baeb37";
    let client = TelemetryClient::new(id.to_string());
    client.track_event("*** inside main function");
    client.track_trace("*** within main function", SeverityLevel::Warning);
    let result = smol::run(hello_world::create_app(client).listen("0.0.0.0:3030"));
    result
}
