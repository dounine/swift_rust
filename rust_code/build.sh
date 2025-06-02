#!/bin/bash
cargo build
rm -rf ./bindings/*
cargo run -p uniffi-bindgen generate ./src/apple.udl --language swift --out-dir bindings/
for TARGET in \
        aarch64-apple-ios \
        aarch64-apple-ios-sim
do
    rustup target add $TARGET
    cargo build --release --target=$TARGET
done
#mv ./bindings/mathFFI.modulemap ./bindings/module.modulemap
#mv ./bindings/math.swift ./ios/apple.swift
rm -rf ios/apple.xcframework
xcodebuild -create-xcframework  \
-library ./target/aarch64-apple-ios/release/libapple.a -headers ./bindings \
-library ./target/aarch64-apple-ios-sim/release/libapple.a -headers ./bindings \
  -output ios/apple.xcframework