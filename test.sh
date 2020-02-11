#!/bin/bash

go run ./main.go "* * * * * *" /bin/bash -c "echo 1;"
