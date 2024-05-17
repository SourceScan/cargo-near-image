# Start with Debian slim image as the base
FROM amd64/debian:stable-slim

# Install system dependencies and create a non-root user 'near'
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       build-essential \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g 1000 near \
    && useradd -m -d /home/near -s /bin/bash -g near -u 1000 near

# Switch to the builder user
USER near

# Set up the environment for the near user with Rust-specific configurations
ARG RUST_VERSION=1.75.0
ENV HOME=/home/near \
    RUSTUP_TOOLCHAIN=$RUST_VERSION \
    RUSTFLAGS='-C link-arg=-s' \
    CARGO_HOME=/home/near/.cargo \
    RUSTUP_HOME=/home/near/.rustup

# Install Rust using rustup with a specific version, add the wasm target, install cargo-near, and set directory permissions
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain $RUST_VERSION -y \
    && chmod -R a+rwx $CARGO_HOME $RUSTUP_HOME

# Ensure the Rust and Cargo binaries are in the PATH for easy command-line access
ENV PATH="$CARGO_HOME/bin:$PATH"

ARG CARGO_NEAR_VERSION=0.6.0
# Continuation of the Rust setup: adding the wasm target for WebAssembly development and installing cargo-near for NEAR protocol development, followed by setting appropriate permissions for the builder's home directory
RUN rustup target add wasm32-unknown-unknown \
    && curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v$CARGO_NEAR_VERSION/cargo-near-installer.sh | sh \
    && chmod -R a+rwx $HOME