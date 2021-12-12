#!/bin/sh

platform=macos
app_dir=${platform}/game-rs.app

echo "Creating folder structure"
mkdir -p ${app_dir}

mkdir -p ${app_dir}/Contents/MacOS	# save a few mkdir calls by starting with a deep directory
mkdir -p ${app_dir}/Contents/Resources

echo "Combining binaries int fat binaries"
lipo -create -output ${app_dir}/Contents/MacOS/fiiish target/aarch64-apple-darwin/release/fiiish target/x86_64-apple-darwin/release/fiiish

build_number=$(git rev-list --all --count)
echo "Build number: ${build_number}"

version=$(cargo get version)
echo "Version: ${build_number}"
