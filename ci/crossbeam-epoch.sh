#!/bin/bash

cd "$(dirname "$0")"/../crossbeam-epoch
set -ex

export RUSTFLAGS="-D warnings"

cargo check --bins --examples --tests
cargo test

if [[ "$RUST_VERSION" == "nightly"* ]]; then
    cargo test --features nightly

    RUSTDOCFLAGS=-Dwarnings cargo doc --no-deps --all-features

    if [[ "$OSTYPE" == "linux"* ]]; then
        ASAN_OPTIONS="detect_odr_violation=0 detect_leaks=0" \
        RUSTFLAGS="-Z sanitizer=address" \
        cargo run \
            --release \
            --target x86_64-unknown-linux-gnu \
            --features sanitize,nightly \
            --example sanitize
    fi

    ./../ci/miri.sh -- -Zmiri-disable-stacked-borrows
fi
