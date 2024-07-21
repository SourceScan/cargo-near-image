# `sourcescan/cargo-near` Docker Image

## Overview

The `sourcescan/cargo-near` Docker image is designed for reproducible Rust builds tailored for the NEAR blockchain platform, utilizing `cargo-near`. This image facilitates the verification of Rust projects in a consistent and controlled environment, ensuring builds can be reproduced accurately.

## Dockerfile Details

### Base Image

- **Image:** `amd64/debian:stable-slim`
- **URL:** [https://hub.docker.com/_/debian](https://hub.docker.com/_/debian)

### System Dependencies

- **Dependencies:** `curl`, `build-essential`, `ca-certificates`, `pkg-config`, `libudev-dev`, `git`
  - These are essential tools and libraries for building and compiling Rust projects, as well as managing package configurations and git repositories.

### Environment Variables

- `RUST_VERSION=1.79.0`
  - Arg that specifies the Rust version to be installed and used. Default is 1.79.0.
- `RUSTFLAGS='-C link-arg=-s'`
  - Configures rustc to pass the `-s` argument to the linker, stripping symbols from the compiled binary to reduce the size of the final binary.
- `CARGO_HOME=/home/near/.cargo`
  - Specifies the Cargo home directory.
- `RUSTUP_HOME=/home/near/.rustup`
  - Specifies the Rustup home directory.

### User Configuration

- **User:** `near`
  - A non-root user created to enhance security and avoid running builds as the root user.
- **User ID:** `1000`
- **Group ID:** `1000`

### Additional Tools

- **cargo-near**
  - **Commit:** a04e05ea700cecdaba0d29f54db8820055a65d0d
  - **Repository:** [https://github.com/near/cargo-near](https://github.com/near/cargo-near)
  - Cloned and installed from the specified commit for consistency and control over the exact version used.