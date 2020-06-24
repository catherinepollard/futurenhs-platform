use std::future::Future;
use std::pin::Pin;
use tide::{Next, Request, Result, Server};
use tracing::{info, info_span};
use tracing_futures::Instrument;

#[derive(Debug)]
pub struct State {}

fn log<'a>(
    req: Request<State>,
    next: Next<'a, State>,
) -> Pin<Box<dyn Future<Output = Result> + Send + 'a>> {
    Box::pin(async {
        let span = info_span!(
            "request",
            http.status_code = tracing::field::Empty,
            http.method = req.method().as_ref(),
            http.target = req.url().as_ref()
        );

        let res = next.run(req).instrument(span.clone()).await?;
        span.record("http.status_code", &u16::from(res.status()));

        Ok(res)
    })
}

pub fn create_app() -> Server<State> {
    let mut app = tide::with_state(State {});
    app.middleware(log);

    app.at("/hello/:name").get(hello_handler);
    app
}

#[tracing::instrument]
async fn hello_handler(req: Request<State>) -> tide::Result<String> {
    let name = req.param("name")?;
    info!("The users name is: {}", name);

    Ok(hello(name))
}

#[tracing::instrument]
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
