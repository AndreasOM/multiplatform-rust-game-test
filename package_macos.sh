#!/bin/sh

binary=game-rs
binary_dir=game-rs

platform=macos


# TODO: make this check if cargo get is available
# faster than installing cargo-get:
version=$(grep version ${binary_dir}/Cargo.toml|cut -d"\"" -f2)
# version=$(cd ${binary_dir} && cargo get version)
echo "Version: ${version}"

build_number=$(git rev-list ${version} --count)
echo "Build number: ${build_number}"


app_dir=package/${platform}-${version}/game-rs.app

echo "Creating folder structure in ${app_dir}"
mkdir -p ${app_dir}

mkdir -p ${app_dir}/Contents/MacOS	# save a few mkdir calls by starting with a deep directory
mkdir -p ${app_dir}/Contents/Resources

echo "Combining binaries int fat binaries"
lipo -create -output ${app_dir}/Contents/MacOS/${binary} \
	${binary_dir}/target/aarch64-apple-darwin/release/${binary} \
	${binary_dir}/target/x86_64-apple-darwin/release/${binary}

echo "Patching up Info.plist"

exp1="s/<key>CFBundleVersion<\\/key><string>.*<\\/string>/<key>CFBundleVersion<\\/key><string>${build_number}<\\/string>/g"
exp2="s/<key>CFBundleShortVersionString<\\/key><string>.*<\\/string>/<key>CFBundleShortVersionString<\\/key><string>${version}<\\/string>/g"
cat ${binary_dir}/Info.plist|sed ${exp1} |sed ${exp2} > ${app_dir}/Contents/Info.plist
