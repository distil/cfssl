#!/bin/bash
set -e

# Setup dependencies
mkdir -p opt/go
GOPATH="$(pwd)/opt/go"

go get github.com/GeertJohan/go.rice
go get github.com/GeertJohan/go.rice/rice
PATH="$PATH:$GOPATH/bin"

# Cleanup the old build files
rm -rf dist

mkdir -p dist/linux-amd64
mkdir -p dist/darwin-amd64
mkdir -p dist/windows-amd64

# Embed go for static binary distribution
(cd cli/serve; rice embed-go)

# Build the Linux binaries
./script/build -os="linux" -arch="amd64"
(cd dist
for file in *_linux-amd64
do
  mv -v "$file" "linux-amd64/${file/_linux-amd64/}"
done)
