use serde::{Deserialize, Serialize};
use tide::prelude::*;
use tide::{Request, Server};

#[derive(Deserialize, Serialize)]
struct Doctor {
    name: String,
}

pub fn create_app() -> Server<()> {
    let mut app = tide::new();

    app.at("/hello/:name").get(hello_handler);
    app.at("/doctors").get(|req: Request<()>| async move {
        let id = req.header("X-Correlation-ID");

        match id {
            Some(x) => println!("Correlation ID is {}", x),
            None => println!("No correlation ID found in header"),
        }

        Ok(json!({
            "doctors": [
                {"type": "doctor", "name": "Dr Doolittle" },
                {"type": "doctor", "name": "Dr John" },
                {"type": "doctor", "name": "Dr Marten"}
            ]
        }))
    });
    app
}

async fn hello_handler(req: Request<()>) -> tide::Result<String> {
    let name = req.param("name")?;
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
