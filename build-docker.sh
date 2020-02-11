#!/bin/sh -e

cd $(dirname $0)

exec docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang ./build.sh
