# Start with Debian slim image as the base
FROM amd64/debian:stable-slim

# Install system dependencies and create a non-root user 'builder'
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       build-essential \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g 1000 builder \
    && useradd -m -d /home/builder -s /bin/bash -g builder -u 1000 builder

# Switch to the builder user
USER builder

# Set up the environment for the builder user with Rust-specific configurations
ARG RUST_VERSION=1.75.0
ENV HOME=/home/builder \
    RUSTUP_TOOLCHAIN=$RUST_VERSION \
    RUSTFLAGS='-C link-arg=-s' \
    CARGO_NEAR_NO_REPRODUCIBLE=true \
    CARGO_HOME=/home/builder/.cargo \
    RUSTUP_HOME=/home/builder/.rustup

# Install Rust using rustup with the specified version, add the wasm target, install cargo-near, and set directory permissions
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain $RUST_VERSION -y \
    && chmod -R a+rwx $CARGO_HOME $RUSTUP_HOME

# Ensure the Rust and Cargo binaries are in the PATH for easy command-line access
ENV PATH="$CARGO_HOME/bin:$PATH"

# Continuation of the Rust setup: adding the wasm target for WebAssembly development and installing cargo-near for NEAR protocol development, followed by setting appropriate permissions for the builder's home directory
RUN rustup target add wasm32-unknown-unknown \
    && curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v0.6.0/cargo-near-installer.sh | sh \
    && chmod -R a+rwx $HOME
