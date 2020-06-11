use tracing::Level;

#[tracing::instrument]
fn main() -> std::io::Result<()> {
    let subscriber = tracing_subscriber::fmt::Subscriber::builder()
        .json()
        .with_timer(tracing_subscriber::fmt::time::ChronoUtc::rfc3339())
        .with_max_level(Level::DEBUG)
        .finish();

    tracing::subscriber::set_global_default(subscriber).expect("setting default subscriber failed");

    smol::run(hello_world::create_app().listen("0.0.0.0:3030"))
}
