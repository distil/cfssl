#!/bin/bash
set -e

# Setup dependencies
mkdir -p ./opt/go
export GOPATH=$(pwd)/opt/go

go get github.com/GeertJohan/go.rice
go get github.com/GeertJohan/go.rice/rice
export PATH=$PATH:$GOPATH/bin

echo "BRANCH: $CFSSL_BRANCH"

# Cleanup the old build files
rm -rf ./dist

mkdir -p ./dist/linux-amd64
mkdir -p ./dist/darwin-amd64
mkdir -p ./dist/windows-amd64

# Embed go for static binary distribution
cd ./cli/serve
rice embed-go
cd ../../

# Build the Linux binaries
./script/build -os="linux" -arch="amd64"
cd ./dist
for file in *_linux-amd64
do
  mv -v "$file" "linux-amd64/${file/_linux-amd64/}"
done
cd ../

# Build the Darwin (MacOS) binaries
./script/build -os="darwin" -arch="amd64"
cd ./dist
for file in *_darwin-amd64
do
  mv -v "$file" "darwin-amd64/${file/_darwin-amd64/}"
done
cd ../

# Build the Windows binaries
./script/build -os="windows" -arch="amd64"
cd ./dist
for file in *_windows-amd64.exe
do
  mv -v "$file" "windows-amd64/${file/_windows-amd64.exe/.exe}"
done
cd ../

#Publish tarballs to /build
COMMIT=$(git log --pretty=format:'%h' -n 1).$(date +'%y-%m-%d:%T')
echo "Commit: $COMMIT"

cd ./dist
VERSION=$(./linux-amd64/cfssl version | grep "Version" | cut -c 10-)
echo "Version: $VERSION"
SAVE_LOCATION="/var/www/html/builds/cfssl/$CFSSL_BRANCH/saves/$VERSION"
mkdir -p $SAVE_LOCATION

echo "Bundling Linux binaries"
mv ./linux-amd64 ./cfssl-$VERSION
tar czf $SAVE_LOCATION/linux-amd64-$VERSION-$COMMIT.tar.gz ./cfssl-$VERSION
mv ./cfssl-$VERSION ./linux-amd64

echo "Bundling MacOS binaries"
mv ./darwin-amd64 ./cfssl-$VERSION
tar czf $SAVE_LOCATION/darwin-amd64-$VERSION-$COMMIT.tar.gz ./cfssl-$VERSION
mv ./cfssl-$VERSION ./darwin-amd64

echo "Bundling Windows executables"
mv ./windows-amd64 ./cfssl-$VERSION
tar czf $SAVE_LOCATION/windows-amd64-$VERSION-$COMMIT.tar.gz ./cfssl-$VERSION
mv ./cfssl-$VERSION ./windows-amd64

DIST_TARBALL=$(ls -t $SAVE_LOCATION/linux-amd64-*.tar.gz | head -n 1)
rm -f /var/www/html/builds/cfssl/$CFSSL_BRANCH/HEAD
ln -sf "$DIST_TARBALL" "/var/www/html/builds/cfssl/$CFSSL_BRANCH/HEAD"
