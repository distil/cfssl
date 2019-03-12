#!/usr/bin/env bash

set -eu

NO_BUILD="0"

if [ "${1:-novalue}" = "--no-build" ]; then
    shift
    NO_BUILD="1"
    echo "Skipping building docker-container"
fi
CMD="${*:-./build}"

if [ "$NO_BUILD" != "1" ]; then
    docker build --tag distil/cfssl .
fi
docker run \
    -i \
    --rm \
    -v "$(pwd):/home/go/src/github.com/distil/cfssl" \
    distil/cfssl \
    $CMD
