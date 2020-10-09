#!/bin/bash

cd "$(dirname "$0")"/../crossbeam-deque
set -ex

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    ./../ci/miri.sh
fi
