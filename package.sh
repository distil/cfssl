#!/bin/bash
set -e

DEB_BUILD_OPTIONS=nostrip debuild --no-tgz-check -uc -us
mv ../*.deb .
