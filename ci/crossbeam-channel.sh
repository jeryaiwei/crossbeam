#!/bin/bash

cd "$(dirname "$0")"/../crossbeam-channel
set -ex

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test -- --test-threads=1

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cd benchmarks
    cargo check --bins
    cd ..

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    ./../ci/miri.sh
fi
