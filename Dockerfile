# Use the Rust slim image as the base
FROM amd64/rust:1.75-slim

# Set environment variables for Rust
ENV RUSTFLAGS='-C link-arg=-s'
ENV CARGO_NEAR_NO_REPRODUCIBLE=true

# Update package lists, install curl, and clean up apt cache to keep the image size down
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Install the wasm32-unknown-unknown target
RUN rustup target add wasm32-unknown-unknown

# Install cargo-near using the installer script
RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v0.6.0/cargo-near-installer.sh | sh

# Create a group 'builder' and user 'builder' with UID and GID 1000
RUN groupadd -g 1000 builder && \
    useradd -m -d /home/builder -s /bin/bash -g builder -u 1000 builder

# Switch to the builder user
USER builder
