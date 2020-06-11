use tide::{Request, Server};
use tracing::{event, Level};

#[tracing::instrument]
pub fn create_app() -> Server<()> {
    let mut app = tide::new();
    app.at("/hello/:name").get(hello_handler);
    app
}

#[tracing::instrument]
async fn hello_handler(req: Request<()>) -> tide::Result<String> {
    let name = req.param("name")?;
    event!(Level::INFO, where_am_i = "inside handler!");

    Ok(hello(name))
}

#[tracing::instrument]
fn hello(name: String) -> String {
    event!(Level::INFO, where_am_i = "inside hello function!");

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
