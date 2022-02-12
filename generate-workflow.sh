#!/bin/sh

set -e

cd $(dirname $0)
source ./config.inc.sh
WORKFLOW_FILE=".github/workflows/build-release.yml"

cat > "$WORKFLOW_FILE" << EOF
name: Build release
on:
  push:
    tags:
      - 'v*'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Prepare environment
        uses: actions/setup-go@v2
        with:
          go-version: '^1.17.7'
      - name: Build project
        run: ./build.sh
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: \${{ github.ref }}
          release_name: \${{ github.ref }}
          draft: false
          prerelease: false
EOF
for TARGET in $TARGETS; do cat >> "$WORKFLOW_FILE" << EOF
      - name: Upload asset for $TARGET
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: \${{ steps.create_release.outputs.upload_url }}
          asset_path: ./dist/go-cron-$TARGET.gz
          asset_name: go-cron-$TARGET.gz
          asset_content_type: application/gzip
EOF
done

for TARGET in $STATIC_TARGETS; do cat >> "$WORKFLOW_FILE" << EOF
      - name: Upload static asset for $TARGET
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: \${{ steps.create_release.outputs.upload_url }}
          asset_path: ./dist/go-cron-$TARGET-static.gz
          asset_name: go-cron-$TARGET-static.gz
          asset_content_type: application/gzip
EOF
done