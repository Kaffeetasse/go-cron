#!/bin/bash

set -e

BUILD="${GITHUB_SHA:0:7}"
VERSION="$GITHUB_REF_NAME"
MAIN_GO="main.go"
DEPS="github.com/robfig/cron"

cd $(dirname $0)
rm -vfR dist
mkdir -vp dist

if [ -z "$BUILD" -o -z "$VERSION" ]; then
	BUILD=`git rev-parse --short HEAD`
	VERSION=`git describe --tags`
fi

source ./config.inc.sh

for TARGET in $TARGETS; do
	GOOS=${TARGET%-*} GOARCH=${TARGET#*-} go build -o dist/go-cron-$TARGET -ldflags "-X main.build=$BUILD -X main.version=$VERSION" "$MAIN_GO"
done
for TARGET in $STATIC_TARGETS; do
	CGO_ENABLED=0 GOOS=${TARGET%-*} GOARCH=${TARGET#*-} go build -o dist/go-cron-$TARGET-static -ldflags "-X main.build=$BUILD -X main.version=$VERSION"' -extldflags "-static"' "$MAIN_GO"
done
gzip -v -k -9 dist/go-cron-*
