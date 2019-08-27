#!/usr/bin/env bash
set -euxo pipefail

# Build the image that will run debuild.
docker build -t distil/debuild -f debian/Dockerfile.debuild .

docker run --rm -v $(pwd):/build/ -w /build distil/debuild /bin/bash -c "/build/debian/debuild.sh && /usr/bin/debuild clean && cp ../*.deb /build"
