#!/usr/bin/env bash

set -aeux

# This should be unique to your repository. Most have a README documenting how to build and produce a binary or
# other type of artifact. In this case the docker_build.sh script contains npm commands.
docker-build.sh "./script/build"

# Build the image that will run debuild.
docker build . -f debian/Dockerfile.debuild -t debuild

# Make the directory with the assets will care about.
SHORT_HASH=$(git rev-parse --short HEAD)
VERSION="1~$SHORT_HASH-1"

# This should be unique to your repository.
DIR="plt_transfer-$VERSION"

# Insert the version into the changelog.
sed -i "s/VERSION/$VERSION/g" debian/changelog

# Search and replace the correct directory name into our rules file.
sed -i "s/FOLDER/$DIR/g" debian/rules

# Copy all of the files that you want in the debian package. This may already be in a folder
# produced by the build process.
mkdir -p $DIR
cp bin/* $DIR

# Run debuild inside of that container and copy the resulting package locally.
docker run --rm -v $PWD:/build debuild sh build/debian/debuild.sh

# Clean the folder in the workspace.
rm -rf $DIR
