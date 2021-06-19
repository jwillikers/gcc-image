#!/usr/bin/env bash
set -o errexit

echo "Compiling test program"
podman run --security-opt label=disable --rm --volume "$PWD":/home/user --name test-container localhost/gcc g++ test/main.cpp

echo "Running test program"
podman run --security-opt label=disable --rm --volume "$PWD":/home/user --name test-container localhost/gcc ./a.out

echo "Cleaning up"
rm a.out
