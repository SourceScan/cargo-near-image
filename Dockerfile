FROM amd64/rust:1.75-slim

ENV RUSTFLAGS='-C link-arg=-s'
ENV CARGO_NEAR_NO_REPRODUCIBLE=true

RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/near/cargo-near/releases/download/cargo-near-v0.6.0/cargo-near-installer.sh | sh