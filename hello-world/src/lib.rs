use appinsights::telemetry::Telemetry;
use appinsights::telemetry::{RequestTelemetry, SeverityLevel};
use appinsights::{InMemoryChannel, TelemetryClient};
use http::Method;
use tide::{Request, Server};

pub struct State {
    client: TelemetryClient<InMemoryChannel>,
    parent_id: String,
}

pub fn create_app(client: TelemetryClient<InMemoryChannel>) -> Server<State> {
    client.track_event("Track event - inside create_app");
    client.track_trace(
        "*** trace within create_app function",
        SeverityLevel::Warning,
    );

    let telemetry = RequestTelemetry::new(
        Method::GET,
        "https://example.com/main.html".parse().unwrap(),
        std::time::Duration::from_secs(2),
        "200",
    );

    client.track(telemetry);

    let state = State { client, parent_id: "1".to_string() };

    let mut app = tide::with_state(state);

    app.at("/hello/:name").get(hello_handler);
    app
}

async fn hello_handler(req: Request<State>) -> tide::Result<String> {
    let mut telemetry = RequestTelemetry::new(
        Method::GET,
        "https://example.com/hello/main.html".parse().unwrap(),
        std::time::Duration::from_secs(2),
        "200",
    );

    let parent_id = req.state().parent_id.clone();

    telemetry
        .tags_mut()
        .operation_mut()
        .set_parent_id(parent_id);

    let name = req.param("name")?;
    req.state().client.track(telemetry);

    Ok(hello(name))
}

fn hello(name: String) -> String {
    format!("Hello, {}\n", name)
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_hello() {
        assert_eq!("Hello, SomeName\n", hello(String::from("SomeName")));
    }
}
