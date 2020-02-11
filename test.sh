#!/bin/bash

go run ./main.go -s "* * * * *" -p 8080 -- /bin/bash -c "echo 1;"
