#!/bin/bash

cd "$(dirname "$0")"/../crossbeam-utils
set -ex

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cargo test --features nightly

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    ./../ci/miri.sh -- -Zmiri-disable-isolation
fi
