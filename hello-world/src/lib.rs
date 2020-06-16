use appinsights::telemetry::{RequestTelemetry, SeverityLevel};
use appinsights::{InMemoryChannel, TelemetryClient};
use http::Method;
use tide::{Request, Server};

pub struct State {
    client: TelemetryClient<InMemoryChannel>,
}

pub fn create_app(client: TelemetryClient<InMemoryChannel>) -> Server<State> {
    client.track_event("*** event inside create_app");
    client.track_trace(
        "*** trace within create_app function",
        SeverityLevel::Warning,
    );

    let state = State { client };

    let mut app = tide::with_state(state);

    app.at("/hello/:name").get(hello_handler);
    app
}

async fn hello_handler(req: Request<State>) -> tide::Result<String> {
    let telemetry = RequestTelemetry::new(
        Method::GET,
        "https://example.com/main.html".parse().unwrap(),
        std::time::Duration::from_secs(2),
        "200",
    );
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
