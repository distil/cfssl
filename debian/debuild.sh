#!/usr/bin/env bash
set -aeux
rm -rf debian/tmp
DEB_BUILD_OPTIONS=nostrip debuild --no-tgz-check -uc -us
