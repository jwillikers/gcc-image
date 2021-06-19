#!/usr/bin/env bash
set -o errexit

echo "Compiling test program"
podman run --userns keep-id --rm --volume "$PWD":/home/user:Z --name test-container localhost/gcc g++ test/main.cpp

echo "Running test program"
podman run --userns keep-id --rm --volume "$PWD":/home/user:Z --name test-container localhost/gcc ./a.out

echo "Cleaning up"
rm a.out
