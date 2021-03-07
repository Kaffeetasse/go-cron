#!/bin/sh -e

TARGETS="linux-amd64 linux-arm64 linux-arm linux-386 linux-s390x linux-ppc64le darwin-amd64 darwin-arm64 windows-amd64"
STATIC_TARGETS="linux-amd64 linux-arm64 linux-arm linux-386 linux-s390x linux-ppc64le"
BUILD=`git rev-parse --short HEAD`
VERSION=`git describe --tags`
MAIN_GO="main.go"
DEPS="github.com/robfig/cron"

cd $(dirname $0)
rm -vfR dist
mkdir -vp dist

for TARGET in $TARGETS; do
	GOOS=${TARGET%-*} GOARCH=${TARGET#*-} go build -o dist/go-cron-$TARGET -ldflags "-X main.build=$BUILD -X main.version=$VERSION" "$MAIN_GO"
done
for TARGET in $STATIC_TARGETS; do
	CGO_ENABLED=0 GOOS=${TARGET%-*} GOARCH=${TARGET#*-} go build -o dist/go-cron-$TARGET-static -ldflags "-X main.build=$BUILD -X main.version=$VERSION"' -extldflags "-static"' "$MAIN_GO"
done
gzip -v -k -9 dist/go-cron-*
