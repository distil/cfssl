#!/usr/bin/env bash
set -aeux

DEB_BUILD_OPTIONS=nostrip debuild --no-tgz-check -uc -us
