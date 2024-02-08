# `sourcescan/cargo-near` Docker Image

## Overview

The `sourcescan/cargo-near` Docker image is designed for reproducible Rust builds tailored for the NEAR blockchain platform, utilizing `cargo-near`. This image facilitates the verification of Rust projects in a consistent and controlled environment, ensuring builds can be reproduced accurately.

## Dockerfile Details

### Base Image

- **Image:** `amd64/rust:1.75-slim`
- **URL:** [https://hub.docker.com/_/rust?tab=tags&page=1&name=1.75-slim](https://hub.docker.com/_/rust?tab=tags&page=1&name=1.75-slim)

### Environment Variables

- `RUSTFLAGS='-C link-arg=-s'`
  - This flag configures rustc to pass the `-s` argument to the linker, stripping symbols from the compiled binary. This helps reduce the size of the final binary and is a common practice for optimizing Rust binaries for release.
- `CARGO_NEAR_NO_REPRODUCIBLE=true`
  - This environment variable disables reproducible builds in `cargo-near`.

### Additional Tools

- **cargo-near**
  - **Version:** v0.6.0
  - **URL:** [https://github.com/near/cargo-near/releases/tag/cargo-near-v0.6.0](https://github.com/near/cargo-near/releases/tag/cargo-near-v0.6.0)
