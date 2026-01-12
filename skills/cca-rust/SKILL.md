---
name: cca-rust
description: CCA language context for Rust projects. Auto-loaded when Cargo.toml is detected.
---

# CCA: Rust Context

## Language Detection
This context applies when any of these files exist:
- `Cargo.toml`
- `Cargo.lock`
- `*.rs` files

## Build-Test-Improve Commands

### Build
```bash
# Debug build
cargo build

# Release build
cargo build --release

# Check without building (faster)
cargo check
```

### Test
```bash
# Run all tests
cargo test

# Verbose output
cargo test -- --nocapture

# Specific test
cargo test test_name

# Doc tests only
cargo test --doc
```

### Lint/Format
```bash
# Format
cargo fmt

# Clippy (lints)
cargo clippy
cargo clippy -- -D warnings  # Treat warnings as errors

# Check formatting without changes
cargo fmt -- --check
```

## Common Patterns

### Error Handling
```rust
// Use Result with custom error types
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("not found: {0}")]
    NotFound(String),
    
    #[error("validation failed: {0}")]
    Validation(String),
    
    #[error(transparent)]
    Io(#[from] std::io::Error),
}

// Use ? operator for propagation
fn process() -> Result<Data, AppError> {
    let file = std::fs::read_to_string("data.txt")?;
    let data = parse(&file).map_err(|e| AppError::Validation(e.to_string()))?;
    Ok(data)
}

// anyhow for applications, thiserror for libraries
use anyhow::{Context, Result};

fn main() -> Result<()> {
    let config = load_config()
        .context("failed to load configuration")?;
    Ok(())
}
```

### Ownership Patterns
```rust
// Prefer borrowing over ownership
fn process(data: &str) -> String {
    data.to_uppercase()
}

// Clone only when necessary
// Use Cow for conditional ownership
use std::borrow::Cow;

fn maybe_modify(s: &str) -> Cow<str> {
    if s.contains("old") {
        Cow::Owned(s.replace("old", "new"))
    } else {
        Cow::Borrowed(s)
    }
}
```

### Async Patterns
```rust
// Tokio runtime
#[tokio::main]
async fn main() {
    let result = fetch_data().await;
}

// Concurrent operations
let (users, posts) = tokio::join!(
    fetch_users(),
    fetch_posts()
);

// Spawn tasks
tokio::spawn(async move {
    background_work().await;
});
```

### Builder Pattern
```rust
#[derive(Default)]
pub struct ConfigBuilder {
    timeout: Option<Duration>,
    retries: Option<u32>,
}

impl ConfigBuilder {
    pub fn timeout(mut self, d: Duration) -> Self {
        self.timeout = Some(d);
        self
    }
    
    pub fn build(self) -> Config {
        Config {
            timeout: self.timeout.unwrap_or(Duration::from_secs(30)),
            retries: self.retries.unwrap_or(3),
        }
    }
}
```

## Project Structure Conventions

```
my_project/
├── Cargo.toml
├── Cargo.lock
├── src/
│   ├── main.rs         # Binary entry (or lib.rs for library)
│   ├── lib.rs          # Library root
│   ├── error.rs        # Error types
│   ├── config.rs       # Configuration
│   └── models/
│       └── mod.rs
├── tests/              # Integration tests
│   └── integration.rs
├── benches/            # Benchmarks
└── examples/
    └── basic.rs
```

## Cargo Commands
```bash
# Add dependency
cargo add serde --features derive

# Update dependencies
cargo update

# Generate docs
cargo doc --open

# Run example
cargo run --example basic

# Bench (nightly)
cargo bench
```

## Common Gotchas
- Borrower checker: can't mutably borrow while immutably borrowed
- String vs &str: `String` owns, `&str` borrows
- `unwrap()` panics - use `?`, `expect()`, or handle `Result`/`Option`
- Lifetimes: usually elided, explicit when compiler can't infer
- `async` functions return `impl Future` - need runtime to execute
- Feature flags: check what's enabled in `Cargo.toml`
