#!/bin/sh

set -e

cd $(dirname $0)/..

go run ./main.go -s "* * * * *" -p 8080 -- /bin/bash -c "echo 1;"
