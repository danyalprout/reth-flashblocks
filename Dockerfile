FROM rust:1.87 AS build

WORKDIR /app

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y git libclang-dev pkg-config curl build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY ./ .

RUN cargo build --release --bin base-reth-node

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y jq curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app/target/release/base-reth-node ./
