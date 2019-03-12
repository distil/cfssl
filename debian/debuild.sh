#!/usr/bin/bash

set -aeux

cd /build
DEB_BUILD_OPTIONS=nostrip debuild --no-tgz-check -uc -us
cp ../*.deb /build
