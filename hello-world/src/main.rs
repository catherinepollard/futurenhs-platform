use appinsights::TelemetryClient;
fn main() -> std::io::Result<()> {
    let client = TelemetryClient::new("0b902312-dbaa-4ac0-bd21-029752baeb37".to_string());

    client.track_event("Track event - main function");
    smol::run(hello_world::create_app(client).listen("0.0.0.0:3030"))
}
