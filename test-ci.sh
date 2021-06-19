#!/usr/bin/env bash
set -o errexit

echo "Compiling test program"
podman run --rm --volume "$PWD":/home/user --name test-container -t localhost/gcc g++ test/main.cpp

echo "Running test program"
podman run --rm --volume "$PWD":/home/user --name test-container -t localhost/gcc ./a.out

echo "Cleaning up"
rm a.out
