use std::time::Duration;
use tokio::{task, time};

#[tokio::test]
async fn hello_world() {
    let server = task::spawn(async {
        hello_world::create_app()
            .listen("localhost:8080")
            .await
            .unwrap()
    });

    let client = task::spawn(async {
        time::delay_for(Duration::from_millis(100)).await;
        let string: String = surf::get("http://localhost:8080/hello/Me")
            .recv_string()
            .await
            .unwrap();
        assert_eq!(string, "Hello, Me\n".to_string());
    });

    tokio::select! {
        v = client => v.unwrap(),
        v = server => v.unwrap()
    }
}
