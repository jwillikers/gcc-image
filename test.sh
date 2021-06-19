#!/usr/bin/env bash
set -o errexit

podman run --userns keep-id --rm --volume "$PWD":/home/user:Z --name test-container localhost/gcc g++ test/main.cpp
podman run --userns keep-id --rm --volume "$PWD":/home/user:Z --name test-container localhost/gcc ./a.out
rm a.out
