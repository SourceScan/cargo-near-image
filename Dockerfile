# Start with Debian slim image as the base
FROM amd64/debian:stable-slim

# Install necessary dependencies for building Rust projects and other tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       curl \
       build-essential \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user 'builder' for running subsequent commands
RUN groupadd -g 1000 builder && \
    useradd -m -d /home/builder -s /bin/bash -g builder -u 1000 builder

# Switch to the builder user
USER builder

# Set up the environment under the builder user
ENV HOME=/home/builder \
    RUSTFLAGS='-C link-arg=-s' \
    CARGO_NEAR_NO_REPRODUCIBLE=true \
    CARGO_HOME=/home/builder/.cargo \
    RUSTUP_HOME=/home/builder/.rustup

# Download and install Rust (specific version) without self-update
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile minimal --default-toolchain 1.75.0 -y

# Ensure the cargo and rustup directories are fully accessible
RUN chmod -R a+rwx $CARGO_HOME $RUSTUP_HOME

# Set PATH to include cargo bin
ENV PATH="$CARGO_HOME/bin:$PATH"

# Install the wasm32-unknown-unknown target
RUN rustup target add wasm32-unknown-unknown

# Install cargo-near using the installer script
RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v0.6.0/cargo-near-installer.sh | sh

# Ensure the user's home directory is fully accessible
RUN chmod -R a+rwx $HOME
