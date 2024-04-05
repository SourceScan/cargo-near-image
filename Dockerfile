# Use the Rust slim image as the base
FROM amd64/rust:1.75-slim

# Set environment variables for Rust
ENV RUSTFLAGS='-C link-arg=-s'
ENV CARGO_NEAR_NO_REPRODUCIBLE=true

# Update package lists, install curl, and clean up apt cache to keep the image size down
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl gosu \
    && rm -rf /var/lib/apt/lists/*
    
# Install the wasm32-unknown-unknown target
RUN rustup target add wasm32-unknown-unknown

# Install cargo-near using the installer script
RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v0.6.0/cargo-near-installer.sh | sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]